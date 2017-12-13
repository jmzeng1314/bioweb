## UCSC

> 生信人必须掌握的三大数据库之一的UCSC。

**一、简介**
  
  2000年6月22日，UCSC（University of California,Santa Cruz）和其他国际人类基因组计划的成员完成了人基因组组装的第一个草图，并承诺永久对外提供基因组信息。几个星期以后，在2000年7月22日，组装的基因组在网站 http://genome.ucsc.edu 呈现出来，并提供了一个在线的查询分析工具UCSC Genome Browser。接下来的几年里，该网站不断的发展，如今已包含大量的脊椎动物和模式生物的基因组组装和注释信息，并停工了一系列查看，分析，下载数据的工具。

站点地址：

- http://genome.ucsc.edu/
  * Europe: http://genome-euro.ucsc.edu
* Asia: http://genome-asia.ucsc.edu

数据库特点：

- 给浏览基因组数据提供了可靠和迅速的方式。
- 整合了大量的基因组注释数据，约有一半的注释信息是UCSC通过来自公开的序列数据计算得出，另外一半来自世界各地的科学工作者。本身并不下任何结论，而只是收集各种相关信息供用 户参考。
- 支持数据库检索和序列相似性搜索。

**二、UCSC可以干什么**
  
  UCSC建立的初衷是为了更好的呈现基因组数据，方便人们查看与研究。因此在呈现基因组碱基序列的同时，也结合了注释信息，例如known genes, predicted genes, ESTs, mRNAs, CpG islands, assembly gaps and coverage, chromosomal bands, mouse homologies等等。所以用户既可以用他们提供的数据库里面的数据，也可以上传自己的数据来做研究。围绕着这样的初衷，他们设计如下功能：

```
Genome Browser  整合基因组数据和各种注释数据的在线查看系统
Blat     序列比对工具
Table Browser  将文本文件转化为数据库可以识别的文件
Genome Graphs   上传和呈现基因组数据的工具，例如genome-wide SNP association studies, linkage studies 和homozygosity mapping
Gene Sorter    各种形式的呈现基因的表达，同源等信息以及相互关系
Gene Interactions  基因之间的交互关系
In-Silico PCR   查看一对引物在基因组中的位置
VisiGene 		查看基因在显微镜下的原位图
LiftOver   基因组版本的转换
```

**三、常用案例介绍**
  
  1.如何搜索根据位置来快速获得序列

比如：获得chr17:7676091,7676196对应的序列

方法：
[http://genome.ucsc.edu/cgi-bin/das/hg38/dna?segment=chr17:7676091,7676196](http://genome.ucsc.edu/cgi-bin/das/hg38/dna?segment=chr17:7676091,7676196)

网页会返回 一个xml格式的信息，解析一下即可。

```
This XML file does not appear to have any style information associated with it. The document tree is shown below.
<DASDNA>
  <SEQUENCE id="chr17" start="7676091" stop="7676196" version="1.00">
  <DNA length="106">
  aggggccaggagggggctggtgcaggggccgccggtgtaggagctgctgg tgcaggggccacggggggagcagcctctggcattctgggagcttcatctg gacctg
</DNA>
  </SEQUENCE>
  </DASDNA>
  ```

很明显里面的`aggggccaggagggggctggtgcaggggccgccggtgtaggagctgctgg tgcaggggccacggggggagcagcctctggcattctgggagcttcatctg gacctg`就是我们想要的序列啦

hg38可以更换成hg19，dna?segment= 后面可以按照标准格式更换，既可以返回我们想要的序列了。

2.数据下载

首先是NCBI对应UCSC，对应ENSEMBL数据库，下面各版本对应格式  ` NCBI (UCSC) : ENSEMBL`：
	GRCh36 (hg18): ENSEMBL release_52.
	GRCh37 (hg19): ENSEMBL release_59/61/64/68/69/75.
	GRCh38 (hg38): ENSEMBL  release_76/77/78/80/81/82.
可以看到ENSEMBL的版本特别复杂！！！很容易搞混！
但是UCSC的版本就简单了，人类研究领域就hg18,19,38, 目前常用的是hg19，但是我推荐大家都转为hg38，未来的主流。

UCSC里面下载非常方便，只需要根据基因组简称来拼接url即可：

```
http://hgdownload.cse.ucsc.edu/goldenPath/mm10/bigZips/chromFa.tar.gz
http://hgdownload.cse.ucsc.edu/goldenPath/mm9/bigZips/chromFa.tar.gz
http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz
http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/chromFa.tar.gz
```

或者用shell脚本指定下载的染色体号：

```
for i in $(seq 1 22) X Y M;
do echo $i;
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/chr${i}.fa.gz;
## 这里也可以用NCBI的：ftp://ftp.ncbi.nih.gov/genomes/M_musculus/ARCHIVE/MGSCv3_Release3/Assembled_Chromosomes/chr前缀
done
gunzip *.gz
for i in $(seq 1 22) X Y M;
do cat chr${i}.fa >> hg19.fasta;
done
rm -fr chr*.fasta
```

1. 基因组数据版本转化

染色体区域根据不同的版本（如hg19或者hg38）会有不同的显示，假设我现在有一段hg19上关注的区域（例如chr1：100-10000），我想知道在hg38版本上这段区域的位置，以便于可以更新注释信息，需要怎么做？

三大主流生物信息学数据库运营单位都出了自己的基因组坐标转换，它们分别是 (UCSC的liftOver, NCBI 的 Remap, Ensembl的API)，其中Ensembl的API是基于[crossmap](http://www.bio-info-trainee.com/1413.html)的，是一个python程序。而ucsc的[LiftOver](https://genome.ucsc.edu/cgi-bin/hgLiftOver)最出名，而且有可执行版本软件可以下载。 

1. Blat

- 针对DNA序列，BLAT是用来设计寻找95%及以上相似 至少40个碱基的序列。
- 针对蛋白序列，BLAT是用来设计寻找80%及以上相似 至少20个氨基酸的序列。
- 用法:
  - 查找mRNA或蛋白在基因组中的位置 
- 决定基因外显子的结构
- 显示全长基因的编码区域 
- 分离一个物种他自己的EST
- 查找基因家族
- 从其他物种中查找人类基因的同源物

更多参考：https://genome.ucsc.edu/goldenpath/help/hgTracksHelp.html