## ----setup, include=FALSE-----------------------------------------------------
knitr::knit_hooks$set(purl = knitr::hook_purl)
knitr::opts_chunk$set(echo = TRUE)

library(SummarizedExperiment)

## ----readData, echo=FALSE-----------------------------------------------------
data<-read.csv("/home/alex/uoc/2_analisi_dades_omiques/PAC1/Vidal-Romera-Alejandro-PEC1/human_cachexia.csv", row.names = 1)

## ----dataPreAnalysis----------------------------------------------------------
# Observem l'estructura de les dades.
str(data)

# Totes les variables excepte les dues primeres columnes són numériques.
# Comprovem quins valors pot prendre la columna "Muscle.loss".
unique(data$Muscle.loss)

# Els valors de Muscle.loss poden ser "cachexic" o "control". 
# Convertim la columna en factor per a que R pugui treballar millor les dades categòriques.
data$Muscle.loss <- as.factor(data$Muscle.loss)

## ----seObject-----------------------------------------------------------------
# Matriu de dades.
assays_data <- as.matrix(data[, -1])

# Es crea DataFrame de Bioconductor per treballar de manera més eficient.

# Dataframe de metadades de fila
row_data <- DataFrame(
  PatiendId = rownames(data),
  MuscleLoss = data$Muscle.loss
)

# Dataframe de metadades de columna
col_data <- DataFrame(
  Metabolites = colnames(assays_data)
)

# Es crea l'objecte SummarizedExperiment i es mostra el resultat
se <- SummarizedExperiment(assays = SimpleList(counts = assays_data), rowData = row_data, colData = col_data)
print(se)

## ----addSeMetadata------------------------------------------------------------
metadata(se) <-list(
  project = "PEC1 Analisis de datos omicos",
  dataset_description = "Concentraciones de ciertos metabolitos en pacientes con caquexia y pacientes control"
)

metadata(se)

# Guardem el fitxer tal com es requereix a la prova
save(se, file = "SummarizedExperiment_data.Rda")

## ----datasetExploration-------------------------------------------------------
# Dimensions del conjunt de dades
dim(se)

# DataFrame dels metabòlits
colData(se)

#DataFrame dels pacients
rowData(se)

# Nombre de pacients a cada grup experimental
table(rowData(se)$MuscleLoss)

# Nombre de valors nuls
sum(is.na(assay(se)))

# Descripció estadística de les dades de cada metabòlit
summary(assay(se))

# Representació gràfica de la distribució dels metabòlits
par(mar=c(14, 3, 1, 1))
boxplot(assay(se), main="Distribució dels metabòlits", las=2, cex.axis=0.5)

