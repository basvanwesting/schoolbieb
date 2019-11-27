class Book::NonFiction < Book
  validates :category, presence: true
  before_save :flatten_tags

  def flatten_tags
    self.tags = self.tags.flatten.uniq.sort.reject(&:blank?)
  end

  module Categories
    All = %w[
      Temp1
      Temp2
      Temp3
    ]
  end

  class << self
    def sorted_existing_tags
      pluck("distinct unnest(tags)")
    end

    def with_tag(tag)
      where("? = ANY (tags)", tag)
    end
  end
end
