---
title: "Metagenomik Pratik"
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

Burada verilerimiz için öncelikle klasörlerimizi oluşturalım:

```bash
mkdir data
mkdir -p results/metaphlan/
mkdir logs
```

Şimdi de `${PATH}` değişkenini ayarlayalım. Pratik kapsamında kullanacağımız programlara bu şekilde erişebiliriz. Kullanacağımız betiklere de öncelikle bu satırı eklemeliyiz:

```bash
export PATH=/truba/home/egitim/miniconda3/envs/anmet4evogen/bin:${PATH}
```

Ya da conda modülünü aktive etmeliyiz. İksini de farklı koşullarda kullanabilrsiniz:

```bash
conda activate anmet4evogen
```

## Metaphlan3 veri tabanı

Çalışmada kullanacağımız belirteç veri tabanı aşağıdaki klasördedir:

```bash
ls /truba/home/egitim/Workshop_emrah/databases/metaphlan_3.0/
```

## DNA okumaları

Pratik kısımda kullanacağımız DNA okumaları aşağıda bulunmaktadır. Bu dosyaları kendi klasörümüze kopyalayalım:

```bash
ls /truba/home/egitim/Workshop_emrah/data/
```

Dosyaları kopyalayalım:

```bash
cp /truba/home/egitim/Workshop_emrah/data/*gz data/

ls data
```

## Metapham3 kullanımı

Aşağıdaki komut ile bir dosyayı çalıştırabiliriz:

```bash
metaphlan data/SRS014459-Stool.fasta.gz \
        --input_type fasta \
        --bowtie2db /truba/home/egitim/Workshop_emrah/databases/metaphlan_3.0/ \
        -x mpa_v30_CHOCOPhlAn_201901 \
        --bowtie2out results/metaphlan/SRS014459-Stool.bowtie2out \ 
        -s results/metaphlan/SRS014459-Stool.sam > results/metaphlan/SRS014459-Stool.txt
```

Ancak metagenomik araçlar genellikle fazla hafıza ve işlemci gücü kullanırlar. O yüzden bu komutları bir `sbatch` dosyası ile çalıştırsak daha iyi olur:

```bash
sbatch metaphlan-1.sh
```

Şimdi de işler çalışıyor mu ona bakalım:

```bash
squeue
```

Oluşan dosyalara bakalım. Önce rapor dosyası:

```bash
less results/metaphlan/SRS014459-Stool.txt
```

Şimdi de sam dosyası:

```bash
less results/metaphlan/SRS014459-Stool.sam
```

Şimdi ise diğer dosyaları için bu işi yapalım. Kolaylık olsun diye sbatch dosyasını modifiye ettim. Bu sayede aynı anda diğer okumaları da kuyruğa gönderebiliriz:

```bash
less metaphlan-2.sh
```

Burada DNA okumalarının isimlerini bir komut satırı parametresi haline getirdik.

Diğer dosyaları da ardı arkasına gönderelim:

```bash
sbatch metaphlan-2.sh SRS014464-Anterior_nares
sbatch metaphlan-2.sh SRS014470-Tongue_dorsum
sbatch metaphlan-2.sh SRS014472-Buccal_mucosa
sbatch metaphlan-2.sh SRS014476-Supragingival_plaque
sbatch metaphlan-2.sh SRS014494-Posterior_fornix
```

İşimiz bitti mi acaba? 

```bash
squeue
```

Bittiğinde kontrol edelim:

```bash
ls results/metaphlan
```

## Tabloların birleştirilmesi

Elimizdeki frekans tablolarını birleştirelim şimdi

```bash
merge_metaphlan_tables.py results/metaphlan/*txt > results/metaphlan/merged-table.txt
```

Şimdi de sadece tür profillerini alalım:

```bash
grep -E "s__|clade" results/metaphlan/merged-table.txt | sed 's/^.*s__//g'\ | cut -f1,3-8 | sed -e 's/clade_name/body_site/g' > results/metaphlan/merged_abundance_table_species.txt
```

## Isı haritası elde edelim

```bash
hclust2.py -i results/metaphlan/merged_abundance_table_species.txt -o results/metaphlan/abundance_heatmap_species.png --f_dist_f braycurtis --s_dist_f braycurtis 
```

Bir ısı haritası elde edebiliriz bu şekilde.

Eğer her şey doğru gittiyse aşağıdaki grafiği elde etmemiz gerekecek:

![Isı haritası](abundance_heatmap_species.png)