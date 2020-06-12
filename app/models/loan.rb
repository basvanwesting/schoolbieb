class Loan < ApplicationRecord
  belongs_to :book,   optional: false
  belongs_to :lender, optional: false

  delegate :first_name, :middle_name, :last_name, :group_name, to: :lender, prefix: true
  delegate :title, :sti_type, to: :book, prefix: true
end
