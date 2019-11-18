FactoryBot.define do
  factory 'book/fiction', aliases: [:book_fiction, :book] do
    title { "My First Book" }
    author { Author.first || build(:author) }
  end
end
