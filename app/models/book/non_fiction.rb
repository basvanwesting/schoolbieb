class Book::NonFiction < Book
  validates :category, presence: true
  before_save :flatten_tags

  def flatten_tags
    self.tags = tags.flatten.uniq.sort.reject(&:blank?)
  end

  module Categories
    ALL = %w[
      Temp1
      Temp2
      Temp3
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
