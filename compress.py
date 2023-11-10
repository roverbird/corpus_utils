# This script looks through directory, takes each file, gets rid or any html tags, parses it to text only, 
# removes all new lines or line returns so that text is one line only, and concatenates it to single file
#
# Make sure, you have only html or txt files in the directory with texts. Examples of what data to use: 
# a collection of news articles; a chapter of a novel in a separate file; all poems of an author: each in
# a separate file; reviews for the same film: each in a separate file; and so on.
#
# Usage: python compress.py /path/to/your/directory output.txt
#
# Try running this script on the test files included in this repo
#

import os
import re
import sys

def clean_html_tags(text):
    clean = re.compile('<.*?>')
    return re.sub(clean, '', text)

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
        content = clean_html_tags(content)
        content = content.replace('\n', ' ').replace('\r', '')  # Remove new lines and line returns
        return content

def process_directory(input_directory, output_file):
    with open(output_file, 'w', encoding='utf-8') as output:
        # List all files in the directory
        filenames = os.listdir(input_directory)

        # Sort files numerically and then alphabetically
        filenames = sorted(filenames, key=lambda x: (int(re.search(r'\d+', x).group()) if re.search(r'\d+', x) else float('inf'), x))

        for filename in filenames:
            if filename.endswith('.txt'):  # Process only text files
                file_path = os.path.join(input_directory, filename)
                processed_content = process_file(file_path)
                output.write(processed_content + '\n')

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_directory> <output_file>")
        sys.exit(1)

    input_directory = sys.argv[1]
    output_file = sys.argv[2]

    if not os.path.exists(input_directory):
        print(f"The specified input directory '{input_directory}' does not exist.")
        sys.exit(1)

    process_directory(input_directory, output_file)

    print("Texts processing complete. Output saved to", output_file)

