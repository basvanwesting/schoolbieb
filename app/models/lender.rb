class Lender < ApplicationRecord
  has_many :loans

  validates :last_name,  presence: true
  validates :group_name, presence: true
  validates :first_name, presence: true, uniqueness: { scope: %i[last_name middle_name group_name] }

  # Needs to be unique, so record can matched based on description
  def description(with_group_name: true)
    [
      [
        first_name,
        middle_name,
        last_name,
      ].select(&:present?).join(' '),
      with_group_name ? ", #{group_name}" : nil,
      " (#{formatted_id})",
    ].select(&:present?).join('')
  end

  def formal_name(with_group_name: true)
    [
      [
        "#{last_name}, #{first_name}",
        middle_name,
      ].select(&:present?).join(' '),
      with_group_name ? ", #{group_name}" : nil,
      " (#{formatted_id})",
    ].select(&:present?).join('')
  end

  def formatted_id
    id.to_s.rjust(4, '0')
  end

  class << self
    def wildcard_search(v)
      terms = v.split.map(&:upcase).map { |s| s.gsub(/[(),]/,'') }
      clause = terms.map do |term|
        [
          "lenders.first_name ilike '%#{term}%'",
          "lenders.middle_name ilike '%#{term}%'",
          "lenders.last_name ilike '%#{term}%'",
          "unaccent(lenders.first_name) ilike '%#{term}%'",
          "unaccent(lenders.middle_name) ilike '%#{term}%'",
          "unaccent(lenders.last_name) ilike '%#{term}%'",
          "lenders.group_name ilike '%#{term}%'",
          "cast(lenders.id as text) ilike '#{term.sub(/^0*/, '')}%'",
        ].join(" or ")
      end.map { |v| "(#{v})" }.join(" and ")
      where(clause).pluck(:id)
    end
  end


end
