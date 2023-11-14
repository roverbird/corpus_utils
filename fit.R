# This is an R script to estimate k and p parameters for NBD (Negative Binomial Distribution)
# assuming that word frequency distributions follow NBD
# Usage: Rscript myscript.R /path/to/inputfile.txt /path/to/outputfile.txt

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

# Initialize vectors for size, probability, and sqrt_kp
vsize <- numeric(0)
vprob <- numeric(0)
sqrt_kp <- numeric(0)

# Iterate through columns of the transposed data
for (i in c(1:nrow(filet))) {
  # Extract numeric data from the current column, excluding the first element
  file <- as.numeric(filet[i, -(1:1)])

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

# Create a data frame with word, size, probability, and sqrt_kp
# If you want to print actual word frequencies (such as for diagnositcs, change to this: "filet[, ]" )
d <- data.frame(word = filet[,0], k = vsize, p = vprob, sqrt_kp = sqrt_kp)

# Write the results to a tab-separated file
write.table(d, file = output_file, sep = "\t")

