require 'rails_helper'

RSpec.describe UserListQueryService do
  let!(:user) { create(:user) }
  let!(:user_list) { create(:user_list, user: user) }
  let!(:user_list_items) do
    create_list(:user_list_item, 30, user_list: user_list)
  end
  let(:service) { described_class.new(user) }

  describe '#initialize' do
    it 'initializes with a user and sets @user_list' do
      expect(service.user_list).to match_array(user_list_items)
    end
  end

  describe '#fetch_user_list_items_ids' do
    it 'returns an array of item_ids' do
      expect(service.fetch_user_list_items_ids).to match_array(user_list_items.pluck(:item_id))
    end

    it 'returns nil if @user_list is nil' do
      service_with_no_list = described_class.new(create(:user))
      expect(service_with_no_list.fetch_user_list_items_ids).to be_nil
    end
  end

  describe '#fetch_user_list_items_count' do
    it 'returns the count of user list items' do
      expect(service.fetch_user_list_items_count).to eq(user_list_items.count)
    end

    it 'returns 0 if @user_list is nil' do
      service_with_no_list = described_class.new(create(:user))
      expect(service_with_no_list.fetch_user_list_items_count).to eq(0)
    end
  end

  describe '#paginate_results' do
    let(:per_page) { 10 }
    let(:current_page) { 2 }

    it 'returns paginated results based on current page and per_page' do
      paginated_results = service.paginate_results(current_page, per_page)
      expect(paginated_results.size).to eq(per_page)
      expect(paginated_results.first).to eq(user_list_items[per_page])
    end

    it 'returns an empty collection if page is out of range' do
      paginated_results = service.paginate_results(100, per_page)
      expect(paginated_results).to be_empty
    end
  end

  describe '#total_pages' do
    let(:per_page) { 10 }

    it 'returns the correct number of total pages' do
      total_pages = service.total_pages(user_list_items.count, per_page)
      expect(total_pages).to eq((user_list_items.count / per_page.to_f).ceil)
    end
  end
end
