class Loan < ApplicationRecord
  has_paper_trail only: %i[lending_date due_date return_date times_prolonged]

  belongs_to :book,   optional: false
  belongs_to :lender, optional: false

  delegate :first_name, :middle_name, :last_name, :group_name, :description, to: :lender, prefix: true
  delegate :title, :description, :sti_type, to: :book, prefix: true

  ransacker :due_today, formatter: proc { Date.today } do |parent|
    parent.table[:due_date]
  end

  def due_today?
    due_date == Date.today
  end
end
