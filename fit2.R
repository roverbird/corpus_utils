# This is an R script to estimate k and p parameters for NBD (Negative Binomial Distribution)
# assuming that word frequency distributions follow NBD
# Usage: Rscript myscript.R /path/to/inputfile.txt /path/to/outputfile.txt
# WARNING! Running this script can be compute-intensive operation, use at your own risk. 
# No liability of any kind.

# Load the bbmle library
library("bbmle")

# Check if both input and output file names are provided
if (length(commandArgs(trailingOnly = TRUE)) < 2) {
  stop("Please provide both input and output file names as command line arguments.")
}

# Get the input and output file names from the command line
input_file <- commandArgs(trailingOnly = TRUE)[1]
output_file <- commandArgs(trailingOnly = TRUE)[2]


# Read word frequencies from a flat text file
file1 <- read.table(file = input_file, head = TRUE, sep = " ", encoding = "UTF-8", fileEncoding = "UTF-8")

# Transpose the data for easier processing
filet <- t(file1)

# Define the negative log-likelihood function for Negative Binomial Distribution
minuslogl <- function(size, prob, x) {
  -sum(dnbinom(x = x, size = size, prob = prob, log = TRUE))
}

# Initialize vectors for size, probability, and sqrt_kp, sum, and document frequency (DF)
vsize <- numeric(0)
vprob <- numeric(0)
sqrt_kp <- numeric(0)
sum_vector <- numeric(0)
doc_freq <- numeric(0)

# Iterate through columns of the transposed data
for (i in c(1:nrow(filet))) {
  # Extract numeric data from the current column
  file <- as.numeric(filet[i, ])

  # Calculate the sum for the current column
  sum_vector[i] <- sum(file)

  # Calculate the document frequency for the current column
  # DF (document frequency) is in how many document a word is found
  doc_freq[i] <- sum(file != 0)

 # Calculate the word frequency to document frequency ratio (DF/WF) for each word
 # Avoid division by zero by setting ratio to zero when sum_vector is zero
  df_wf_ratio <- ifelse(sum_vector == 0, 0, doc_freq / sum_vector)

  # Check if there is variability in the data
  if (var(file) == 0) {
    vsize[i] <- NaN
    vprob[i] <- NaN
    sqrt_kp[i] <- NaN
  } else {
    # Fit Negative Binomial Distribution using maximum likelihood estimation
    m <- mle2(
      minuslogl = minuslogl,
      start = list(size = 0.01, prob = 0.01),
      data = list(x = file),
      method = "L-BFGS-B",
      lower = list(size = 1e-4, prob = 1e-4),
      upper = list(size = 1e+5, prob = 0.9999)
    )

    # Store the estimated parameters and calculate sqrt_kp
    vsize[i] <- coef(m)[1]
    vprob[i] <- coef(m)[2]
    sqrt_kp[i] <- sqrt(vsize[i] * vsize[i] + vprob[i] * vprob[i])
  }
}

 # Calculate Composite Relevance Index for each word
 # Avoid division by zero by setting ratio to zero when sum_vector is zero
 # cpi_calculate <- ifelse(sum_vector == 0, 0, sqrt_kp * df_wf_ratio)

# Assuming 'cpi_calculate' is a vector of CPI values
# Determine quartiles dynamically
# quartiles <- quantile(cpi_calculate, probs = c(0, 0.25, 0.5, 0.75, 1))

# Categorize CPI values
# cpi_categories <- cut(cpi_calculate,
#                      breaks = quartiles,
#                      labels = c("VLowCPI", "LowCPI", "MediumCPI", "HighCPI"),
#                      include.lowest = TRUE)


# Specify the number of clusters (you can adjust this based on your requirements)
num_clusters <- 10

# Create a data frame with word, size, probability, and sqrt_kp
# If you want to print actual word frequencies (such as for diagnositcs, change to this: "filet[, ]" )
# d <- data.frame(word = filet[, 0], k = vsize, p = vprob, sqrt_kp = sqrt_kp, sum = sum_vector, df = doc_freq, df_wf = df_wf_ratio, cpi = cpi_calculate, cpi_cat = cpi_categories)
# d <- data.frame(word = filet[, 0], k = vsize, p = vprob, sqrt_kp = sqrt_kp, sum = sum_vector, df = doc_freq, df_wf = df_wf_ratio, cluster = cluster)

### No we will cluster words according to k, p and df to wf ratio!
# Create a data frame with vsize and vprob
cluster_data <- data.frame(vsize, vprob)

# Perform k-means clustering using k and p, $DF
kmeans_result <- kmeans(cluster_data, centers = num_clusters)

# Get the sum of squared distances for each cluster
ssd_per_cluster <- apply(kmeans_result$centers, 1, function(centroid) sum((cluster_data - centroid)^2))

# Order clusters based on sum of squared distances
ordered_clusters <- order(ssd_per_cluster)

# Map original cluster numbers to ordered cluster numbers
cluster_order_mapping <- match(kmeans_result$cluster, ordered_clusters)

# Add the ordered cluster assignment to the original data
cluster_data$ordered_cluster <- as.factor(cluster_order_mapping)

# Add the cluster assignment to the original data
#cluster_data$cluster <- as.factor(kmeans_result$cluster)

# Write the header to the output file
header <- "word\tk\tp\tsqrt_kp\tsum\tDF\tDFtoWF\tcluster"
write(header, file = output_file)

# Create a data frame with word, size, probability, and sqrt_kp
d <- data.frame(
  word = filet[, 0],  # First column contains words; to print actual word frequencies (such as for diagnositcs, change to this: "filet[, ]" )
  k = vsize,
  p = vprob,
  sqrt_kp = sqrt_kp,
  sum = sum_vector,
  df = doc_freq,
  df_wf = df_wf_ratio,
  # cluster = cluster_data$cluster  # Use the cluster assignment from cluster_data
  ordered_cluster = cluster_data$ordered_cluster
)

# Write the results to a tab-separated file with custom column names in the header
write.table(d, file = output_file, sep = "\t", quote = FALSE, row.names = TRUE, col.names = FALSE, append = TRUE)

