class Lending::Return
  include ActiveModel::Model

  attr_accessor :book_id
  attr_accessor :book, :loan

  validates :book_id, presence: true

  validate  :book_found
  validate  :loan_found
  validate  :book_may_return

  def initialize(*args)
    super
    self.book = Book.find_by(id: book_id)
    self.loan = Loan.find_by(
      book_id:     book_id,
      return_date: nil,
    )
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.return!
      loan.update(return_date: Date.today)
    end
  end

  def book_found
    return unless book_id
    errors.add(:book_id, :not_found) unless book.present?
  end

  def loan_found
    return unless book.present?
    errors.add(:book_id, :loan_not_found) unless loan.present?
  end

  def book_may_return
    return unless book.present?
    errors.add(:book_id, :may_not_return) unless book.may_return?
  end

end
