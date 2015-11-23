Promise = require('bluebird')
StrikerUtil = require('striker-util')
request = require('request')
_ = require('lodash')
fs = require('fs')
STRIKER2 = {
  "host": "https://striker.teambition.net"
  "storage": "striker-hz"
  "secretKeys": "Usdsiwcs78Ymhpewlk"
  "expiresInSeconds": 86400
}

strikerUtil = new StrikerUtil(STRIKER2)

imgs = [
  'http://p4.gexing.com/G1/M00/02/98/rBACE1I8Njewr-noAAAnTl6oaX8978_200x200_3.jpg?recache=20131108'
  'http://img2.imgtn.bdimg.com/it/u=2961745186,4122448994&fm=21&gp=0.jpg'
  'http://img1.imgtn.bdimg.com/it/u=3253788387,1194606662&fm=21&gp=0.jpg'
  'http://a.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=32afb495d3ca7bcb7d2ecf2b8b394755/78310a55b319ebc4f7e4fbcf8626cffc1f1716c3.jpg'
  'http://img1.imgtn.bdimg.com/it/u=2343591798,2818369097&fm=21&gp=0.jpg'
  'http://img0.imgtn.bdimg.com/it/u=152439432,3140192556&fm=21&gp=0.jpg'
  'http://p2.gexing.com/touxiang/20130123/2236/50fff55dedf9d_200x200_3.jpg'
  'http://www.qq1234.org/uploads/allimg/140930/3_140930155743_3.jpg'
  'http://p4.gexing.com/G1/M00/39/E8/rBABFFGpZBeTscJpAAAhYR9FDkc522_200x200_3.jpg?recache=20131108'
]

generateAvatar = (url, callback) ->
  return callback() unless url
  api = 'forremote'
  body =
    downloadUrl: url
    source: 'remote'
  bearer = strikerUtil.signAuth agent: "teambition"
  request.post
    url: "#{STRIKER2.host}/#{api}"
    body: body
    json: true
    headers:
      'userId': 'teambition'
      'authorization': bearer
  , (err, res, body) ->
    if err or not body?.thumbnailUrl
      callback()
    else
      callback(null, body.thumbnailUrl)

transfer = ->
  Promise.map imgs, (img) ->
    Promise.promisify(generateAvatar)(img)
  .then (avatars) ->
    avatars = _.filter avatars, (avatar) -> return !!avatar
    str = avatars.join(',')
    fs.writeFileSync('./avatar.txt', str, 'utf8')
    console.log 'done'

transfer()
