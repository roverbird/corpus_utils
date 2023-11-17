# Plot3Dca2.R offers improved visualisation of input data.
#It creates 3D scatterplot and allows for control of data filters.
# Usage: Rscript plot3Dcat2.R input.txt output.png 300
# 300 is the projection angle
# Try experimenting with this value to look around.
# Z-axis id Document Frequency (DF), the higher the value, the more
# text in the corpus contain the word.
# X and Y are NBD parameterd induced from data.

# Check if both input and output file names are provided
if (length(commandArgs(trailingOnly = TRUE)) < 3) {
  stop("Please provide input.txt, output.png, rotation angle, set filters inside the script")
}

############################################################
# IMPORTANT! Set filters here!
# fr is Word Frequency 
# df is Document Frequency
# k and p are NBD parameters
# Values to map all data: k > 0 & p > 0 & fr > 1 & df > 1 
# Values to map content background words: k > 5 & p > 0.8
# Values to map names of heros: k < 0.1 & p < 0.1 
############################################################
filters <- expression(k > 0 & p > 0 & fr > 50 & df < 500)

# Get the input and output file names from the command line
input_file <- commandArgs(trailingOnly = TRUE)[1]
output_file <- commandArgs(trailingOnly = TRUE)[2]
angle <- as.numeric(commandArgs(trailingOnly = TRUE)[3])
#threshold <- as.numeric(commandArgs(trailingOnly = TRUE)[4])
#fr_threshold <- as.numeric(commandArgs(trailingOnly = TRUE)[5])

# Read the data from input file
data <- read.table(input_file, sep = "\t", header = TRUE)

# Extract columns k, p, DF, sum, CPI
x_values <- data$k
y_values <- data$p
z_values <- data$DF
fr <- data$sum
df <- data$DF

# Load filters
filtered_data <- subset(data, eval(filters))

# Extract columns k, p, DF, sum, and CPIcat from the filtered data
x_values <- filtered_data$k  # Apply log scale to x-axis
y_values <- filtered_data$p
z_values <- filtered_data$DF # Apply log scale to z-axis
fr <- filtered_data$sum
#categories <- filtered_data$CPIcat  # New line to extract the CPIcat column

# Set up PNG output file
png(
  file = output_file,
  width = 7000,  # Adjusted for landscape orientation (in pixels)
  height = 4000,  # Adjusted for landscape orientation (in pixels)
  units = "px",  # Set units to pixels
  res = 800,  # Adjusted for high DPI (dots per inch)
  pointsize = 2.1
)

# Set margins
par(mar = c(10, 10, 10, 10) + 2)  # c(bottom, left, top, right) + extra space

# 3D Plot
library(scatterplot3d)

# Create a color palette for the four categories
#color_palette <- c("blue", "green", "orange", "red")

# Map categories to colors
#category_colors <- color_palette[as.numeric(factor(categories, levels = c("VLowCPI", "LowCPI", "MediumCPI", "HighCPI"))) ]

# Set the transparency level (alpha) for points
alpha <- 0.13  # Adjust the transparency level as needed (0 = fully transparent, 1 = opaque)

# Create a color vector with opacity
point_colors <- rgb(0, 0, 1, alpha = alpha)

# Create the scatter plot with color-coded points
scatterplot <- scatterplot3d(
  x = x_values,
  y = y_values,
  z = z_values,
  color = point_colors,
  main = paste("\nSemantic Space Map for input file:", input_file, " View angle:", angle," \nFilters: ", filters, " Change filter settings in script"),
  xlab = colnames(data)[2],
  ylab = colnames(data)[3],
  zlab = colnames(data)[6],
  #pch = 1,
  #cex = 200,
  cex.main = 3,
  cex.lab = 2,
  cex.axis = 2,
  angle = angle,
  grid = TRUE,
  col.grid = "grey",
  col.axis = "grey",
  box = FALSE,
  tick.marks = TRUE,
  label.tick.marks = TRUE,
  mar = c(5, 5, 4, 4) + 1.5  # Adjust the margin to move axis titles outward
)

# Add regression pane
scatterplot$plane3d(lm(z_values ~ x_values + y_values), col = "grey")

# Working on points. Scale the size depending on word frequency
scaled_size <- 1 + 10 * (fr - min(fr)) / (max(fr) - min(fr))

# Add points with adjusted size and opacity
points(scatterplot$xyz.convert(x_values, y_values, z_values), pch = 20, col = point_colors, cex = scaled_size)

# Set word label size depending of document frequency
normalized_df <- (df - min(df)) / (max(df) - min(df))  # Normalize values between 0 and 1
label_size <- 1 + 2 * normalized_df  # Adjust the scaling factor as needed

# Add labels on the side with random positions so they do not collide
set.seed(123)  # Set a seed for reproducibility, change if needed
random_pos <- runif(n = length(filtered_data$word), min = 1, max = 5)  # Adjust min and max as needed

# Print word labels
text(
  scatterplot$xyz.convert(x_values, y_values, z_values),
  labels = filtered_data$word,
  pos = random_pos,
  col = "blue",
  cex = label_size
)

# Save the plot
dev.off()

