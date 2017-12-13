#Connect to the MySQL server using the command:
#mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A
#The -A flag is optional but is recommended for speed
library(RMySQL)
my.host="genome-mysql.cse.ucsc.edu";
my.port="";
my.user="genome";
my.password="";
my.db="hg19";  ### 需要选择物种
#there are 203 databases,such as hg18,hg38,mm9,mm10,ce10
con <- dbConnect(MySQL(), host=my.host, user=my.user,dbname=my.db)
dbListTables(con) 
all_ucsc_tables=dbListTables(con)  
all_ucsc_tables=as.data.frame(all_ucsc_tables)

# there are 11016 tables in this hg19 database;
#tmp = dbListTables(con)
#tmp[grep("snp",tmp)] 
#it will shows how many tables are related with SNP
rs <- dbGetQuery(con,"SELECT * FROM snp142 limit 10;")  
tmp <- dbGetQuery(con,"select * from snpArrayAffy6 limit 10;")  
tmp <- dbGetQuery(con,"select * from geneid limit 10;")  
tmp <- dbGetQuery(con,"select * from gtexGene limit 10;")  
tmp <- dbGetQuery(con,"select * from knownIsoforms limit 10;")  
tmp <- dbGetQuery(con,"select * from snpArrayAffy6 limit 10;")  
tmp <- dbGetQuery(con,"select * from snpArrayAffy6 limit 10;")  


# 用R来操作mysql进行查看，并不是很方便，只有想把它写出来的时候才方便
dbGetQuery(con,"select count(*) from illuminaProbesSeq limit 10;")
#SELECT species, sex, COUNT(*) FROM pet GROUP BY species, sex;
#SELECT * FROM pet WHERE name LIKE 'b%';  



