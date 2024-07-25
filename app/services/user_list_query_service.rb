class UserListQueryService
  attr_reader :user_list

  def initialize(user)
    @user = user
    @user_list = @user&.user_list&.user_list_items
  end

  def fetch_user_list_items_ids(list: @user_list)
    list&.pluck(:item_id)
  end

  def fetch_user_list_items_count
    @user_list&.count || 0
  end

  def paginate_results(current_page, per_page)
    offset = (current_page - 1) * per_page
    @user_list.offset(offset).limit(per_page)
  end

  def total_pages(items_count, per_page)
    (items_count / per_page.to_f).ceil
  end
end
