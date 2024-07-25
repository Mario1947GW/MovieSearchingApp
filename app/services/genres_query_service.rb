class GenresQueryService
  def initialize; end

  def all_genres
    Genre.all
  end

  def fetch_genres(type)
    return Genre.where(for: type) if type

    all_genres
  end

  def fetch_genres_ids_and_names(type)
    Genre.where(for: type).pluck(:genre_id, :name)
  end
end
