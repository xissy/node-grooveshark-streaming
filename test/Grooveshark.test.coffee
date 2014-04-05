should = require 'should'

Tinysong = require '../lib/Tinysong'
Grooveshark = require '../lib/Grooveshark'


describe 'Grooveshark', ->
  trackTitle = '꿈에'
  artistName = '박정현'

  describe 'Grooveshark.getStreamingUrl(...)', ->
    it 'should be done', (done) ->
      Tinysong.getSongInfo trackTitle, artistName, (err, songInfo) ->
        should.not.exist err
        should.exist songInfo

        Grooveshark.getStreamingUrl songInfo.SongID, (err, streamUrl) ->
          should.not.exist err
          should.exist streamUrl
          done()
        
