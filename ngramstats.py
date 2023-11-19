# This script does same thing as wordstats.py but for N-grams (bigrams)
# Output can be processed by fit2.R of fit.R

import sys
import re
from itertools import zip_longest

# Check that both input and output filenames, as well as min and max bigram frequencies, were provided
if len(sys.argv) != 5:
    print('Usage: python ngramstats.py input_file_name output_file_name min_frequency max_frequency')
    sys.exit()

# Get the filenames and frequency values from the command-line arguments
input_file_name = sys.argv[1]
output_file_name = sys.argv[2]
min_frequency = int(sys.argv[3])
max_frequency = int(sys.argv[4])

# Initialize dictionaries for storing word frequencies
l = {}
g = {}

# Initialize counter for the number of lines processed
t = 0

# Function to generate n-grams from a list
def generate_ngrams(words, n):
    return list(zip_longest(*[words[i:] for i in range(n)], fillvalue=None))

# Open the input file
with open(input_file_name, 'r') as input_file:
    # Loop through each line of input
    for line in input_file:
        # Convert line to lowercase
        line = line.lower()
        # Remove all punctuation marks and replace them with spaces
        line = re.sub(r'[^\w\s]+', ' ', line)

        # Increment line counter
        t += 1

        # Split line into words
        words = line.split()

        # Generate bigrams
        bigrams = generate_ngrams(words, 2)

        # Loop through each bigram in the line
        for bigram in bigrams:
            # Increment frequency of bigram in line
            l[(t, bigram)] = l.get((t, bigram), 0) + 1
            # Increment frequency of bigram in entire text
            g[bigram] = g.get(bigram, 0) + 1

# Open the output file
#with open(output_file_name, 'w') as output_file:
#    # Loop through each bigram in the g dictionary
#    for bigram in list(g.keys()):
#        # Delete bigrams with frequency outside the specified range
#        if g[bigram] < min_frequency or g[bigram] > max_frequency:
#            del g[bigram]
#        else:
#            # Write remaining bigrams and their frequency to the output file
#            output_file.write(str(bigram) + ': ' + str(g[bigram]) + ' ')
#    output_file.write('\n')
#
#    # Loop through each line processed
#    for i in range(1, t + 1):
#        # Loop through each bigram in the g dictionary
#        for bigram in list(g.keys()):
#            # Write frequency of bigram in line to the output file
#            output_file.write(str(l.get((i, bigram), 0)) + ' ')
#        output_file.write('\n')

# Open the output file
with open(output_file_name, 'w') as output_file:
    # Loop through each bigram in the g dictionary
    for bigram in list(g.keys()):
        # Delete bigrams with frequency outside the specified range
        if g[bigram] < min_frequency or g[bigram] > max_frequency:
            del g[bigram]
        else:
            # Write remaining bigrams and their frequency to the output file
            formatted_bigram = '-'.join(map(str, bigram))
            output_file.write(f"{formatted_bigram} ") # output_file.write(f"{formatted_bigram}-{g[bigram]} ")
    output_file.write('\n')

    # Loop through each line processed
    for i in range(1, t + 1):
        # Loop through each bigram in the g dictionary
        for bigram in list(g.keys()):
            # Write frequency of bigram in line to the output file
            output_file.write(str(l.get((i, bigram), 0)) + ' ')
        output_file.write('\n')


# Now, open the file in write mode and remove the last column using strip()
with open(output_file.name, "r+") as file:
    lines = file.readlines()
    file.seek(0)
    for line in lines:
        # Remove the last column by stripping the trailing whitespace
        file.write(line.rstrip() + '\n')
    file.truncate()

print("Ngram frequency calculation complete. Output saved to", output_file)

