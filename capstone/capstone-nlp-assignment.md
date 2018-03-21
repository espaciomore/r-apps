Coursera Capstone - NLP Assignment
========================================================
author: Manuel Cerda
date: Mars 16th, 2017
autosize: true

Beginning
========================================================

Content:

https://en.wikipedia.org/wiki/Natural-language_processing 

https://nlp.stanford.edu/

Tasks to Accomplish:
- Understand Machine Learning 
- Implement ML in Natural Language Processing
- Perfomance for App

About the App
========================================================

The App belongs to ShinyApps.io and she's designed for Natural Language Processing, Its algorithm builds n-grams with text from Tweets, News and Blogs.

The best predictions will happen for n<5 because the phrase would have higher probability of ocurrence of an "n" word phrase.

A technique like the Katz Back Off would be used to fall back to n-1 in case phrases are not found.


Perfomance Analysis 
========================================================

There are three main functions for this App; reading the corpus, building the n-grams and predicting the next word.

I have used the "lineprof" then the "microbenchmark" library to calculate the performance in order to know when users would experience any slowness.

Here are the results of the benchmark:

```
Unit: milliseconds
|     expr    |   min  |  mean  | median |   max  | neval |
|   read.rds  | 110.62 | 111.99 | 111.01 | 120.07 | 10    |  
| buildNGrams | 3188.9 | 18829  | 11433  | 44355  | 10    |  
|  predict... | 433.2  | 550.92 | 471.06 | 958.07 | 10    |  
```

Resources
========================================================

The Shiny App:
https://mcerda.shinyapps.io/capstone/

The Source Code:
https://github.com/espaciomore/r-apps/tree/master/capstone
