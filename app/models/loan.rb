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

  class << self
    def sanitize_due_date(due_date)
      due_date = due_date.to_date
      due_date = sanitize_due_date_by_vacation(due_date)
      due_date = sanitize_due_date_by_weekend(due_date)
    rescue
      nil
    end

    def sanitize_due_date_by_vacation(due_date)
      vacation_match = Vacation.
        where("start_date <= ?", due_date).
        where("end_date >= ?", due_date).
        first

      vacation_match ?  vacation_match.due_date : due_date
    end

    def sanitize_due_date_by_weekend(due_date)
      case due_date.cwday
      when 6
        due_date + 2
      when 7,0
        due_date + 1
      else
        due_date
      end
    end
  end
end
