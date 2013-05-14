async = require 'async'
request = require 'request'
cheerio = require 'cheerio'


class Tinysong


# login first to get the session from tinysong site.
request 
  url: 'http://tinysong.com/'
  headers:
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    'Accept-Charset': 'UTF-8,*;q=0.5'
    'Accept-Encoding': 'gzip,deflate,sdch'
    'Accept-Language': 'en-US,en;q=0.8'
    'Cache-Control': 'max-age=0'
    'Connection': 'keep-alive'
    'Host': 'tinysong.com'
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'
, 
  (err, res, body) ->
    null


# extract song info from html.
extractSongInfoArrayFromHtml = (html) ->
  $ = cheerio.load html
  results = $('.result')

  songInfoArray = []
  for result, index in results
    result = results.eq index

    songInfo =
      SongID: parseInt result.find('.play').attr('rel'), 10
      SongName: result.find('.track .song').text()
      ArtistID: 0
      ArtistName: result.find('.track .artist').text()
      AlbumID: 0
      AlbumName: ''
    songInfoArray.push songInfo

  songInfoArray


# return songs.
Tinysong.getSongInfoArray = (trackTitle, artistName, startNo, callback) ->
  trackTitle = ''  if not trackTitle?
  artistName = ''  if not artistName?

  request.post 
    url: 'http://tinysong.com/?s=s'
    headers:
      'Accept': 'application/json, text/javascript, */*'
      'Accept-Charset': 'UTF-8,*;q=0.5'
      # 'Accept-Encoding': 'gzip,deflate,sdch'
      'Accept-Language': 'en-US,en;q=0.8'
      'Content-Type': 'application/x-www-form-urlencoded'
      'Host': 'tinysong.com'
      'Origin': 'http://tinysong.com'
      'Referer': 'http://tinysong.com/'
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'
      'X-Requested-With': 'XMLHttpRequest'
    body: "q[]=#{trackTitle} #{artistName}&q[]=#{startNo}"
  ,
    (err, res, body) ->
      return callback err, null  if err?
      return callback new Error('Status Code is not 200'), null  if res.statusCode isnt 200
      callback null, extractSongInfoArrayFromHtml JSON.parse(body).html


# return a song.
Tinysong.getSongInfo = (trackTitle, artistName, callback) ->
  trackTitle = ''  if not trackTitle?
  artistName = ''  if not artistName?
  
  startNo = 0
  resultSongInfo = null

  isFound = false

  # tinysong에서 원하는 결과를 얻거나 결과가 없을 때 까지 계속 쿼리를 날려 값을 가져온다.
  async.until ->
    isFound
  ,
    (callback) ->
      Tinysong.getSongInfoArray trackTitle, artistName, startNo, (err, songInfoArray) ->
        return callback err  if err?
        return callback new Error('no song anymore.')  if songInfoArray.length is 0
        
        for songInfo in songInfoArray
          if songInfo.SongName.toLowerCase().indexOf(trackTitle.toLowerCase()) > -1 and
              songInfo.ArtistName.toLowerCase().indexOf(artistName.toLowerCase()) > -1
            resultSongInfo = songInfo
            isFound = true
            return callback null

        startNo += songInfoArray.length
        callback null
  ,
    (err) ->
      return callback null, null  if err?
      return callback null, resultSongInfo


module.exports = Tinysong
