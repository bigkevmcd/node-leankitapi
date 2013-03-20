leankit = require '../lib/leankit'
nock = require 'nock'


describe 'leankit.LeankitBase', ->

  beforeEach ->
    @config = new leankit.Config(
      account: 'example'
      username: 'testing@example.com'
      password: 'password'
    )
    @base = new leankit.base(@config)

  describe '.get', ->
    it 'sends the authorization header with the request', (done) ->
      scope = nock('https://example.leankitkanban.com').
          get('/Kanban/API/Boards').
          matchHeader('Authorization', 'Basic dGVzdGluZ0BleGFtcGxlLmNvbTpwYXNzd29yZA==').
          reply(200, 'result')

      @base.get '/Boards', (err, response, body) ->
        scope.done()
        done()