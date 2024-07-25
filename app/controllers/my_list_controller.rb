class MyListController < ApplicationController
  require 'net/http'

  def index
    service = UserListQueryService.new(current_user)
    @items_count = service.fetch_user_list_items_count
    @total_pages = service.total_pages(@items_count, 20)
    @items = service.paginate_results((params[:page] || 1).to_i, 20)
    @my_list = service.fetch_user_list_items_ids(list: @items)
    @genres = GenresQueryService.new.all_genres
  end

  def find_item_by_id(id, type)
    HttpService.new.send_request("https://api.themoviedb.org/3/#{type}/#{id}?api_key=#{ENV.fetch('API_KEY', '')}")
  end

  def add_item_to_my_list
    service = UserListCommandsService.new(current_user)
    message = service.try_to_add_item(service.new_item_to_user_list(params[:id], params[:type]))
    respond_to do |format|
      format.html
      format.json { render json: { message: message } }
    end
  end

  def remove_item_from_my_list
    service = UserListCommandsService.new(current_user)
    message = service.try_to_destroy_item(service.find_user_list_item(params[:id]))
    respond_to do |format|
      format.html
      format.json { render json: { message: message } }
    end
  end

  helper_method :find_item_by_id
end
