class BookUseCase::Return < BookUseCase

  attr_accessor :loan

  validate :loan_found
  validate :book_may_return

  def initialize(*args)
    super
    self.loan = book&.loan
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.return!
      loan.update(return_date: Date.today)
    end
  end

  def loan_found
    return unless book.present?
    errors.add(:book_id, :loan_not_found) unless loan.present?
  end

end
