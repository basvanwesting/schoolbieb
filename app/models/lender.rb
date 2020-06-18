class Lender < ApplicationRecord
  has_many :loans

  def full_name
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

  def to_s
    full_name
  end

  class << self
    def wildcard_search(v)
      terms = v.split.map(&:upcase)
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
