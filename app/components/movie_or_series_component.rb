class MovieOrSeriesComponent < ViewComponent::Base
  def initialize(type:, api_key:, my_list:, genres:, obj: {})
    @title = obj['title'] || obj['name']
    @type = type
    @image_path = image_url(obj['poster_path'], api_key)
    @genres = find_genres(obj, genres, type)
    @release_date = obj['release_date']
    @vote_average = obj['vote_average']
    @vote_count = obj['vote_count']
    @description = description(obj['overview'])
    @id = obj['id']
    @in_my_list = my_list.include?(@id)
  end

  def find_genres(obj, genres, type)
    if obj['genre_ids']
      genres.select { |genre| obj['genre_ids'].include?(genre[:genre_id]) && genre[:for] == type }.pluck(:name)
    else
      obj['genres'].pluck('name')
    end
  end

  def host_image_url
    'https://image.tmdb.org/t/p/'
  end

  def image_url(path, api_key)
    "#{host_image_url}w154/#{path}?api_key=#{api_key}"
  end

  def description(text)
    return text if text.length > 0

    I18n.t('texts.no_description_provided')
  end
end
