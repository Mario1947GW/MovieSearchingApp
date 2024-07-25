require 'rails_helper'

RSpec.describe UserListCommandsService do
  let!(:user) { create(:user) }
  let!(:user_list) { create(:user_list, user: user) }
  let(:user_list_item) { create(:user_list_item, user_list: user_list) }
  let(:service) { described_class.new(user) }

  describe '#initialize' do
    it 'initializes with a user and sets @user_list' do
      expect(service.instance_variable_get(:@user)).to have_attributes(id: user.id)
      expect(service.instance_variable_get(:@user_list)).to have_attributes(
                                                              id: user_list.id,
                                                              user: user_list.user)
    end
  end

  describe '#find_user_list_item' do
    it 'finds the correct user list item' do
      found_item = service.find_user_list_item(user_list_item.item_id)
      expect(found_item).to eq(user_list_item)
    end

    it 'returns nil if the item is not found' do
      expect(service.find_user_list_item(-1)).to be_nil
    end
  end

  describe '#new_item_to_user_list' do
    it 'creates a new UserListItem instance' do
      new_item = service.new_item_to_user_list(1234, 'movie')
      expect(new_item).to be_a(UserListItem)
      expect(new_item.item_id).to eq(1234)
      expect(new_item.item_type).to eq('movie')
      expect(new_item.user_list).to eq(user_list)
    end
  end

  describe '#try_to_add_item' do
    context 'when item saves successfully' do
      it 'returns a success message' do
        new_item = service.new_item_to_user_list(1234, 'movie')
        expect(service.try_to_add_item(new_item)).to eq(I18n.t('messages.item_added_to_my_list'))
      end
    end

    context 'when item fails to save' do
      it 'returns error messages' do
        allow_any_instance_of(UserListItem).to receive(:save).and_return(false)
        new_item = service.new_item_to_user_list(1234, 'movie')
        new_item.errors.add(:base, 'Error message')
        expect(service.try_to_add_item(new_item)).to eq('Error message')
      end
    end
  end

  describe '#try_to_destroy_item' do
    context 'when item is destroyed successfully' do
      it 'returns a success message' do
        expect(service.try_to_destroy_item(user_list_item)).to eq(I18n.t('messages.item_removed_from_my_list'))
      end
    end

    context 'when item fails to destroy' do
      it 'returns error messages' do
        allow_any_instance_of(UserListItem).to receive(:destroy).and_return(false)
        user_list_item.errors.add(:base, 'Error message')
        expect(service.try_to_destroy_item(user_list_item)).to eq('Error message')
      end
    end
  end
end
