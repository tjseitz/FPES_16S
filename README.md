# FPES 16S Qiime2 Pipeline

Here's where to find more information about Qiime2 options: [QIIME 2 for Experienced Microbiome Users](https://docs.qiime2.org/2021.4/tutorials/qiime2-for-experienced-microbiome-researchers/#otu-clustering). 

Make new directory to work in:

``` mkdir FPES_16S ```


Start by importing the demuxed reads.

```
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path FPES-manifest.txt \
--output-path demux.qza \
--input-format PairedEndFastqManifestPhred33V2
```

### Import
```
qiime demux summarize \
  --i-data qiime/paired-end-demux.qza \
  --o-visualization qiime/demux.qzv
 ```
 
 ### Denoise
 Now we're going to denoise the reads using DADA2. The features produced are ASVs.
 ``` 
  qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left-f 13 \
  --p-trim-left-r 13 \
  --p-trunc-len-f 250 \
  --p-trunc-len-r 250 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza \
  --p-n-threads 6
  
  qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv
  
  qiime feature-table tabulate-seqs \
  --i-data qiime/rep-seqs.qza \
  --o-visualization qiime/rep-seqs.qzv
```

*After denoising we end up with two of the most important files: a FeatureTable (table.qza) and FeatureData (rep-seqs.qza). We can now start to explore all of the fun things QIIME has to offer!*

### Generate a phylogenetic tree
Next we are going to generate a tree to be used for phylogenetic diversity analyses. 

  ```
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza
  ```
 After generating a tree you can skip down to the [diversity metrics section](#Diversity-metrics) or you can keep going.
  
### Assign taxonomy  
We are using the 

You can find the pre-trained classifier [here](https://docs.qiime2.org/2021.4/data-resources/) (or [https://docs.qiime2.org/2021.4/data-resources/](https://docs.qiime2.org/2021.4/data-resources/).

  ```
qiime feature-classifier classify-sklearn \
  --i-classifier silva-138-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza
 
 qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
 ```

Here you can go crazy making some nice bar plots to visualize taxonomy. Feel free to use a filtered feature table to make it easier to view/make smaller, more narrowed down plots.

```
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file FPES-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv 
```
 

### Diversity metrics

Next we are going to obtain diversity metrics. You can use the filtered table of your choosing, see some filter options [here](./filter_table.md). 

The [Moving Pictures tutorial](https://docs.qiime2.org/2021.4/tutorials/moving-pictures/) has a great description of the different diversity metrics and options you can use, as well as some further analyses you can explore.

Here I am using the "default" table.

```
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table tables.qza \
  --p-sampling-depth 14000 \
  --m-metadata-file FPES-metadata.tsv \
  --output-dir core-metrics-results
  ```
  
  For example, one of the other things to explore:
 

Alpha rarefaction plot  
  (Here I am using a table with only FPES samples where I filtered out the permafrost samples)
  
  ```
  qiime diversity alpha-rarefaction /
  --i-table FPES-only/table.qza /
  --i-phylogeny rooted-tree.qza /
  --p-max-depth 14000 /
  --m-metadata-file FPES-metadata.tsv /
  --o-visualization FPES-only/alpha-rarefaction.qzv
```
