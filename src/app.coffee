CronJob = require('cron').CronJob
request = require('request')
config = require('config')

avatars = config.avatars
tbToken = config.token

new CronJob '* * 8 * * 1-5', ->
  day = new Date().getDay() - 1
  avatar = avatars[day]
  request.put
    uri: 'https://account.teambition.com/papi/account/update'
    headers:
      Authorization: "OAuth2 #{tbToken}"
    body:
      avatarUrl: avatar
    json: true
  , (err, res, body) ->
    console.log "success, avatar is now #{avatar}"
, ->
  consol.log('job done')
,true
