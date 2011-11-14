class Song
  attr_reader :name, :artist, :genre, :subgenre, :tags
  
  def initialize(name, artist, genre, subgenre, tags)
    @name, @artist, @tags = name, artist, tags
    @genre, @subgenre = genre, subgenre
  end
  
  def matches?(criteria)
    criteria.all? do |type, value|
      case type
        when :name then name == value
        when :artist then artist == value
        when :filter then value.(self)
        when :tags then match_tags?(Array(value))
      end
    end
  end
  
  def match_tags?(tags)
    tags.all? do |tag|
      if tag.end_with?("!") 
        not @tags.include?(tag.chop)
      else
        @tags.include?(tag)
      end
    end
  end  

end

class Collection
  def initialize(songs_as_string, artist_tags)
    @songs = parse_all_songs(songs_as_string, artist_tags)
  end
  
  def parse_all_songs(songs_as_string, artist_tags)
    songs = []
    songs_as_string.lines {|s| songs.push(parse_single_song(s, artist_tags))}
    songs
  end

  def parse_single_song(song_as_string, artist_tags)
    attributes = song_as_string.split('.')
    name = attributes[0].strip
    artist = attributes[1].strip
    genre = attributes[2].split(',')[0].strip
    subgenre = attributes[2].split(',').fetch(1,'').strip
    tags = create_tags(attributes,artist_tags,genre,subgenre,artist)
    Song.new(name, artist, genre, subgenre, tags)
  end
    
  def create_tags(attributes,artist_tags,genre,subgenre,artist)
    tags = attributes.fetch(3, '').split(',').map{|attr| attr.strip}
    tags += artist_tags.fetch(artist, [])
    tags += [genre, subgenre].compact.map(&:downcase)
  end

  def find(criteria)
    @songs.select { |song| song.matches?(criteria) }
  end
end