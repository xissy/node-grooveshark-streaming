should = require 'should'

Tinysong = require '../lib/Tinysong'


describe 'Tinysong', ->
  trackTitle = '꿈에'
  artistName = '박정현'
  startNo = 0

  describe 'Tinysong.getSongInfoArray(...)', ->
    it 'should be done', (done) ->
      Tinysong.getSongInfoArray trackTitle, artistName, startNo, (err, songInfoArray) ->
        should.not.exist err
        should.exist songInfoArray
        songInfoArray.should.not.be.empty
        done()

  describe 'Tinysong.getSongInfo(...)', ->
    it 'should be failed to find a song', (done) ->
      Tinysong.getSongInfo 'nosonglikethis', 'nosingerlikethis', (err, songInfo) ->
        should.not.exist err
        should.not.exist songInfo
        done()

    it 'should be done', (done) ->
      Tinysong.getSongInfo trackTitle, artistName, (err, songInfo) ->
        should.not.exist err
        should.exist songInfo
        done()
