require.paths.unshift './vendor'

sys = require 'sys'
OAuth = require('oauth').OAuth
Logger = require('./log').Logger

Consumer = new OAuth(
  'http://api.twitter.com/oauth/request_token', 
  'http://api.twitter.com/oauth/access_token', 
  process.env.TWITTER_KEY, 
  process.env.TWITTER_SECRET, 
  '1.0', null, 'HMAC-SHA1'
)

Client = (token, secret)->
  this.token = token
  this.secret = secret
  
Client.prototype.request = (method, path, callback)->
  url = "http://api.twitter.com/1#{path}"
  Logger.info "Twitter", "Fetching #{path}"
  Consumer.getProtectedResource url, method, this.token, this.secret, (error, data, response)->
    if error
      Logger.error "Twitter", "Unable to fetch the timeline.", JSON.stringify(error)
    else
      callback JSON.parse(data)
    
Client.prototype.get = (path, callback)->
  this.request 'GET', path, callback

exports.consumer = Consumer
exports.client = Client
