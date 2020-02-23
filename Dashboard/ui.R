#Boxplot de região ou estado, escolhendo qual prova mostra


library(shiny)
#shiny::)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interface interativa ENEM 2016"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("Prova",h4("Prova:"),
                   list("Todas"="Todas","Ciências da Natureza"="NU_NOTA_CN","Ciências Humanas"="NU_NOTA_CH",
                        "Linguagens e Códigos"="NU_NOTA_LC","Matemática"="NU_NOTA_MT",
                        "Redação"="NU_NOTA_REDACAO")),
       selectInput("Geografia",h4("Estado ou região?"),
                   list("Região"="R","Estado"="UF")),
       selectInput("Questio",h4("Sim ou não?"),
                   list("Internet?"=25,
                        "Aparelho de DVD?"=20,"TV por assinatura?"=21,
                        "Telefone fixo?"=23)),
       sliderInput("Line", h3("Sliders"),
                   min = 0, max = 1000, value = 0)
    ),
    # Show a plot of the generated distribution
    mainPanel(
#      plotOutput("distPlot"),
      tabsetPanel(
        tabPanel("Notas por geografia",plotOutput("boxplot")),
        tabPanel("Notas por sexo",plotOutput("densiplot")),
        tabPanel("Poder Aquisitivo",plotOutput("barplot"))
      )
    )
  )
))
#shiny::
