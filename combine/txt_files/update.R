
#GRCh36 (hg18): ENSEMBL release_52.
#GRCh37 (hg19): ENSEMBL release_59/61/64/68/69/75.
#GRCh38 (hg38): ENSEMBL  release_76/77/78/80/81/82.

library(RMySQL)
my.host="genome-mysql.cse.ucsc.edu";
my.port="";
my.user="genome";
my.password="";
my.db="hg19";
#there are 203 databases,such as hg18,hg38,mm9,mm10,ce10
con <- dbConnect(MySQL(), host=my.host, user=my.user)
all_db=dbGetQuery(con,"show databases;")
dbDisconnect(con)
write.table(all_db,"UCSC_all_dbs.txt",row.names = F,quote = F)
con <- dbConnect(MySQL(), host=my.host, user=my.user,dbname=my.db)
#dbListTables(con) # there are 11016 tables in this hg19 database;
all_hg19_tables=dbListTables(con)
all_hg19_tables=all_hg19_tables[!grepl('wgEncode',all_hg19_tables)]
write.table(all_hg19_tables,"UCSC_all_hg19_tables.txt",row.names = F,quote = F)
dbDisconnect(con)


library(RMySQL)
#Don't forget EnsEMBL's new US East MySQL mirror too:
#mysql -h useastdb.ensembl.org -u anonymous -P 5306 
con <- dbConnect(MySQL(),
                 user="anonymous", password="",
                 host="useastdb.ensembl.org")
all_db=dbGetQuery(con,"show databases;")
dbDisconnect(con)
write.table(all_db,"Ensembl_all_newest_dbs.txt",row.names = F,quote = F)
con <- dbConnect(MySQL(),
                 user="anonymous", password="",
                 dbname='homo_sapiens_variation_83_38',
                 host="useastdb.ensembl.org")

all_homo_sapiens_variation_83_38_tables=dbListTables(con)
write.table(all_homo_sapiens_variation_83_38_tables,"all_homo_sapiens_variation_83_38_tables.txt",row.names = F,quote = F)
dbDisconnect(con)

library(RMySQL)
# mysql -h ensembldb.ensembl.org -P 5316 -u anonymous
con <- dbConnect(MySQL(),
                 user="anonymous", password="",
                 host="ensembldb.ensembl.org")
all_db=dbGetQuery(con,"show databases;")
write.table(all_db,"Ensembl_bioMart_all_dbs.txt",row.names = F,quote = F)
dbDisconnect(con)
# all_db[grep('homo',all_db[,1]),]
con <- dbConnect(MySQL(),
                 user="anonymous", password="",
                 dbname='homo_sapiens_vega_75_37',
                 host="ensembldb.ensembl.org")
all_hg19_tables=dbListTables(con)
write.table(all_hg19_tables,"homo_sapiens_vega_75_37.txt",row.names = F,quote = F)
dbDisconnect(con)


