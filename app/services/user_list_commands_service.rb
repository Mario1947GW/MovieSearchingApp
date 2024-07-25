class UserListCommandsService
  def initialize(user)
    @user = user
    @user_list = @user.user_list || UserList.create(user: @user)
  end

  def find_user_list_item(id)
    UserListItem.find_by(user_list: @user_list, item_id: id)
  end

  def new_item_to_user_list(id, type)
    UserListItem.new(user_list: @user_list, item_id: id, item_type: type)
  end

  def try_to_add_item(item)
    return I18n.t('messages.item_added_to_my_list') if item.save

    item.errors.full_messages.join
  end

  def try_to_destroy_item(item)
    return I18n.t('messages.item_removed_from_my_list') if item.destroy

    item.errors.full_messages.join
  end
end
