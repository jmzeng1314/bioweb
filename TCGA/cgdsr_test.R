library(cgdsr)
mycgds <- CGDS("http://www.cbioportal.org/public-portal/")
all_TCGA_studies <- getCancerStudies(mycgds)
all_TCGA_studies[1:3, 1:2]
write.csv(all_TCGA_studies,"all_TCGA_studies.csv",row.names = F) 
 
# Get list of cancer studies at server
## 获取有哪些数据集
all_TCGA_studies <- getCancerStudies(mycgds)
all_TCGA_studies[1:3, 1:2]

## 这里的cancer_study_id其实就是数据集的名字，我们选择一个数据集，stad_tcga_pub。
stad2014 <- "stad_tcga_pub"
## 获取在stad2014数据集中有哪些表格（每个表格都是一个样本列表）
all_tables <- getCaseLists(mycgds, stad2014)
dim(all_tables) ## 共11种样本列表方式
 
## 而后获取可以下载哪几种数据，一般是mutation，CNV和表达量数据
all_dataset <- getGeneticProfiles(mycgds, stad2014)
my_dataset <- 'stad_tcga_pub_rna_seq_v2_mrna'
my_table 
BRCA1 <- getProfileData(mycgds, "BRCA1", my_dataset, my_table)
dim(BRCA1)
 
 ## 上面是获取一个基因的一个profile。下面试一下获取多个基因的相同profile
 data <- getProfileData(mycgds, c("BRCA1", "BRCA2"), "lusc_tcga_pub_gistic", table)
 head(data)
 
 ## 但是我们不能同时获取多个基因的多种profiles。
 #getProfileData(mycgds, c("BRCA1", "BRCA2"), header, table)
 
 ## 如果我们需要绘制survival curve，那么需要获取clinical数据
 clinicaldata <- getClinicalData(mycgds, table)
 ## 很遗憾，啥都没读回来。可以试试其它的
 clinicaldata <- 
 getClinicalData(mycgds, 
 getCaseLists(mycgds, 
 getCancerStudies(mycgds)[2, 1])[1, 1])
 clinicaldata[1:5, 1:5]
 
 
 
 # Get available case lists (collection of samples) for a given cancer study
 mycancerstudy = getCancerStudies(mycgds)[2,1]
 mycaselist = getCaseLists(mycgds,mycancerstudy)[1,1]
 
 # Get available genetic profiles
 mygeneticprofile = getGeneticProfiles(mycgds,mycancerstudy)[4,1]
 
 # Get data slices for a specified list of genes, genetic profile and case list
 getProfileData(mycgds,c('BRCA1','BRCA2'),mygeneticprofile,mycaselist)
 
 # Get clinical data for the case list
 myclinicaldata = getClinicalData(mycgds,mycaselist)
 
 # documentation
 help('cgdsr')
 help('CGDS')