require 'rails_helper'

RSpec.describe 'API V2 for Holding Institutions', type: :request do
  headers = { 'X-User-Token' => Rails.application.secrets.api_token }
  context 'can list using #index' do
    before(:each) do
      @collection = Fabricate :empty_collection
      Fabricate.times(3, :holding_institution,
                      repositories: [@collection.repository])
      @holding_institution = HoldingInstitution.last
    end
    it 'returns an array of holding institutions' do
      get '/api/v2/holding_institutions.json', {}, headers
      expect(response.content_type).to eq 'application/json'
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).length).to eq 4
    end
    it 'paginates list of holding institutions' do
      get '/api/v2/holding_institutions.json', { page: 2, per_page: 2 }, headers
      expect(JSON.parse(response.body).length).to eq 2
    end
    it 'returns holding institutions filtered by institution type' do
      Fabricate(:holding_institution, institution_type: '###')
      get '/api/v2/holding_institutions.json',
          { page: 1, per_page: 1, type: '###' },
          headers
      expect(JSON.parse(response.body)[0]['institution_type']).to(
        eq('###')
      )
    end
    it 'returns holding institutions filtered by starting letter' do
      Fabricate(:holding_institution, authorized_name: '# Holding Inst')
      get '/api/v2/holding_institutions.json',
          { page: 1, per_page: 10, letter: '#' },
          headers
      expect(JSON.parse(response.body).length).to eq 1
    end
    it 'includes collection information' do
      get '/api/v2/holding_institutions.json', { page: 1, per_page: 1 }, headers
      json = JSON.parse(response.body)
      expect(json[0]['collections'].length).to eq 1
      expect(json[0]['collections'][0]['id']).to(
        eq(@collection.id)
      )
    end
    it 'returns holding institutions filtered by portal' do
      portal = Fabricate :portal
      Fabricate(:holding_institution,
                repositories: [Fabricate(:empty_repository, portals: [portal])])
      get(
        '/api/v2/holding_institutions.json',
        { portal: portal.code },
        headers
      )
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      expect(json[0]['portals'][0]['code']).to eq portal.code
    end
    it 'returns holding institutions filtered by portal, letter and type' do
      portal = Fabricate :portal
      hi = Fabricate(:holding_institution,
                     repositories: [
                       Fabricate(:empty_repository, portals: [portal])
                     ])
      get(
        '/api/v2/holding_institutions.json',
        { portal: portal.code, letter: hi.authorized_name[0],
          type: hi.institution_type },
        headers
      )
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      expect(json[0]['authorized_name']).to eq hi.authorized_name
      expect(json[0]['portals'][0]['code']).to eq portal.code
    end

  end
  context 'can get single record info using #show' do
    before(:each) do
      @collection = Fabricate :empty_collection
      @holding_institution = HoldingInstitution.last
    end
    it 'returns all data about a holding institution' do
      get "/api/v2/holding_institutions/#{@holding_institution.slug}.json",
          {},
          headers
      json = JSON.parse(response.body)
      expect(response.content_type).to eq 'application/json'
      expect(response.status).to eq 200
      expect(json['slug']).to eq @holding_institution.slug
      expect(json['collections'].length).to eq 1
      expect(json['collections'][0]['id']).to(
        eq(@collection.id)
      )
    end
  end
end