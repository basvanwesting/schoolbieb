class Lender < ApplicationRecord
  has_many :loans

  validates :last_name,  presence: true
  validates :group_name, presence: true
  validates :first_name, presence: true, uniqueness: { scope: %i[last_name middle_name group_name] }

  # Needs to be unique, so record can matched based on description
  def description
    [
      first_name,
      middle_name,
      last_name,
      "(#{group_name})",
    ].select(&:present?).join(' ')
  end

  def formal_name
    [
      "#{last_name}, #{first_name}",
      middle_name,
      "(#{group_name})",
    ].select(&:present?).join(' ')
  end

  class << self
    def wildcard_search(v)
      terms = v.split.map(&:upcase).map { |s| s.gsub(/[()]/,'') }
      clause = terms.map do |term|
        [
          %i[lenders first_name],
          %i[lenders middle_name],
          %i[lenders last_name],
          %i[lenders group_name],
        ].map do |table, field|
          "#{table}.#{field} ilike '%#{term}%'"
        end.join(" or ")
      end.map { |v| "(#{v})" }.join(" and ")
      where(clause).pluck(:id)
    end
  end


end
