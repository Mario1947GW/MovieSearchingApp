class SearchController < ApplicationController
  require 'net/http'

  before_action :create_genres_if_not_exist, only: :index

  def index
    @genres = GenresQueryService.new.fetch_genres('movie')
  end

  def results
    read_response(search(HttpService.new))
    @my_list = UserListQueryService.new(current_user).fetch_user_list_items_ids
    @genres = GenresQueryService.new.fetch_genres(params[:type])
  end

  def genres_list
    @genres = GenresQueryService.new.fetch_genres_ids_and_names(params[:type])
    respond_to do |format|
      format.html
      format.json { render json: @genres.to_json }
    end
  end

  private

  def create_genres_if_not_exist
    GenresCreateService.new.create_if_not_exist
  end

  def search(service)
    return service.send_request(SearchService.new.build_search_by_title_url(params)) if params[:title].present?

    service.send_request(SearchService.new.build_discover_url(params))
  end

  def read_response(res)
    @results = res['results']
    @page = res['page']
    @total_pages = res['total_pages']
    @total_results = res['total_results']
  end
end
