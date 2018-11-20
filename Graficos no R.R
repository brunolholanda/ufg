#### Construindo Gráficos:
# Instalando os pacotes (caso não os tenha instalados)
# install.packages(c("ggplot2","ggthemes", "gridExtra"))

# Carregando os pacotes
library(ggplot2)
library(ggthemes)
library(gridExtra)
library(dplyr)

data("mtcars")
attach(mtcars)

ggplot(data=mtcars, aes(x=mpg, y=disp)) + geom_point()

ggplot(data=mtcars, aes(x=mpg, y=disp, color=cyl, size=drat)) + geom_point()

str(mtcars)

mtcars2 <- mtcars %>% 
  mutate(new_cyl = as.character(cyl))

str(mtcars2)

ggplot(data=mtcars2, aes(x=mpg, y=disp, color=new_cyl, size=drat)) + geom_point()

ggplot(data=mtcars2, aes(x=mpg, y=disp, color=new_cyl)) +
 geom_point() + geom_smooth(method = "lm")

### adicionando facetas
ggplot(data=mtcars2, aes(x=mpg, y=disp)) +
  geom_point() + geom_smooth(method = "lm") + facet_wrap(~new_cyl)

#### temas específicos:
ggplot(data=mtcars2, aes(x=mpg, y=disp, color=new_cyl)) +
  geom_point() + geom_smooth(method = "lm") + theme_excel_new()

#### Trabalhando com MAPAS
# visite o site: http://downloads.ibge.gov.br/downloads_geociencias.htm
# baixe o arquivo organizacao_do_territorio >>> 
# malhas_territoriais >>> malhas_municipais >>>
# municipio_2017 >>> Brasil >>> BR >>> br_unidades_da_federacao.zip
library(rgdal)
## If you are a ubuntu 16.04 user, before install 'rgdal':
# sudo add-apt-repository 'deb https://mirror.ibcp.fr/pub/CRAN/bin/linux/ubuntu xenial/' 
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
# sudo apt-get update
# sudo apt-get install libgdal1-dev libproj-dev libgeos-dev
# sudo apt-get install r-base-core
# sudo apt-get install bwidget libgdal-dev libgdal1-dev libgeos-dev libgeos++-

shp <- readOGR("/home/bruno/Dropbox/Projetos/Introducao ao R/br_unidades_da_federacao", "BRUFE250GC_SIR", stringsAsFactors=FALSE, encoding="UTF-8")

pg <- read.csv("/home/bruno/Dropbox/Projetos/Introducao ao R/PontosCorridos.csv",sep=";")

pg <- pg %>% group_by(Estado) %>% 
  mutate(cumsum = cumsum(PG))

pg2 <- pg %>%
  group_by(Estado) %>%
  summarise(Score = max(cumsum)) 

pg2 <- as.data.frame(pg2)

ibge <- read.csv("/home/bruno/Dropbox/Projetos/Introducao ao R/estadosibge.csv",sep=",")

pg3 <- merge(pg2,ibge, by.x = "Estado", by.y = "UF")

#### Fazer a junção entre o dataset e o shapefile utilizando o código do IBGE
brasileiropg <- merge(shp, pg3, by.x = "CD_GEOCUF", by.y = "Código.UF")

#### Realizando o tratamento e a formatação do data frame espacial
library(proj4)
proj4string(brasileiropg) <- CRS("+proj=longlat +datum=WGS84 +no_defs")

Encoding(brasileiropg$NM_ESTADO) <- "UTF-8"

brasileiropg$Score[is.na(brasileiropg$Score)] <- 0


### Escolhendo paleta de cores
library(RColorBrewer)
# display.brewer.all()

#### Gerando o mapa
library(leaflet)
pal <- colorBin("Blues",domain = NULL,n=5) #cores do mapa
state_popup <- paste0("<strong>Estado: </strong>", 
                      brasileiropg$NM_ESTADO, 
                      "<br><strong>Pontos: </strong>", 
                      brasileiropg$Score)
leaflet(data = brasileiropg) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(brasileiropg$Score), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1, 
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~brasileiropg$Score,
            title = "Pontos Conquistados",
            opacity = 1)

