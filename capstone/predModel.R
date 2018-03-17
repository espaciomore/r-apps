library(tm)
library(ngram)
library(data.table)

source("regexps.R")

# load the corpora
data.corpus <- readRDS(file="corpus_object.316KB.Rds")
# recreate the n-gram models
buildNGrams <- function(size,corpus){
  set.seed(123)
	ngrams <- c()
	corpus <- concatenate(corpus, collapse = "\n")
	for(i in 1:size) {
	  fl.name <- paste("ngrams_",i,".Rds", sep = "")
	  ng <- #if(file.exists(fl.name)){
	    #readRDS(file=fl.name)
	  #} else {
	    t.ngram <- ngram(corpus, n=i, sep=", \n")
	    #saveRDS(t.ngram, file=fl.name)
	    #t.ngram
	  #}
		ngrams <- c(ngrams, ng)
	}
	saveRDS(ngrams, file="ngrams.Rds")
	return(ngrams)
}
print("Loading n-grams")
ngrams <- buildNGrams(10, data.corpus)
# predict the next word
predictNextWord <- function(text, ng=ngrams, nw=10){
  # clean the text accordingly
  text <- preprocess(text, remove.punct = T, remove.numbers = T, fix.spacing = F)
  print("removeURL")
  text <- gsub(re.url, "", text, ignore.case = T)
  print("removeHashtags")
  text <- gsub(re.hashtags, "", text, ignore.case = T)
  print("removeExcesiveLetters")
  text <- gsub(re.excesiveLetters, "\\1", text, ignore.case = T)
  print("removeChars")
  text <- gsub(re.chars, " ", text, ignore.case = T)
  print("removeFuckWords")
  text <- gsub(re.fuckWords, "", text, ignore.case = T)
  print("removeRepeatedWords")
  text <- gsub(re.repeatedWords, "\\1", text, ignore.case = T)
  print(paste0("Search Text: ", text))
  # count the number of words in input text
	text.words <- unlist(strsplit(text,split=" "))
	text.wc <- length(text.words)
	# count the number of ngrams available
	ng.len <- length(ng)
	# select the best fitting ngram
	n <- if(text.wc >= ng.len) {
	  ng.len 
	} else {
	  text.wc+1
	}
	# select the previous words
	text.cut <- if(text.wc > 0) {
	  tail(text.words, n) 
	} else if(text.wc >= ng.len) {
	  tail(text.words, n-1) 
	} else {
	  c("")
	}
	text.diff <- if(text.wc < ng.len) {
	  c("") 
	} else {
	  setdiff(text.words, text.cut)
	}
	
	backoffMode <- function(text, ng2, n){
    # get the phrase table from ngram
    pt <- get.phrasetable(ng=ng2[[n]])
    # create the data table for querying
    dt <- data.table(ngram = pt$ngrams, freq = pt$freq)
    # select the possible predictions
    x <- concatenate(text, collapse=" ")
    print(paste0("Next Word: ", x))
    pattern <- paste("^", x, "\\s", sep="")
    dt.cut <- dt[grep(pattern, ngram)]
    # implement backoff mode when empty
    if(length(dt.cut$ngram)==0 && n>1){
      return(backoffMode(text[-1], ng2, n-1))
    }
    return(dt.cut)
	}
	dt.cut <- backoffMode(text.cut, ng, n)
	
	# select the best match
	dejavu <- grepl(
	  concatenate(text.cut, collapse =" "), 
	  concatenate(text.diff, collapse =" "), 
	  #ignore.case = T,
	  fixed = T
	)
	dt.pred <- data.table(ngram=character(nw),nextWord=character(nw))
	if(length(dt.cut$ngram)==0) return(dt.pred)
	dt.pred$ngram <- if(text.wc == 0 || (text.wc < ng.len && !dejavu)) {
	  head(dt.cut,nw)$ngram
	} else {
	  tail(dt.cut,nw)$ngram
	}
	# remove duplicates
  uniq.ngram <- unique(dt.pred$ngram)
  dt.clean <- data.table(ngram=uniq.ngram, nextWord=character(length(uniq.ngram)))
  # add next word
  dt.clean$nextWord <- lapply(dt.clean$ngram, function(ng0){
    pred.words <- unlist(strsplit(ng0, split=" "))
    return(last(pred.words))
  })
  
  return(dt.clean)
}