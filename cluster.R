# Use this to cluster data after NBD parameters k and p are estimated

# Check if both input and output file names are provided
if (length(commandArgs(trailingOnly = TRUE)) < 2) {
  stop("Please provide both input and output file names as command line arguments.")
}

# Get the input and output file names from the command line
input_file <- commandArgs(trailingOnly = TRUE)[1]
output_file <- commandArgs(trailingOnly = TRUE)[2]

data <- read.table(input_file, sep = "\t", header = TRUE)

# Specify the number of clusters (you can adjust this based on your requirements)
num_clusters <- 8

# Perform k-means clustering using columns $k, $p, $DF
kmeans_result <- kmeans(data[, c("k", "p")], centers = num_clusters)

# Add the cluster assignment to the original data
data$cluster <- as.factor(kmeans_result$cluster)

# Print the cluster centers
#cat("Cluster Centers:\n", file = output_file)
#write.table(kmeans_result$centers, file = output_file, append = TRUE)

# Print the cluster assignments for each word
#cat("Cluster Assignments:\n", file = output_file)
write.table(data[, c("word", "cluster", "k", "p")], file = output_file, append = FALSE, row.names = FALSE)

