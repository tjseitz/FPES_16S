# FPES 16S Qiime2 Pipeline

Make new directory to work in

``` mkdir FPES_16S ```


Start by importing the demuxed reads.
```
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path FPES-manifest.txt \
--output-path demux.qza \
--input-format PairedEndFastqManifestPhred33V2
```

```
qiime demux summarize \
  --i-data qiime/paired-end-demux.qza \
  --o-visualization qiime/demux.qzv
 ```
 
 
 Now we're going to denoise the reads using DADA2
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
```



```
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file FPES-metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data qiime/rep-seqs.qza \
  --o-visualization qiime/rep-seqs.qzv
  
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
  ```
 
 
  ```
  qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences qiime/rep-seqs.qza \
  --o-alignment qiime/aligned-rep-seqs.qza \
  --o-masked-alignment qiime/masked-aligned-rep-seqs.qza \
  --o-tree qiime/unrooted-tree.qza \
  --o-rooted-tree qiime/rooted-tree.qza
  ```
  
  ```
  qiime feature-classifier classify-sklearn \
  --p-n-jobs 4 \
  --i-classifier silva-138-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza
  ```
  

  
  After filtering your table
  
  For example, here I am using a table with only FPES samples (I filtered out the permafrost samples):
  
  ```
  qiime diversity alpha-rarefaction /
  --i-table FPES-only/table.qza /
  --i-phylogeny rooted-tree.qza /
  --p-max-depth 14000 /
  --m-metadata-file FPES-metadata.tsv /
  --o-visualization FPES-only/alpha-rarefaction.qzv
```

Next we are going to obtain some diversity metrics. You can use the filtered table of your choosing. 

Here I am using the "default" table you first create.

```
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table tables.qza \
  --p-sampling-depth 14000 \
  --m-metadata-file FPES-metadata.tsv \
  --output-dir core-metrics-results
  ```
  
