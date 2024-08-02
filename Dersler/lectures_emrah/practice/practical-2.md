---
title: "Antik Metagenomik Pratik"
author: "Emrah Kırdök, Ph.D."
date: "2024-07-31"

---

Öncelikle github deposunu klonlayalım. Pratik kapsamında kullanacağımız bütün kodlar burada olacak:

```bash
git clone https://github.com/genombilim/2024.git
```

Şimdi de çalışma klasörüne gidelim:

```bash
cd 2024/Dersler/lectures_emrah/practice/
```

Eğer depoyu daha önce klonladıysanız, son değişiklikleri çekelim:

```bash
cd 2024/Dersler/lectures_emrah/practice/
git pull origin main
```

Burada verilerimiz için öncelikle klasörlerimizi oluşturalım:

```bash
mkdir -p data
mkdir -p results/alignment
mkdir -p logs
```

## Antik mikrobiyal hizalama

Çalışmamızda daha önce antik sakızlardan elde edilmiş mikrobiyal DNA verisini kullanacağız. Çalışacağımız canlı, *Gemella sanuginis* isminde bir antik bakteri olacak. Bu canlı, ağız mikrobiyotasının yerel bir sakini. Ancak kana karışıp başka yerlere gittiğinde hastalık yapıyor.

Veriyi alalım:

```bash
cp /truba/home/egitim/Workshop_emrah/data/Gemella_sanguinis_ATCC_700632.fasta data/
```

Şimdi de bu canlıya ait okumaları hizalayacağımız referans genomu alalım:

```bash
cp /truba/home/egitim/Workshop_emrah/data/GCF_000701685.1_ASM70168v1_genomic.fna data/
``` 

## Hizalama adımları

Çalışmalara başlamadan önce programlarımızın olduğu conda çevresini aktive edelim:

```bash
conda activate bioinformatics
``` 

İlk olarak referans genomu indeksleyelim:

```bash
bwa index data/GCF_000701685.1_ASM70168v1_genomic.fna
```

Artık okumaları hizalamaya başlayabiliriz:

```bash
bwa aln data/GCF_000701685.1_ASM70168v1_genomic.fna data/Gemella_sanguinis_ATCC_700632.fasta > results/alignment/Gemella_sanguinis_ATCC_700632.sai

bwa samse  data/GCF_000701685.1_ASM70168v1_genomic.fna results/alignment/Gemella_sanguinis_ATCC_700632.sai data/Gemella_sanguinis_ATCC_700632.fasta | samtools view -F 4 -h -q 30 | awk '/^@/ {print} length($10)>30 {print}' | samtools view -Sb > results/alignment/Gemella_sanguinis_ATCC_700632.bam
```

Elde ettiğimiz hizalama dosyalarımızı mutlaka sıralayp indeksleyelim.

```bash
samtools sort results/alignment/Gemella_sanguinis_ATCC_700632.bam -o results/alignment/Gemella_sanguinis_ATCC_700632.sorted.bam
samtools index results/alignment/Gemella_sanguinis_ATCC_700632.sorted.bam
```

PCR duplikasyonlarından arındıralım:

```bash
samtools rmdup -s results/alignment/Gemella_sanguinis_ATCC_700632.sorted.bam results/alignment/Gemella_sanguinis_ATCC_700632.sorted.rmdup.bam

samtools index results/alignment/Gemella_sanguinis_ATCC_700632.sorted.rmdup.bam
```

Antiklik için önce `mapDamage` programının olduğu çevreyi aktive edelim:

```bash
conda activate anmet4evogen
```

```bash
mapDamage -i results/alignment/Gemella_sanguinis_ATCC_700632.sorted.rmdup.bam -r data/GCF_000701685.1_ASM70168v1_genomic.fna
```