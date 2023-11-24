# Load Project Gutenberg books for corpus analysis

import requests
import os
import re

######################################################################
# ADD BOOK HERE 
# Go to site https://www.gutenberg.org/
# Find a book and look for "Plain Text UTF-8" link
# URL for the Gutenberg book txt
 https://gutenberg.org/cache/epub/2554/pg2554.txt  # Crime and Punishment
# https://www.gutenberg.org/cache/epub/2600/pg2600.txt # War and Peace
# https://gutenberg.org/cache/epub/11/pg11.txt # Alice in Wonderland
# https://gutenberg.org/cache/epub/1399/pg1399.txt # Anna Karenina
# https://gutenberg.org/cache/epub/28054/pg28054.txt # Brothers Karamazov
# url = "https://www.gutenberg.org/cache/epub/28054/pg28054.txt"


# Extract the last part of the URL as the output file name
output_file_name = os.path.basename(url).split('.')[0]

# Download the text
response = requests.get(url)
response.encoding = 'utf-8'
text = response.text

# Step 1: Replace Chapter breaks with a placeholder

text = re.sub(r'\r\nChapter', '\r\n', text, flags=re.IGNORECASE)
text = re.sub(r'\r\n\r\n\r\n', '<<CHAPTER_BREAK>>', text)

#text = re.sub(r'\n\n\n\n\n\n', '<<CHAPTER_BREAK>>', text)

#text = re.sub(r'\nChapter', '\n', text, flags=re.IGNORECASE)
#text = re.sub(r'\n\nChapter', '<<CHAPTER_BREAK>>', text)


# Step 2: Remove empty lines containing whitespace characters and any remaining \n or \r
text = ' '.join(line.strip() for line in text.splitlines() if line.strip())

# Step 3: Split the text into chapters treating placeholder as a chapter break
chapters = re.split(r'<<CHAPTER_BREAK>>', text)

# Filter out chapters smaller than 900 characters
chapters = [chapter for chapter in chapters if len(chapter) >= 800]

# Create a directory to save the chapters
#output_directory = "gutenberg_chapters"
#os.makedirs(output_directory, exist_ok=True)

# Save all chapters into a single file
#output_filepath = os.path.join(output_directory, f"{output_file_name}_output.txt")
#with open(output_filepath, 'w', encoding='utf-8') as output_file:
#    output_file.write('\n'.join(chapters))

# Save all chapters into a single file in the current directory
output_filepath = f"{output_file_name}_output.txt"
with open(output_filepath, 'w', encoding='utf-8') as output_file:
    # Write all chapters except the last one to remove Gutenberg licence file
    output_file.write('\n'.join(chapters[:-1]))

print(f"All chapters with at least 800 characters saved successfully in a single file: {output_filepath}")
