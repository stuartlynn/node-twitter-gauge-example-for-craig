Twit = require('twit');
express = require('express')
moment = require('moment')
config = require("./stu_config")
request = require('request')

app = express();


#generate your own API Keys and put them in config.coffee
t = new Twit config

search_term = "sad"

imp_url = "https://agent.electricimp.com/92kwWmU8tXiX"
stream = t.stream 'statuses/filter',
  track: search_term

Tweets = []

post_to_imp = ->
  console.log "trying to post to imp #{Tweets.length/10.0} "
  request.post {uri: imp_url, json : {tweets_per_sec: Tweets.length/10.0}}, (error, response,body)->
    console.log("imp post #{body}")
    console.log("imp post #{response.statusCode}")


setInterval post_to_imp, 10000

stream.on 'tweet', (data)->
  #Every time we get a tweet push its created_at time in to an array
  Tweets.push moment(data.created_at)
  #Them purge all tweets older than 1 minute
  Tweets = Tweets.filter (a)->
    a >  moment().subtract('seconds', 10)



#On a request to inovation_level return the count of tweets
app.get '/inovation_level', (req, res)->
  res.json {tweets_per_min : Tweets.length}

app.listen(3001);
