# Plot.R creates scatterplot from data, which was prepared using fit.R
# Usage: Rscript plot.R input.txt output.png 0.1
# 0.1 is thresholp value of NBD parameters k and p.
# Try experimenting with this value to zoom in and out of the plot.
# Interesting values are between 0.1 and 0.7, see graphs in the repo.

# Check if both input and output file names are provided
if (length(commandArgs(trailingOnly = TRUE)) < 3) {
  stop("Please provide input.txt, output.png, and threshold as command line arguments; recommended threshold is 0.2")
}

# Get the input and output file names from the command line
input_file <- commandArgs(trailingOnly = TRUE)[1]
output_file <- commandArgs(trailingOnly = TRUE)[2]
threshold <- as.numeric(commandArgs(trailingOnly = TRUE)[3])


# Read the data from the text file
data <- read.table(input_file, sep = "\t", header = TRUE)

# Extract columns B and C
x_values <- data$k
y_values <- data$p

# Filter data based on conditions
filtered_data <- subset(data, k < threshold & p < threshold)

# Extract columns k and p from the filtered data
x_values <- log(filtered_data$k)  # Apply log scale to x-axis
y_values <- filtered_data$p

# Set up PNG output file

png(
  output_file,
  width     = 6.25,
  height    = 6.25,
  units     = "in",
  res       = 1500,
  pointsize = 2
)

# Set margins
par(mar = c(10, 10, 10, 10) + 0.1)  # c(bottom, left, top, right) + extra space

# Plot the data with larger dots
plot(x_values, y_values, main = paste("Input:", input_file, " Output:", output_file, " Threshold =", threshold, " Log scale for k value"), xlab = colnames(data)[2], ylab = colnames(data)[3], pch = 20, col = "blue", cex = 2, cex.main = 2.5, cex.lab = 2)

# Add labels to the points with random variation so that they do not collide
set.seed(123)
random_variation <- runif(length(x_values), min = -0.01, max = 0.01)  # Adjust the range as needed
text(x_values, y_values + random_variation, 
     labels = filtered_data$word, pos = 3, col = "red")

# Add labels to the points
#text(x_values, y_values, labels = filtered_data$word, pos = 3, col = "red")

# Save the plot
dev.off()

