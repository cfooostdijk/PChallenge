require 'rails_helper'

describe 'https://pokeapi.co/api/v2' do
  let!(:base_url) { 'https://pokeapi.co/api/v2' }
  let!(:connection) do
    Faraday.new(url: base_url) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  context '/pokemon' do
    let!(:endpoint) { 'pokemon' }
    let!(:response) { connection.get endpoint }

    it 'responds with a 200 Success' do
      expect(response.status).to eq 200
    end

  context '/pokemon/:id' do
    let!(:endpoint) { "pokemon/1" }
    let!(:response) { connection.get endpoint }

    it 'responds with a 200 Success' do
      expect(response.status).to eq 200
    end
  end

  context '/characteristic/:id' do
    let!(:endpoint) { 'characteristic/1' }
    let!(:response) { connection.get endpoint }

    it 'responds with a 200 Success' do
      expect(response.status).to eq 200
    end
  end
end
