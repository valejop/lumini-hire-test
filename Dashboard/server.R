#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
setwd("C:/Users/valej_000/Documents/Lumini/")
#Para ser reprodutível em qualquer computador, por favor escolha o diretório
#com a linha comentada abaixo. Esta pasta equivale ao caminho da pasta do GitHub.
#choose.dir()
zip <- unz("sample_data/Microdados_Enem_2016.zip",filename = "Microdados_Enem_2016.csv")
df <- read_csv(zip)
get_regiao <- function(cod){
  temp=vector(mode = "character",length = length(cod))
  temp[substr(cod,1,1)=="1"]="N"
  temp[substr(cod,1,1)=="2"]="NE"
  temp[substr(cod,1,1)=="3"]="SE"
  temp[substr(cod,1,1)=="4"]="S"
  temp[substr(cod,1,1)=="5"]="CO"
  return(as.factor(temp))
}
df <- df%>%mutate(REGIAO_RESIDENCIA=get_regiao(CO_UF_RESIDENCIA),REGIAO_PROVA=get_regiao(CO_UF_PROVA),
                  REGIAO_NASCIMENTO=get_regiao(CO_UF_NASCIMENTO))
notas <- df%>%
  gather(key="PROVA",value="NOTA",NU_NOTA_MT,NU_NOTA_CN,NU_NOTA_CH,NU_NOTA_LC,NU_NOTA_REDACAO)
notas_PRESENTE <- notas%>%filter(TP_PRESENCA_CN & TP_PRESENCA_CH 
                                 & TP_PRESENCA_LC & TP_PRESENCA_MT)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
df$CO_UF_PROVA   
  output$boxplot <- renderPlot({
    if(input$Geografia=="R" & input$Prova!="Todas"){
    notas_PRESENTE%>%
      filter(PROVA==input$Prova)%>%
    ggplot()+
      geom_boxplot(mapping=aes(x =REGIAO_PROVA ,y = NOTA,fill=REGIAO_PROVA))+
      geom_hline(mapping = aes(yintercept=input$Line),color=2)
    }
    else if(input$Geografia=="R" & input$Prova=="Todas"){
      notas_PRESENTE%>%ggplot()+
        geom_boxplot(mapping=aes(x =REGIAO_PROVA ,y = NOTA,fill=REGIAO_PROVA))+
        geom_hline(mapping = aes(yintercept=input$Line),color=2)
    }
    else if(input$Geografia!="R" & input$Prova=="Todas"){
      notas_PRESENTE%>%ggplot()+
        geom_boxplot(mapping=aes(x = fct_reorder(.f = SG_UF_PROVA,.x = NOTA,
                                                 .fun = function(x){median(x,na.rm = T)}),
                                 y = NOTA,fill=REGIAO_PROVA))+
        xlab("Unidade Federativa")+
        geom_hline(mapping = aes(yintercept=input$Line),color=2)
    }
    else{
      notas_PRESENTE%>%
        filter(PROVA==input$Prova)%>%
        ggplot()+
        geom_boxplot(mapping=aes(x = fct_reorder(.f = SG_UF_PROVA,.x = NOTA,
                                                 .fun = function(x){median(x,na.rm = T)}),
                                 y = NOTA,fill=REGIAO_PROVA))+
        xlab("Unidade Federativa")+
        geom_hline(mapping = aes(yintercept=input$Line),color=2)
    }
  })
  output$densiplot <- renderPlot({
    if(input$Prova!="Todas"){
    notas_PRESENTE%>%
      filter(PROVA==input$Prova)%>%
      ggplot()+
      geom_density(mapping =aes(x=NOTA,fill=TP_SEXO))+
      facet_grid(TP_SEXO~PROVA)+
      ggtitle("Distribuição das notas entre os sexos")
    }
    else{
      notas_PRESENTE%>%
        ggplot()+
        geom_density(mapping =aes(x=NOTA,fill=TP_SEXO))+
        geom_vline(mapping = aes(xintercept=input$Line),color="darkgrey")+
        facet_grid(TP_SEXO~PROVA)+
        ggtitle("Distribuição das notas entre os sexos")
    }
  })

  output$barplot <- renderPlot({
    temp=notas_PRESENTE[,c(112+as.numeric(input$Questio),164,89)]
    if(input$Geografia=="R"){
    ggplot(data=temp)+
      geom_bar(mapping = aes(x =REGIAO_PROVA,fill=as.factor(temp[[1]])),position='fill')+
        scale_fill_discrete(name="",labels=c("Não","Sim"))
    }
    else{
      ggplot(data=temp)+
        geom_bar(mapping = aes(x =SG_UF_PROVA,fill=temp[[1]]),position='fill')+
        scale_fill_discrete(name="",labels=c("Não","Sim"))
    }
    })
})
