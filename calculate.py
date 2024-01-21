# This calculates sum, mean, variance, and dispersion for each word-token
# This also estimated Negative Binomial Parameters k and p using 
# method of moments. These estimations are infrerior to Maximum likelihood method
# but they are easy to implement without R.
# Input is read from space-separated file (word matrix) prepared by wordstats.py


import csv
import sys
from math import sqrt


# Check that both input and output filenames, were provided
if len(sys.argv) != 3:
    print('Usage: python calculate.py input_file output_file. Input must be tab-separated.')
    sys.exit()

# Get the filenames and frequency values from the command-line arguments
input_file = sys.argv[1]
output_file = sys.argv[2]

# Read data from the input file
with open(input_file, 'r', newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=' ')
    header = next(reader)  # Assuming the first row is the header
    data = {word: [] for word in header}

    for row in reader:
        for i, value in enumerate(row):
            if value.strip():  # Check if the value is not an empty string
                data[header[i]].append(int(value))

with open(output_file, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    writer.writerow(['word', 'sum', 'mean', 'variance', 'dispersion', 'k', 'p', 'sqrt_kp'])

    for word in header:
        col_values = data[word]
        t = len(col_values)

        # Calculate statistical values
        summa = sum(col_values)
        mean = summa / t
        variance = sum((x - mean) ** 2 for x in col_values) / (t - 1)
        dispersion = variance ** 0.5
        # Estimate k and p using the method of moments
        k = ((mean**2) / (variance - mean)) if (variance - mean) != 0 else float('inf')
        p = (mean / variance) if variance != 0 else float('inf')
        sqrt_kp = sqrt( (k**2) + (p**2) )

        writer.writerow([word, summa, mean, variance, dispersion, k, p, sqrt_kp])

