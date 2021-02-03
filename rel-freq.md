## Obtaining and converting relative frequency tables in qiime2


### First identify what *Frequency Table* you want to use
E.g., do you want to use a collapsed taxa frequency table to look at just the phyla or families present? Or do you want to look at everything in your dataset.

In this example I will be using a taxa collapsed at the phylum level.

### Collapse frequency table

```qiime taxa collapse \
--i-table table-13000-fpes-nomito.qza \
--i-taxonomy taxonomy.qza \
--p-level 2 \
--o-collapsed-table phylum-table.qza
```

### Next we want to convert that frequency table to a *Relative Frequency Table*


```qiime feature-table relative-frequency \
--i-table phylum-table.qza \
--o-relative-frequency-table DIRECTORY/phylum-rel-freq.qza 
```

### After we have a .qza table of relative frequencies we need to export to a file usable outside of qiime2

We will do this in two steps: first export as a .BIOM file, and then convert to a .tsv

Make new directory for your biom files

`mkdir biom`

Export feature table as a biom file to new directory

```qiime tools export --input-path phylum-rel-freq.qza --output-path phylum-biom```


Convert biom to a tsv file
```biom convert -i feature-table.biom -o phylum_16s.tsv --to-tsv```

`grep -E "(f__)|(^ID)” family_16s.tsv | grep -v "g__" | sed 's/^.*f__//g' > family_16s_clean.txt

