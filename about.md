# Corpus Utilities

This repository contains a set of utility scripts for corpus linguistics tasks. It includes scripts:

1. **compress.py**: Combines texts from separate files, performs elementary parsing, and removes punctuation marks. The processed text is then saved as `output.txt` for further analysis.

2. **wordstats.py**: Analyzes the word frequency distribution in the `output.txt` file and generates statistics. The results are saved in a text file with fields separated by spaces.

## Usage

### compress.py

To combine texts and prepare `input.txt`:

bash
```
python compress.py /path/to/texts output.txt
```

This script takes text files from the specified directory, combines them, performs parsing, and removes punctuation marks. The resulting processed text is saved as output.txt.

### wordstats.py

To count word frequencies and generate statistics:

bash
```
python word_freq_stats.py input.txt output_stats.txt min_frequency max_frequency
```

### Research Publication

The scripts in this repository were utilized in the following research publication:

**Title:** [The Negative Binomial Model of Word Usage](http://siba-ese.unisalento.it/index.php/ejasa/article/view/12119)
**Authors:** Nina Alexeyeva, Alexandre Sotov
**Abstract:** How people make texts is a rarely asked but central question in linguistics. From the language engineering perspective texts are outcomes of stochastic processes. A cognitive approach in linguistics holds that the speaker’s intention is the key to text formation. We propose a biologically inspired statistical formulation of word usage that brings together these views. We have observed that in several multilingual text collections word frequency distributions in a majority of non-rare words fit the negative binomial distribution (NBD). However, word counts in artificially randomized (permuted) texts agree with the geometric distribution. We conclude that the parameters of NBD deal with linguistic features of words. Specifically, named entities tend to have similar parameter values. We suggest that the NDB in natural texts accounts for intentionality of the speaker.

**DOI Code:** 10.1285/i20705948v6n1p84

**Keywords:** word frequency; negative binomial distribution (NBD); text randomization

