class Loan < ApplicationRecord
  belongs_to :book,   optional: false
  belongs_to :lender, optional: false

  delegate :first_name, :middle_name, :last_name, :group_name, :description, to: :lender, prefix: true
  delegate :title, :description, :sti_type, to: :book, prefix: true

  #class << self
    #def returned
      #where.not(return_date: nil)
    #end

    #def borrowed
      #where(return_date: nil)
    #end

    #def belated(date = Date.today)
      #where("due_date >= ?", date)
    #end

    #def due_today(date = Date.today)
      #where("due_date = ?", date)
    #end
  #end
end
