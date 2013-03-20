leankit = require '../lib/leankit'


describe 'leankit.Archive', ->

  beforeEach ->
    @config = new leankit.Config(
      account: 'example'
      username: 'testing@example.com'
      password: 'password'
    )
    @archive = new leankit.Archive(@config)

  afterEach ->
    @archive.get.reset()

  describe '.find', ->
    it 'gets the board archive', () ->
      spyOn(@archive, 'get')

      @archive.fetch(12345)
      expect(@archive.get).toHaveBeenCalledWith '/Board/12345/Archive', undefined
