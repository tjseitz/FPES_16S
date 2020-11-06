# FPES_16S
Working with 16S data in Qiime2 and R



## Filtering data in QIIME2 


Working with the intitial feature table, we want to filter our feature table based on a few different criteria. 
Ultimately we will filter out:

1. Chimeras
2. Samples with fewer than 13000 reads (3 samples)
3. Any QC, perm, or FPES2020 samples
4. Mitochondrial or chloroplast reads 
5. Features that are seen less than 5 times across all samples

### 1. Remove chimeras

Create qza with chimeric features in this dataset

```
qiime vsearch uchime-denovo --i-table table.qza --i-sequences rep-seqs.qza --output-dir uchime-dn-out
```

Remove previously identified chimeras from dataset

```
qiime feature-table filter-features \
--i-table table.qza \
--m-metadata-file uchime-dn-out/nonchimeras.qza \
--o-filtered-table uchime-dn-out/table-nonchimeric-wo-borderline.qza
```


### 2. Remove samples with fewer than 13000 reads

Samples include GHE , GHE , and GHE .
```
qiime feature-table filter-samples \
--i-table uchime-dn-out/table-nonchimeric-wo-borderline.qza \
--p-min-frequency 13000 \
--o-filtered-table table-13000.qza
```

### 2. Remove samples that aren't of interest

Filter out any QC, permafrost, or FPES 2020 samples. We should only be left with 93 FPES samples from 2018 and 2019. 
```
qiime feature-table filter-samples \
--i-table table-13000.qza \
--m-metadata-file samples-to-keep.tsv \
--o-filtered-table table-13000-fpes.qza
```

### 3. Remove reads that were classified as mitochondrial or chloroplast in origin
```
qiime taxa filter-table \
--i-table table-13000-fpes.qza \
--i-taxonomy taxonomy.qza \
--p-exclude mitochondria \
--o-filtered-table table-13000-fpes-nomito.qza
```

### 4. Filter out features seen <5 times
```
qiime feature-table filter-features \
> --i-table table-13000-fpes-nomito.qza \
> --p-min-frequency 5 \
> --o-filtered-table freq-filt-table.qza 
```
