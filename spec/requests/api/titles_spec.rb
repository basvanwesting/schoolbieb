require 'rails_helper'

feature 'Titles JSON API', type: :request do

  context 'success' do

    before do
      sign_in FactoryBot.create(:user)
      @env ||= {}
      #@env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,password)
      #@env['CONTENT_TYPE'] = 'application/soap+xml'
      @env['ACCEPT'] = 'application/json'

      FactoryBot.create(:book, title: 'Een miniheks in het weerwolvenbos')
      FactoryBot.create(:book, title: 'Weerwolvenbos')
      FactoryBot.create(:book, title: 'Weerwolvenfeest', part: 1)
      FactoryBot.create(:book, title: 'Weerwolvenfeest', part: 2)
      FactoryBot.create(:book, title: 'Weerwolvensoep')
    end

    xit "index" do
      get "/titles", params: { q: { title_cont: 'weerwolv' } }, headers: @env

      expect(response.body).to eq "[\"Een miniheks in het weerwolvenbos\",\"Weerwolvenbos\",\"Weerwolvenfeest\",\"Weerwolvensoep\"]"
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.status).to eq 200
    end

    it "index" do
      get "/titles", params: { term: 'weerwolv' }, headers: @env

      expect(response.body).to eq "[\"Een miniheks in het weerwolvenbos\",\"Weerwolvenbos\",\"Weerwolvenfeest\",\"Weerwolvensoep\"]"
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.status).to eq 200
    end
  end

end

