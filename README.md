# corpus_utils

Word frequency calculation tools for corpus linguistics. It includes scripts:

**compress.py**: Combines txt files into a "corpus", performs elementary parsing, and removes punctuation marks. The processed text is then saved for further analysis.

**wordstats.py**: Prepares word frequency lists. The results are saved to a text file.

**calculate.py**: Get some statistics from word frequencies.

**fit.R**: R script to estimate k and p parameters for NBD (Negative Binomial Distribution) assuming that word frequency distributions follow NBD

**plot.R**: R script to draw plots from data prepared by fit.R

**plot3D.R**: R script to draw 3D plots from data prepared by fit.R

## Usage

### compress.py

Combine texts and prepare `corpus.txt`, the text corpus file:

bash
```
python ~/corpus_utils/compress.py /path/to/texts corpus.txt
```

This script takes text files from the specified directory, combines them, performs parsing, and removes punctuation marks.

### wordstats.py

Count word frequencies:

bash
```
python ~/corpus_utils/wordstats.py corpus.txt frequencies.txt 3 10000
```
Here, min word token frequency is 3, max word token frequency is 10000. For larger corpora it is recommended to set min frequency to a larger value.

### calculate.py

Now data is ready, we can calculate sum, mean, variance, and dispersion for each word-token. Input file, frequencies.txt, must be space-separated.

bash
```
python ~/corpus_utils/calculate.py frequencies.txt final_stats.txt
```
### fit.R

Using prepared data, estimate k and p parameters for NBD. Calculate sum for each word-token (absolute frequency in texts) and Document Frequency (DF). This is a compute-intensive operation and may take some time, especially for a larger dataset file. Run at your own risk.

bash
```
Rscript ~/corpus_utils/fit.R frequencies.txt results.tab

```
### plot.R


Plot.R creates scatterplot from data, which was prepared using fit.R 

bash
```
Rscript plot.R input.txt output.png 0.1
```

In this example, 0.1 is thresholp value of NBD parameters k and p. Try experimenting with this value to zoom in and out of the plot. Interesting values are between 0.1 and 0.7, see graphs in the repo.

### plot3D.R


Plot3D.R creates 3D scatterplot from data, which was prepared using fit.R, where x axis is parameter k, y - parameter p, and z - Document Frequency (DF) The higher the DF, the more texts in the coprus contain the word. So, widespread words have higher DF value. This is not to be confused with absolute frequency of the word, measured by 'sum' in data prepared with fit.R

bash
```
Rscript plot3D.R input.txt output.png 20 0.1
```

In this example, **20** is rotation angle of the scatterplot, **0.1** is thresholp value of NBD parameters k and p. Try experimenting with this value to zoom in and out of the plot. Interesting values are between 0.1 and 0.7, see graphs in the repo.

### Add-ons

There are directories with addons. 
**texts**: this is how individual text can look before you combine them in to a corpus file with compress.py 
**examples/corpora**: a readily prepared corpus of fairy tales, you can run wordstats.py, fit.R and plot.R on it
**examples/graphs**: graphs from fairy tales corpora generated by plot.R

### Research Publication

The scripts in this repository reproduce the following research:

**Title:** [The Negative Binomial Model of Word Usage](http://siba-ese.unisalento.it/index.php/ejasa/article/view/12119)
**Authors:** Nina Alexeyeva, Alexandre Sotov
**Abstract:** How people make texts is a rarely asked but central question in linguistics. From the language engineering perspective texts are outcomes of stochastic processes. A cognitive approach in linguistics holds that the speaker’s intention is the key to text formation. We propose a biologically inspired statistical formulation of word usage that brings together these views. We have observed that in several multilingual text collections word frequency distributions in a majority of non-rare words fit the negative binomial distribution (NBD). However, word counts in artificially randomized (permuted) texts agree with the geometric distribution. We conclude that the parameters of NBD deal with linguistic features of words. Specifically, named entities tend to have similar parameter values. We suggest that the NDB in natural texts accounts for intentionality of the speaker.

**DOI Code:** 10.1285/i20705948v6n1p84

**Keywords:** word frequency; negative binomial distribution (NBD); text randomization

