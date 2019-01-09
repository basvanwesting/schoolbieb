require 'rails_helper'

feature 'Series JSON API', type: :request do

  context 'success' do

    before do
      sign_in FactoryBot.create(:user)
      @env ||= {}
      #@env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email,password)
      #@env['CONTENT_TYPE'] = 'application/soap+xml'
      @env['ACCEPT'] = 'application/json'
    end

    xit "index" do
      get "/series", params: { q: { series_cont: 'pot' } }, headers: @env

      expect(response.body).to eq "[\"Harry potter\"]"
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.status).to eq 200
    end

    it "index" do
      get "/series", params: { term: 'pot' }, headers: @env

      expect(response.body).to eq "[\"Harry potter\"]"
      expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response.status).to eq 200
    end
  end

end

