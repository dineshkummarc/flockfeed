require.paths.unshift('./vendor')

REST = require('./rest').Client
sys = require 'sys'
Logger = require('./log').Logger
Twitter = require './twitter'
mongo = require('./mongo')
Readability = require('./readability').Client
Content = require('./content').Content

mongo.mongoose.model 'Link',
  properties: ['url','redirects','title','user_id', 'content', {'status':['id','text',{'user':['screen_name','name']},'created_at']}]
  indexes:['user_id',{'status.created_at':-1}]
  static:
    fromStatus:(user, status)->
      links = []
      if status.entities.urls
        for url in status.entities.urls
          l = new this.constructor()
          l.user_id = user.id
          l.url = url.url
          l.status.id = status.id
          l.status.text = status.text
          l.status.user.screen_name = status.user.screen_name
          l.status.user.name = status.user.name
          l.status.created_at = status.created_at
          l.save
          links.push l
      links
  methods:
    fetchContent:->
      try
        self = this
        REST.get this.url,(response)->
          if response.status >= 200 && response.status < 300
            Logger.debug "Link", "Fetched successfully (#{self.url})"
            Content.for self, response.body, (result)->
              self.content = result.content
              self.title = result.title
              Logger.debug "Link", "Content parsed successfully. (#{self.title})"
              self.save()

          # Follow redirects to their source!
          else if [300,301,302,303,305,307].indexOf(response.status) != -1 and self.redirects <= 3
            location = response.headers['Location'] || response.headers['location']
            Logger.debug "Link", "#{self.url} is a redirect, following to #{location}"
            self.url = location
            self.redirects ||= 0
            self.redirects += 1
            self.save ->
              self.fetchContent()
      catch error
        Logger.warn "Link", "#{self.url} could not be fetched."
        
exports.Link = mongo.db.model 'Link'