class Author < ApplicationRecord
  has_many :books

  #validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :first_name, uniqueness: { scope: [:last_name, :middle_name] }

  def full_name
    [
      first_name,
      middle_name,
      last_name,
    ].select(&:present?).join(' ')
  end
end
