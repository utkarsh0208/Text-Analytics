# Install the Basic Packages for Text Mining and Extracting Tweets from Twitter

#install.packages('tm')            # Text Mining
#install.packages('wordcloud')     # WordCloud
#install.packages('SnowballC')     # Data PreProcessing
#install.packages("twitteR")       # Fetching Tweets
#install.packages("ROAuth")        # Authenticate the connection with twitter

# Load the above installed packages in the environment

library(tm)
library(wordcloud)
library(SnowballC)
library(twitteR)
library(ROAuth)

# Initialize keys for Twitter connection

ckey= "smdYKNpD2619h0iwbS4d2nZqe"
csec= "RREqMR2yNJLamkxEy0dLvGZchX8yBZPap9I9CWrBz8URRDQhEc"
atok= "2534041177-96A798VbGVRmlHjIyKDCh0gDSUdXtlrEIxQqlVd"
atoksec= "0AePVjfI333FA9il0w1GuKfZHBvN8KNLLJlWduOjBDvES"

# Setup the connection
setup_twitter_oauth(ckey, csec, atok, atoksec)

# Extract Tweets from Twitter
vadnagar.tweets = searchTwitter('#vadnagar', n=1500, lang = 'en', resultType = 'recent')

# Convert as DataFrame
vadnagar.tweets= do.call("rbind", lapply(vadnagar.tweets, as.data.frame))

#Convert in text
vadnagar_text <- sapply(vadnagar.tweets$text,function(row) iconv(row, "latin1", "ASCII", sub=""))

# Convert into Corpus
vadnagar_corpus = Corpus(VectorSource(vadnagar_text))

# Clean the corpus
vadnagar_clean = tm_map(vadnagar_corpus, removePunctuation)
vadnagar_clean = tm_map(vadnagar_clean, content_transformer(tolower))
vadnagar_clean = tm_map(vadnagar_clean, removeWords, c(stopwords("english"), "vadnagar"))
vadnagar_clean = tm_map(vadnagar_clean, removeNumbers)
vadnagar_clean = tm_map(vadnagar_clean, stripWhitespace)

# Stemming
vadnagar_clean <- tm_map(vadnagar_clean, stemDocument)

dtm <- TermDocumentMatrix(vadnagar_clean)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)


# Plot WordCloud
wordcloud(words = d$word, freq = d$freq, min.freq = 1,max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
