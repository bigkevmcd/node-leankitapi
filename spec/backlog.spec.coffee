leankit = require '../lib/leankit'


describe 'leankit.Backlog', ->

  beforeEach ->
    @config = new leankit.Config(
      account: 'example'
      username: 'testing@example.com'
      password: 'password'
    )
    @backlog = new leankit.Backlog(@config)

  afterEach ->
    @backlog.get.reset()

  describe '.fetch', ->
    it 'gets the board backlog', () ->
      spyOn(@backlog, 'get')

      @backlog.fetch(12345)
      expect(@backlog.get).toHaveBeenCalledWith '/Board/12345/Backlog', undefined
