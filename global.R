#LOAD LIBRARIES
library(magrittr)
library(dplyr)
library(shinyhelper)
library(fst)

#
library(brio)
library(diffobj)
library(testthat)
library(waldo)

#TEXTOS
############################################# DATA ###############################################

UPLOADDATA_TEXT<-"Cargar el archivo con los datos"
SELECTFILE_TEXT<-'Seleccione el archivo'
FILESELEC_TEXT<-'Aun no seleccionas el archivo...'
BUTTSELEC_TEXT<-'Buscar'
WITHHEADER_TEXT<-"Con encabezado"
SEPARATOR_TEXT<-"Separador"
COMILLAS_TEXT<-"Comillas"
ENCABEZADO_TEXT<-"Encabezado de los datos"

UPLOADFILETYPE_CONF<-c('text/csv',
                       'text/comma-separated-values',
                       'text/tab-separated-values',
                       'text/plain',
                       '.csv',
                       '.tsv')

UPLOADFILESEP_CONF<-c('Coma'=',',
                      'Punto y coma'=';',
                      'Tab'='\t')

UPLOADFILESEP_CONF_1<-c('Coma'=',',
                        'Punto y coma'=';',
                        'Tab'='\t','Espacio'=' ')

UPLOADCOMILLAS_CONF<-c('Ninguna'='',
                       'Comilla doble'='"',
                       'Comilla simple'="'")


#PREDICT FUNCTION
# PREDICT WORD FUNCTION
predict_word <- function(words,unigrama1,bigram1,trigrama1,tetragrama1){
  
  # UNIGRAM FUNCTION
  unigram <- function(words){
    #print("No match find, the most common unigram are,")
    outputs <- as.data.frame(unigrama1[order(-unigrama1$prob),])
    names(outputs)[2] <- "Word"
    outputs[1:10,]
  }
  
  #BIGRAM FUNCTION
  bigram <- function(words){
    #print("Bigram")
    #NUMBER OF WORDS
    wordslength <- sapply(strsplit(words, " "), length)
    
    #LAST WORD
    words <- sapply(strsplit(as.character(words), " ", fixed = TRUE), '[[', wordslength)
    
    #FIND LAST WORD
    outputs <- data.frame(bigram1[(bigram1$word1)==words,c("word2","prob")])
    
    #ORDER
    outputs<- outputs[order(-outputs$prob),]
    names(outputs)[1] <- "Word"
    
    # UNIGRAM BACK-OFF 
    if (nrow(outputs)== 0) {
      return(unigram())
    }else{
      outputs[1:10,]}
  }
  
  #TRIGRAM
  trigram <- function(words){
    #print("Trigram")
    #NUMBER OF WORDS
    wordslength<-sapply(strsplit(words, " "), length)
    
    #SLECT TWO LAST WORDS
    words<- paste(
      sapply(strsplit(as.character(words), " ", fixed = TRUE), '[[', wordslength-1),
      sapply(strsplit(as.character(words), " ", fixed = TRUE), tail, 1), 
      sep= " ")
    
    #FIND WORDS
    outputs <- data.frame(trigrama1[(trigrama1$pair)==words,c("word3","prob")])
    
    #ORDER
    outputs <- outputs[order(-outputs$prob),]
    names(outputs)[1] <- "Word"
    
    # BRIGRAM BACK-OFF
    if (nrow(outputs) == 0){
      return(bigram(words))
    }else {outputs[1:5,]}
    
  }
  
  #TETRAGRAM FUNCTION
  tetragram <- function(words) {
    #print("Tetragram")
    
    #EXTRACT THE LAST 3 WORDS
    words<- paste(
      sapply(strsplit(as.character(words), " ", fixed = TRUE), '[[', wordslength-2),
      sapply(strsplit(as.character(words), " ", fixed = TRUE), '[[', wordslength-1),
      sapply(strsplit(as.character(words), " ", fixed = TRUE), tail, 1), 
      sep= " ")
    
    #FIND WORD
    outputs <- data.frame(tetragrama1[(tetragrama1$tri)==words,c('word4','prob')])
    
    #ORDER
    outputs <- outputs[order(-outputs$prob),]
    names(outputs)[1] <- "Word"
    
    # TRIGRAM BACK-OFF
    if (nrow(outputs)== 0) {
      return(trigram(words))
    }else{outputs[1:5,]}
    
  }
  
  ## NEXT WORD PREDICTOR FUNCTION:
  
  ### Input cleaning 
  ## Starting output, no input case:
  words<-tolower(words)
  words<-gsub("'", "", words)
  words<-gsub('[[:punct:] ]+',' ',words)
  wordslength<-sapply(strsplit(words, " "), length)
  words<- as.character(words)
  
  
  if (wordslength == 0) {return(unigram(words))}
  ## Searching in Bi-gram (using last term, words = 1) 
  if (wordslength == 1) {return(bigram(words))}
  ## Searching in Tri-gram (Using the last two terms, words = 2)
  if (wordslength == 2) {return(trigram(words))}
  ## Searching in Tetra-gram (Using the last 3 terms, words = 3 or more)
  if (wordslength >= 3) {return(tetragram(words))}
  ## No words
  # if (words=="") {
  #   outputs<-data.frame(word = c("i","the","in","im","we"),prob=c("5.9","4.8","	1.1","1.0","0.8"))
  #   outputs<-outputs[order(-outputs$prob),]
  #   outputs
  # }
}
