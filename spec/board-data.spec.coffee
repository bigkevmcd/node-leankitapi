leankit = require '../lib/leankit'


describe 'leankit.BoardData', ->

  beforeEach ->
    @config = new leankit.Config(
      account: 'example'
      username: 'testing@example.com'
      password: 'password'
    )
    @boardData = new leankit.BoardData(@config)

  afterEach ->
    @boardData.get.reset()

  describe '.all', ->
    it 'gets all boards for that account', () ->
      spyOn(@boardData, 'get')
      @boardData.all()
      expect(@boardData.get).toHaveBeenCalledWith '/Boards', undefined

  describe '.find', ->
    it 'gets the board whose id is passed as a parameter', () ->
      spyOn(@boardData, 'get')
      @boardData.find(12345)
      expect(@boardData.get).toHaveBeenCalledWith '/Boards/12345', undefined

  describe '.getIdentifiers', ->
    it 'gets the identifiers of the board whose id is passed as parameter', ->
      spyOn(@boardData, 'get')
      @boardData.getIdentifiers(12345)
      expect(@boardData.get).toHaveBeenCalledWith '/Board/12345/GetBoardIdentifiers', undefined

  describe '.getNewerIfExists', ->
    it 'gets a greater version of the board than the one passed', ->
      spyOn(@boardData, 'get')

      @boardData.getNewerIfExists(12345, 123)
      expect(@boardData.get).toHaveBeenCalledWith '/Board/12345/BoardVersion/123/GetNewerIfExists', undefined

  describe '.GetBoardHistorySince', ->
    it 'gets a greater version of the board than the one passed', ->
      spyOn(@boardData, 'get')
      @boardData.getBoardHistorySince(12345, 123)

      expect(@boardData.get).toHaveBeenCalledWith '/Board/12345/BoardVersion/123/GetBoardHistorySince', undefined
