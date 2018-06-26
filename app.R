#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(VIM)
library(ggplot2)
library(mice)
library(tidyverse)
library(pheatmap)
library(pcaMethods)
library(VennDiagram)
library(MissMech)
library(missForest)
library(MASS)
library(impute)
library(BaylorEdPsych)

source(file.path("tools", "tools.R"),  local = TRUE)

ui <- navbarPage(
  title = "SIM: Simple Imputation for untargeted Metabolomics data",
  # include the UI for each tab
  source(file.path("ui", "Ututorial.R"),  local = TRUE)$value,
  source(file.path("ui", "UuploadVisiualization.R"),  local = TRUE)$value,
  source(file.path("ui", "UdataFiltering.R"),  local = TRUE)$value,
  source(file.path("ui", "UBiological_induced_missing_imputation.R"),  local = TRUE)$value,
  source(file.path("ui", "Umissing_mechanism_check.R"),  local = TRUE)$value,
  source(file.path("ui", "Uremaining_missing_imputation.R"),  local = TRUE)$value,
  source(file.path("ui", "Uimputation_evaluation.R"),  local = TRUE)$value
)

server <- function(input, output, session) {
  # Include the logic (server) for each tab
  source(file.path("server", "SuploadVisiualization.R"),  local = TRUE)$value
  source(file.path("server", "SdataFiltering.R"),  local = TRUE)$value
  source(file.path("server", "SBiological_induced_missing_imputation.R"),  local = TRUE)$value
  source(file.path("server", "Smissing_mechanism_check.R"),  local = TRUE)$value
  source(file.path("server", "Sremaining_missing_imputation.R"),  local = TRUE)$value
  source(file.path("server", "Simputation_evaluation.R"),  local = TRUE)$value
  
}

shinyApp(ui = ui, server = server)


