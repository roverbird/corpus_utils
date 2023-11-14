# This script converts text file to lowercase and replaces punctuation characters with spaces, 
# counts the frequency of each word in each line and in the entire text, and outputs list of words 
# that occur between 3 and 100,000 times and the frequency of each of these words in each line.
#
# Each column of the resulting file contains the word token and its frequency in each separate file
# So each column can then be used for distribution model fitting.
#
# You can open resulting file with stats as csv with fields separated by tabs. 
#
# This script is used together with compress.py which prepares text collection for this script
# 
# Usage: python wordstats.py input.txt result.txt 3 100000 
# You can set word token frequnecy cut-off: 3 is min frequency and 100000 is max frequecy
#

import sys
import re

# Check that both input and output filenames, as well as min and max frequencies, were provided
if len(sys.argv) != 5:
    print('Usage: python program_name.py input_file_name output_file_name min_frequency max_frequency')
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

        # Loop through each word in the line
        for word in line.split():
            # Increment frequency of word in line
            l[(t, word)] = l.get((t, word), 0) + 1
            # Increment frequency of word in entire text
            g[word] = g.get(word, 0) + 1

# Open the output file
with open(output_file_name, 'w') as output_file:
    # Loop through each word in the g dictionary
    for word in list(g.keys()):
        # Delete words with frequency outside the specified range
        if g[word] < min_frequency or g[word] > max_frequency:
            del g[word]
        else:
            # Write remaining words separated by tabs to the output file
            output_file.write(word + '\t')
    output_file.write('\n')

    # Loop through each line processed
    for i in range(1, t + 1):
        # Loop through each word in the g dictionary
        for word in list(g.keys()):
            # Write frequency of word in line to the output file
            output_file.write(str(l.get((i, word), 0)) + '\t')
        output_file.write('\n')

    print("Word frequency calculation complete. Output saved to", output_file)
