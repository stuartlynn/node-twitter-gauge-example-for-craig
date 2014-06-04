Twit = require('twit');
express = require('express')
moment = require('moment')
config = require("./config")
request = require('request')

app = express();


#generate your own API Keys and put them in config.coffee
t = new Twit config

search_term = "innovation"

imp_url = "https://agent.electricimp.com/92kwWmU8tXiX"
stream = t.stream 'statuses/filter',
  track: search_term

Tweets = []

stream.on 'tweet', (data)->
  #Every time we get a tweet push its created_at time in to an array
  Tweets.push moment(data.created_at)
  #Them purge all tweets older than 1 minute
  Tweets = Tweets.filter (a)->
    a >  moment().subtract('seconds', 10)

  request.post imp_url,{tweets_per_sec: Tweets.length/10.0}, (error, response,body)->
    if error
      console.log("failed to post to imp")



#On a request to inovation_level return the count of tweets
app.get '/inovation_level', (req, res)->
  res.json {tweets_per_min : Tweets.length}

app.listen(3001);
