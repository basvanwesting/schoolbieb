class Book::NonFiction < Book
  validates :category, presence: true
  before_save :flatten_tags

  def flatten_tags
    self.tags = tags.flatten.uniq.sort.reject(&:blank?)
  end

  module Categories
    ALL = [
      "Godsdienst",
      "Lichaam & Gezondheid",
      "Eten & Drinken",
      "Huis & Tuin",
      'Feest',
      "Hobby's",
      "Sport & Spel",
      "Beroepen",
      "Wetenschap & Techniek",
      "Computers & Gamen & Online",
      "Verkeer & Vervoer",
      "Natuur & Milieu",
      "Dieren",
      "Landen & Volken",
      "Nederland",
      "Kunst & Cultuur",
      "Theater & Film",
      "Schrijvers & Boeken",
      "Muziek",
      "Sprookjes & Volksverhalen",
      "Gedichten & Versjes",
      "Mens & Maatschappij",
    ].freeze
  end

  class << self
    def sorted_existing_tags
      pluck(Arel.sql("distinct unnest(tags)"))
    end

    def with_tag(tag)
      where("? = ANY (tags)", tag)
    end
  end
end
