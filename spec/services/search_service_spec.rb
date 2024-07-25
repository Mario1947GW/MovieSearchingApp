require "rails_helper"
require "webmock/rspec"
RSpec.describe SearchService, type: :service do
  let(:search_service) { described_class.new }
  let(:api_key) { 'test_api_key' }

  before do
    allow(ENV).to receive(:fetch).with('API_KEY').and_return(api_key)
  end

  describe '#build_discover_url' do
    it 'builds the correct URL with given parameters' do
      params = {
        type: 'movie',
        page: 1,
        primary_release_year: 2020,
        with_genres: '28,12',
        with_cast: 'Robert Downey Jr.',
        'vote_average.gte' => 7
      }

      expected_url = "https://api.themoviedb.org/3/discover/movie?api_key=test_api_key&page=1&primary_release_year=2020&with_genres=28%2C12&with_cast=3223&vote_average.gte=7"

      stub_request(:get, "https://api.themoviedb.org/3/search/person?query=Robert%20Downey%20Jr.&api_key=test_api_key&")
        .to_return(status: 200, body: { results: [{ id: 3223 }] }.to_json, headers: {})

      expect(search_service.build_discover_url(params)).to eq(expected_url)
    end
  end

  describe '#build_search_by_title_url' do
    it 'builds the correct URL for searching by title' do
      params = { page: 1, title: 'Inception' }
      expected_url = "https://api.themoviedb.org/3/search/multi?api_key=test_api_key&page=1&query=Inception"

      expect(search_service.build_search_by_title_url(params)).to eq(expected_url)
    end
  end

  describe '#build_person_url' do
    it 'builds the correct URL for searching a person' do
      person = 'Leonardo DiCaprio'
      expected_url = "https://api.themoviedb.org/3/search/person?query=Leonardo%20DiCaprio&api_key=test_api_key&"

      expect(search_service.build_person_url(person)).to eq(expected_url)
    end
  end

  describe '#cast_url' do
    it 'replaces names with IDs in the given parameter' do
      params = 'Robert Downey Jr.,Chris Evans'

      stub_request(:get, "https://api.themoviedb.org/3/search/person?query=Robert%20Downey%20Jr.&api_key=test_api_key&")
        .to_return(status: 200, body: { results: [{ id: 3223 }] }.to_json, headers: {})

      stub_request(:get, "https://api.themoviedb.org/3/search/person?query=Chris%20Evans&api_key=test_api_key&")
        .to_return(status: 200, body: { results: [{ id: 16828 }] }.to_json, headers: {})

      expected_params = '3223,16828'

      expect(search_service.cast_url(params)).to eq(expected_params)
    end

    it 'returns nil if params are nil' do
      expect(search_service.cast_url(nil)).to be_nil
    end
  end
end
