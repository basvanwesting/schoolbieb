class Book::Fiction < Book
  belongs_to :author, optional: false
end
