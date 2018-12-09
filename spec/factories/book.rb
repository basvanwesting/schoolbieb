FactoryBot.define do
  factory :book do
    name { "My First Book" }
    author { Author.first || build(:author) }
  end
end
