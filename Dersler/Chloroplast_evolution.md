# Chloroplast evolution analysis

## 1. Paket Yükleme 

```
conda install bioconda::bwa bioconda::samtools bioconda::bedtools bioconda::vcftools bioconda::bcftools conda-forge::r-base conda-forge::unzip
```

## 2. Veri Toplama ve Hazırlık

### Antik kloroplast genomunu indir

Burda belirtilen link örnektir. Çalşmanıza uygun veriyi kullanın lütfen.
```
wget http://example.com/ancient_kloroplast_genome.fasta -O ancient_genome.fasta
```
### Modern kloroplast genomunu indir

Burda belirtilen link örnektir. Çalşmanıza uygun veriyi kullanın lütfen.
```
wget http://example.com/modern_kloroplast_genome.fasta -O modern_genome.fasta
```

### Okuma verilerini indir

Burda belirtilen link örnektir. Çalşmanıza uygun veriyi kullanın lütfen.
```
wget http://example.com/reads_ancient.fastq -O reads_ancient.fastq
wget http://example.com/reads_modern.fastq -O reads_modern.fastq
```

## 3. Genom İndeksleme ve Hizalama

```
bwa index ancient_genome.fasta
bwa index modern_genome.fasta
```
### Antik kloroplast okuma verilerini hizalayın
```
bwa mem ancient_genome.fasta reads_ancient.fastq > aligned_ancient.sam
```
### SAM dosyasını BAM formatına dönüştür
```
samtools view -Sb aligned_ancient.sam > aligned_ancient.bam
```
### BAM dosyasını sortlayın
```
samtools sort aligned_ancient.bam -o aligned_ancient_sorted.bam
```
### BAM dosyasını indeksleyin
```
samtools index aligned_ancient_sorted.bam
```
### Modern kloroplast okuma verilerini hizalayın
```
bwa mem modern_genome.fasta reads_modern.fastq > aligned_modern.sam
```
### SAM dosyasını BAM formatına dönüştür
```
samtools view -Sb aligned_modern.sam > aligned_modern.bam
```
### BAM dosyasını sortlayın
```
samtools sort aligned_modern.bam -o aligned_modern_sorted.bam
```
### BAM dosyasını indeksleyin
```
samtools index aligned_modern_sorted.bam
```
## 4. Genetik Varyasyonların Çağrılması
Genetik varyasyonları çağırır ve VCF dosyalarına dönüştürürsünüz.

### Antik kloroplast genomunda genetik varyasyonları çağırın
```
bcftools mpileup -f ancient_genome.fasta aligned_ancient_sorted.bam | bcftools call -mv -Ob -o variants_ancient.bcf
```
### VCF formatına dönüştürün
```
bcftools view variants_ancient.bcf > variants_ancient.vcf
```
### Modern kloroplast genomunda genetik varyasyonları çağırın
```
bcftools mpileup -f modern_genome.fasta aligned_modern_sorted.bam | bcftools call -mv -Ob -o variants_modern.bcf
```
### VCF formatına dönüştürün
```
bcftools view variants_modern.bcf > variants_modern.vcf
```
## 5. Varyasyonları Anotasyon ve Karşılaştırma
Varyasyonları anotasyon yapar ve karşılaştırırsınız.
### SnpEff'i yükleyin ve indeksleyin
```
wget http://sourceforge.net/projects/snpeff/files/snpEff_latest_core.zip
unzip snpEff_latest_core.zip
cd snpEff
java -jar snpEff.jar download GRCh38.86
```
### Referans genom için
### Antik kloroplast varyasyonlarını anotasyon yapın
```
java -jar snpEff.jar eff -v GRCh38.86 variants_ancient.vcf > snpeff_ancient_analysis.txt
```
### Modern kloroplast varyasyonlarını anotasyon yapın
```
java -jar snpEff.jar eff -v GRCh38.86 variants_modern.vcf > snpeff_modern_analysis.txt
```
### VCF dosyalarını karşılaştırın
```
vcf-compare variants_ancient.vcf variants_modern.vcf > comparison_result.txt
```
