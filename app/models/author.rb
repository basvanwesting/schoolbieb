class Author < ApplicationRecord
  has_many :books

  #validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :first_name, uniqueness: { scope: %i[last_name middle_name] }

  # Needs to be unique, so record can matched based on description
  def description
    [
      first_name,
      middle_name,
      last_name,
    ].select(&:present?).join(' ')
  end

  def formal_name
    [
      "#{last_name}, #{first_name}",
      middle_name,
    ].select(&:present?).join(' ')
  end

  def abbr_last_name
    last_name[0..2]
  end

  class << self
    def wildcard_search(v)
      terms = v.split.map(&:upcase)
      clause = terms.map do |term|
        [
          "unaccent(authors.first_name) ilike '%#{term}%'",
          "unaccent(authors.middle_name) ilike '%#{term}%'",
          "unaccent(authors.last_name) ilike '%#{term}%'",
          "authors.first_name ilike '%#{term}%'",
          "authors.middle_name ilike '%#{term}%'",
          "authors.last_name ilike '%#{term}%'",
        ].join(" or ")
      end.map { |v| "(#{v})" }.join(" and ")
      where(clause).pluck(:id)
    end
  end
end
