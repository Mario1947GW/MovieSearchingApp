class GenresCreateService
  def initialize
    @host_url = 'https://api.themoviedb.org/3/'
  end

  def create_if_not_exist
    return if Genre.where(for: 'movie').count.positive? && Genre.where(for: 'tv').count.positive?

    %w[movie tv].each { |genre| create_genres(genre) }
  end

  def create_genres(type)
    res = send_request("#{@host_url}genre/#{type}/list?api_key=#{ENV.fetch('API_KEY')}")
    genres = JSON(res.read_body)['genres']
    genres&.each { |genre| Genre.create(for: type, genre_id: genre['id'].to_i, name: genre['name']) }
  end
end
