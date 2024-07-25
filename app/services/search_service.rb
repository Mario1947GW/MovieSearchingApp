class SearchService
  def initialize
    @host_url = 'https://api.themoviedb.org/3/'
  end

  def build_discover_url(params)
    base_url = "#{@host_url}discover/#{params[:type]}"
    query_params = {
      api_key: ENV.fetch('API_KEY', ''),
      page: params[:page],
      primary_release_year: params[:primary_release_year],
      with_genres: params[:with_genres],
      with_cast: cast_url(params[:with_cast]),
      'vote_average.gte' => params['vote_average.gte']
    }.compact
    uri = URI(base_url)
    uri.query = URI.encode_www_form(query_params)
    uri.to_s
  end

  def build_search_by_title_url(params)
    base_url = "#{@host_url}search/multi"
    query_params = {
      api_key: ENV.fetch('API_KEY'),
      page: params[:page],
      query: params[:title]
    }.compact
    uri = URI(base_url)
    uri.query = URI.encode_www_form(query_params)
    uri.to_s
  end

  def build_person_url(person)
    base_url = "#{@host_url}search/person?query=#{person}&api_key=#{ENV.fetch('API_KEY')}&"
    uri = URI(base_url)
    uri.to_s
  end

  def cast_url(params)
    return unless params

    names = params.split(',')
    new_params = params
    names.each_with_index do |name, index|
      new_params.sub!(names[index],
                      HttpService.new.send_request(build_person_url(name))['results']&.first&.[]('id').to_s)
    end
    new_params
  end
end
