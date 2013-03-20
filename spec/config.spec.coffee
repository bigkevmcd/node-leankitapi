leankit = require '../lib/leankit'


describe 'leankit.Config', ->

  describe 'the constructor function', ->
    it 'throws an error if no account is provided', () ->
      expect( ->
        new leankit.Config(
          username: 'testing@example.com'
          password: 'testing'
        )
      ).toThrow (new Error 'Must provide an account.')

    it 'throws an error if no username is provided', () ->
      expect( ->
        new leankit.Config(
          account: 'example'
          password: 'testing'
        )
      ).toThrow (new Error 'Must provide a username.')

    it 'throws an error if no password is provided', () ->
      expect( ->
        new leankit.Config(
          account: 'example'
          username: 'testing@example.com'
        )
      ).toThrow (new Error 'Must provide a password.')

  describe '.uri', ->
    beforeEach ->
      @config = new leankit.Config(
        account: 'example'
        username: 'testing@example.com'
        password: 'password'
      )
    it 'returns the domain including the account', () ->
      expect(@config.uri()).toEqual "https://example.leankitkanban.com/Kanban/API"
