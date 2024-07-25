class PaginationComponent < ViewComponent::Base
  def initialize(current_page:, total_pages_number:, params:)
    @current_page = current_page.to_i
    @total_pages_number = total_pages_number
    @params = params.permit(:with_genres, :type, :primary_release_year, :page, :title)
    @next_page = next_page
    @previous_page = previous_page
  end

  def next_page
    @current_page + 1
  end

  def previous_page
    @current_page - 1
  end

  def next_page_path(page: @next_page)
    url_for(@params.merge(page: page))
  end

  def prev_page_path(page: @previous_page)
    url_for(@params.merge(page: page))
  end

  def first_page_path
    url_for(@params.merge(page: 1))
  end

  def first_page?(page:)
    page <= 1
  end

  def last_page?(page: @current_page)
    page >= @total_pages_number
  end
end
