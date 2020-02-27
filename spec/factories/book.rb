FactoryBot.define do
  factory 'book/fiction', aliases: [:book_fiction, :book] do
    title { "My First Fiction Book" }
    author { Author.first || build(:author) }
  end
  factory 'book/non_fiction', aliases: [:book_non_fiction] do
    title { "My First Non-Fiction Book" }
    category { Book::NonFiction::Categories::ALL.first }
  end
end
