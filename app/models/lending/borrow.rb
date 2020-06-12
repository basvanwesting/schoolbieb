class Lending::Borrow
  include ActiveModel::Model

  DEFAULT_DUE_DATE_INTERVAL = 21.days

  attr_accessor :lender, :book, :loan
  attr_accessor :lending_date, :due_date

  validates :lender,       presence: true
  validates :book,         presence: true
  validates :lending_date, presence: true
  validates :due_date,     presence: true
  validate  :book_may_borrow

  def initialize(*args)
    super
    self.lending_date = Date.today
    self.due_date ||= lending_date + DEFAULT_DUE_DATE_INTERVAL
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      Loan.create!(
        book:         book,
        lender:       lender,
        lending_date: lending_date,
        due_date:     due_date,
      )
      book.borrow!
    end
  end

  def book_may_borrow
    return unless book
    errors.add(:book, :may_not_borrow) unless book.may_borrow?
  end

end
