leankit = require '../lib/leankit'


describe 'leankit.Card', ->

  beforeEach ->
    @config = new leankit.Config(
      account: 'example'
      username: 'testing@example.com'
      password: 'password'
    )
    @card = new leankit.Card(@config)

  afterEach ->
    @card.get.reset()

  describe '.find', ->
    it 'gets the board card whose id is passed', () ->
      spyOn(@card, 'get')

      @card.find(12345, 123)
      expect(@card.get).toHaveBeenCalledWith '/Board/12345/GetCard/123', undefined

  describe '.findByExternalId', ->
    it 'gets the board card whose id is passed', () ->
      spyOn(@card, 'get')

      @card.findByExternalId(12345, '#12345')
      expect(@card.get).toHaveBeenCalledWith '/Board/12345/GetCardByExternalId/#12345', undefined

#  describe :delete do  
#    before :each do
#      @board_id  = mock("boardID")
#      @card_id   = mock("cardID")
#    end
#
#    it "deletes the board card whose id is passed" do
#      api_call = "/Board/#{@board_id}/DeleteCard/#{@card_id}"
#      LeanKitKanban::Card.should_receive(:get).with(api_call)
#      LeanKitKanban::Card.delete(@board_id, @card_id)
#    end
#  end
#end
