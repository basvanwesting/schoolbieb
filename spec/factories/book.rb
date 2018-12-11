FactoryBot.define do
  factory :book do
    title { "My First Book" }
    author { Author.first || build(:author) }
  end
end
