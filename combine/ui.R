library(shiny)
library(shinydashboard)
library(ape)
library(RCurl)
library(RMySQL)
options(stringsAsFactors = F)

#http://www.r-bloggers.com/mysql-and-r/ 

#Connect to the MySQL server using the command:
#mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A
#The -A flag is optional but is recommended for speed

#Don't forget EnsEMBL's new US East MySQL mirror too:
#mysql -h useastdb.ensembl.org -u anonymous -P 5306

UCSC_all_tables=read.table("txt_files/UCSC_all_dbs.txt",header = T)


page_UCSC <- fluidPage(
  p("这其实是一个UCSC的公共数据库的接口可视化！"),
  tags$ul(
    tags$li("数据库连接的网址是：genome-mysql.cse.ucsc.edu"),
    tags$li("数据库连接用户名是：genome"),
    tags$li("数据库连接的密码是：''(一个空字符串，匿名登录)")
  ),
  flowLayout(
    selectInput("ChooseUCSCdb","选择数据库",
                width='80%',
                choices  =  UCSC_all_tables,
                selected = 'hg19'
    ),## end for selectInput
    uiOutput('chooseUCSCtable'),
    selectInput("ChooseUCSCrow","选择查看多少行",
                width='80%',
                choices = c(10,100,1000,'ALL'),
                selected=10
    )## end for selectInput
    
  ),
  actionButton('UCSC_search',"运行",width='50%'),
  DT::dataTableOutput('UCSC_results')
)


page_NCBI <- fluidPage(
  
)
page_Ensembl <- fluidPage(
  
)
page_About <- fluidPage(
  
)
header=dashboardHeader(
  title =p("生信数据库！"
           ,style="font-size:90%;font-style:oblique"
  )
)
sidebar = dashboardSidebar(
  conditionalPanel(
    condition = "1",
    sidebarMenu(
      id = "tabs",
      hr(),
      menuItem("UCSC数据库",    tabName = "UCSC",    icon = icon("home")),
      menuItem("NCBI数据库",    tabName = "NCBI",    icon = icon("flask")),
      menuItem("ENSEMBL数据库", tabName = "Ensembl", icon = icon("life-ring")),
      menuItem("About", tabName = "About", icon = icon("info-circle"))
    ) ## end for sidebarMenu
  ) ## end for conditionalPanel
) ## end for dashboardSidebar

body=dashboardBody(
  tabItems(
    tabItem(tabName = "UCSC",page_UCSC),
    tabItem(tabName = "NCBI",page_NCBI),
    tabItem(tabName = "Ensembl",page_Ensembl),
    tabItem(tabName = "About",page_About)
  ) 
)

shinyUI(
  dashboardPage(
    header,
    sidebar,
    body,
    title = 'bio-tools'
  )
)