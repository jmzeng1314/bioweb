library(shinydashboard)
library(shiny)
options(stringsAsFactors = F) 

page_Home <- fluidPage(
  
)
page_Data <- fluidPage(
  
)
page_About <- fluidPage(
  
)
header=dashboardHeader(
  title =p("千人基因组数据库！"
           ,style="font-size:90%;font-style:oblique"
  )
)
sidebar = dashboardSidebar(
  conditionalPanel(
    condition = "1",
    sidebarMenu(
      id = "tabs",
      hr(),
      menuItem("千人基因组数据库简介",tabName = "Home",icon = icon("home")),
      menuItem("数据探索",    tabName = "Data",icon = icon("flask")),
      menuItem("About", tabName = "About", icon = icon("info-circle"))
    ) ## end for sidebarMenu
  ) ## end for conditionalPanel
) ## end for dashboardSidebar

body=dashboardBody(
  tabItems(
    tabItem(tabName = "Home",page_Home),
    tabItem(tabName = "Data",page_Data), 
    tabItem(tabName = "About",page_About)
  ) 
)

shinyUI(
  dashboardPage(
    header,
    sidebar,
    body,
    title = 'TCGA-database'
  )
)



