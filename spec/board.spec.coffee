leankit = require '../lib/leankit'
nock = require 'nock'
fs = require 'fs'


describe 'leankit.Board', ->

  beforeEach ->
    @config = new leankit.Config(
      account: 'example'
      username: 'testing@example.com'
      password: 'password'
    )
    @board = new leankit.Board(@config)

  describe '.fetch', ->
    it 'gets the board whose id is passed as a parameter', (done) ->
      scope = nock('https://example.leankitkanban.com').
          get('/Kanban/API/Boards/12345').
          matchHeader('Authorization', 'Basic dGVzdGluZ0BleGFtcGxlLmNvbTpwYXNzd29yZA==').
          replyWithFile(200, __dirname + '/fixtures/board.json')

      @board.fetch 12345, (err) ->
        expect(err).toBeFalsy()
        scope.done()
        done()

    it 'does not fetch the board data again if we have it cached', (done) ->
      @board.cache =
        title: 'This is a title'

      spyOn(@board, 'get')
      @board.fetch 12345, (err) =>
        expect(@board.get).not.toHaveBeenCalled()
        @board.get.reset()
        done()

    it 'calls back with the error if we get a non 200 response', (done) ->
      scope = nock('https://example.leankitkanban.com').
          get('/Kanban/API/Boards/12345').
          matchHeader('Authorization', 'Basic dGVzdGluZ0BleGFtcGxlLmNvbTpwYXNzd29yZA==').
          reply(404)

      @board.fetch 12345, (err) ->
        expect(err.message).toEqual 'Fetch returned status 404'
        scope.done()
        done()

  describe '.parse', ->
    it 'parses out the elements in the supplied body', (done) ->
      @board.parse (JSON.stringify
        ReplyCode: 200,
        ReplyText: 'Board successfully retrieved.',
        ReplyData: [
          Id: 12345,
          Title: 'Simple Board'
        ])
      , () =>
        expect(@board.getTitle()).toBe 'Simple Board'
        done()

  describe 'accessor methods', ->
    beforeEach (done) ->
      fs.readFile __dirname + '/fixtures/board.json', (err, data) =>
        @board.parse data, done

    describe '.getTitle', ->
      it 'returns the title of the board', ->
        expect(@board.getTitle()).toBe 'Simple Board'

    describe '.getId', ->
      it 'returns the Id of the board', ->
        expect(@board.getId()).toBe 101000

    describe '.getDescription', ->
      it 'returns the description of the board', ->
        expect(@board.getDescription()).toBe 'Example of a Simple Value Stream'

    describe '.getVersion', ->
      it 'returns the current version of the board', ->
        expect(@board.getVersion()).toBe 212

    describe '.isActive', ->
      it 'returns true if the board is active', ->
        expect(@board.isActive()).toBeFalsy()

    describe '.getLanes', ->
      it 'returns the lanes from the current board', ->
        lanes = @board.getLanes()
        expect(lanes.length).toBe 6
        expect(lanes[0]).toEqual jasmine.any(leankit.Lane)
        expect(lanes[0].getTitle()).toBe 'Ready'

    describe '.getLaneByTitle', ->
      it 'returns the lane with the specified title', ->
        lane = @board.getLaneByTitle 'Ready'
        expect(lane).toEqual jasmine.any(leankit.Lane)
        expect(lane.getTitle()).toBe 'Ready'

      it 'returns undefined if there is no lane with the specified title', ->
        expect(@board.getLaneByTitle('Unknown')).toBeUndefined()

    describe '.getLaneById', ->
      it 'returns the lane with the specified Id', ->
        lane = @board.getLaneById 101107
        expect(lane).toEqual jasmine.any(leankit.Lane)
        expect(lane.getTitle()).toBe 'Ready'

      it 'returns undefined if there is no lane with the specified Id', ->
        expect(@board.getLaneById(999999)).toBeUndefined()
