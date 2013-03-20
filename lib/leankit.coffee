request = require 'request'

LKK_DOMAIN = 'leankitkanban.com'
API_SUFFIX = '/Kanban/API'


class LeankitBase

  constructor: (config) ->
    @config = config

  get: (api_call, callback) ->
    uri = "#{@config.uri()}#{api_call}"
    request.get(
      uri,
      auth:
        username: @config.username
        password: @config.password
        sendImmediately: true
    , callback)

class Config

  constructor: (options = {}) ->
    @account = options.account
    @username = options.username
    @password = options.password

    if not @account
      throw new Error 'Must provide an account.'
    if not @username
      throw new Error 'Must provide a username.'
    if not @password
      throw new Error 'Must provide a password.'

  uri: () ->
    "https://#{@account}.#{LKK_DOMAIN}#{API_SUFFIX}"


class Board extends LeankitBase

  constructor: (config) ->
    super(config)

  fetch: (boardId, callback) ->
    if not @cache?
      @get "/Boards/#{boardId}", (err, response, body) =>
        # TODO: We should probably callback(err) if err is not undefined
        return callback(new Error("Fetch returned status #{response.statusCode}")) if response.statusCode != 200
        @parse(body, callback)
    else
      callback()

  parse: (body, callback) ->
    @data = JSON.parse(body).ReplyData[0]
    callback(undefined, @cache)

  getTitle: () ->
    @data.Title

  getId: () ->
    @data.Id

  getId: () ->
    @data.Id

  getDescription: () ->
    @data.Description

  getVersion: () ->
    @data.Version

  isActive: () ->
    @data.Active

  getLanes: () ->
    new Lane(@config, lane) for lane in @data.Lanes

  getLaneByTitle: (title) ->
    for lane in @getLanes()
      if lane.getTitle() == title
        return lane

  getLaneById: (id) ->
    for lane in @getLanes()
      if lane.getId() == id
        return lane


class Lane extends LeankitBase

  constructor: (config, @lane) ->
    super(config)

  getTitle: () ->
    @lane.Title

  getId: () ->
    @lane.Id

class BoardData extends LeankitBase

  all: (callback) ->
    @get '/Boards', callback

  find: (boardId, callback) ->
    @get "/Boards/#{boardId}", callback

  getIdentifiers: (boardId, callback) ->
    @get "/Board/#{boardId}/GetBoardIdentifiers", callback

  getNewerIfExists: (boardId, versionId, callback) ->
    @get "/Board/#{boardId}/BoardVersion/#{versionId}/GetNewerIfExists", callback

  getBoardHistorySince: (boardId, versionId, callback) ->
    @get "/Board/#{boardId}/BoardVersion/#{versionId}/GetBoardHistorySince", callback


class Backlog extends LeankitBase

  fetch: (boardId, callback) ->
    @get "/Board/#{boardId}/Backlog", callback


class Card extends LeankitBase

  find: (boardId, cardId, callback) ->
    @get "/Board/#{boardId}/GetCard/#{cardId}", callback

  findByExternalId: (boardId, externalId, callback) ->
    @get "/Board/#{boardId}/GetCardByExternalId/#{externalId}", callback


class Archive extends LeankitBase

  fetch: (boardId, callback) ->
    @get "/Board/#{boardId}/Archive", callback

module.exports.Config = Config
module.exports.Board = Board
module.exports.BoardData = BoardData
module.exports.Backlog = Backlog
module.exports.Card = Card
module.exports.Archive = Archive
module.exports.Lane = Lane
module.exports.base = LeankitBase
