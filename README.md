# corpus_utils

Word frequency calculation tools for corpus linguistics. It includes scripts:

**compress.py**: Combines txt files into a "corpus", performs elementary parsing, and removes punctuation marks. The processed text is then saved for further analysis.

**wordstats.py**: Analyzes the word frequency distribution in corpus file and word frequency lists. The results are saved in a text file with fields separated by tabs.

**calculate.py**: Get some statistics from word frequencies.

## Usage

### compress.py

Combine texts and prepare `corpus.txt`:

bash
```
python compress.py /path/to/texts corpus.txt
```

This script takes text files from the specified directory, combines them, performs parsing, and removes punctuation marks.

### wordstats.py

Count word frequencies:

bash
```
python wordstats.py corpus.txt frequencies.txt min_frequency max_frequency
```

### calculate.py

Now data is ready, we can calculate sum, mean, variance, and dispersion for each word-token. Input file must be in tab-separated format.

bash
```
python calculate.py frequencies.txt final_stats.txt
```

### Research Publication

The scripts in this repository reproduce the following research:

**Title:** [The Negative Binomial Model of Word Usage](http://siba-ese.unisalento.it/index.php/ejasa/article/view/12119)
**Authors:** Nina Alexeyeva, Alexandre Sotov
**Abstract:** How people make texts is a rarely asked but central question in linguistics. From the language engineering perspective texts are outcomes of stochastic processes. A cognitive approach in linguistics holds that the speaker’s intention is the key to text formation. We propose a biologically inspired statistical formulation of word usage that brings together these views. We have observed that in several multilingual text collections word frequency distributions in a majority of non-rare words fit the negative binomial distribution (NBD). However, word counts in artificially randomized (permuted) texts agree with the geometric distribution. We conclude that the parameters of NBD deal with linguistic features of words. Specifically, named entities tend to have similar parameter values. We suggest that the NDB in natural texts accounts for intentionality of the speaker.

**DOI Code:** 10.1285/i20705948v6n1p84

**Keywords:** word frequency; negative binomial distribution (NBD); text randomization

