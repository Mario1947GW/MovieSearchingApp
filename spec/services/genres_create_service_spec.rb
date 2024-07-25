require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GenresCreateService do
  let(:service) { described_class.new }
  let(:http_service_double) { instance_double(HttpService) }
  let(:api_key) { ENV.fetch('API_KEY') }
  let(:host_url) { 'https://api.themoviedb.org/3/' }
  let(:response_body) do
    {
      'genres' => [
        { 'id' => 1, 'name' => 'Action' },
        { 'id' => 2, 'name' => 'Comedy' }
      ]
    }
  end

  before do
    allow(HttpService).to receive(:new).and_return(http_service_double)
    allow(http_service_double).to receive(:send_request).and_return(response_body)
  end

  describe '#create_if_not_exist' do
    context 'when genres for movie and tv already exist' do
      before do
        create(:genre, for: 'movie', name: "comedy")
        create(:genre, for: 'tv', name: "drama")
      end

      it 'does not create any new genres' do
        expect { service.create_if_not_exist }.not_to change { Genre.count }
      end
    end

    context 'when genres for movie or tv do not exist' do
      it 'creates genres for both movie and tv' do
        expect { service.create_if_not_exist }.to change { Genre.count }.by(4)
      end
    end
  end

  describe '#create_genres' do
    it 'creates genres based on API response' do
      expect { service.create_genres('movie') }.to change { Genre.count }.by(2)

      expect(Genre.where(for: 'movie').pluck(:name)).to contain_exactly('Action', 'Comedy')
    end
  end
end
