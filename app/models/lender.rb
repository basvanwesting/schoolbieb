class Lender < ApplicationRecord
  has_many :loans

  def full_name
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

  def to_s
    "#{full_name} (#{group_name})"
  end


end
