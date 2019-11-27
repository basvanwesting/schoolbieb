class Book::NonFiction < Book
  validates :category, presence: true

  module Categories
    All = %w[
      Temp1
      Temp2
      Temp3
    ]
  end
end
