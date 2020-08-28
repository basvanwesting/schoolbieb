class BookUseCase::Belate < BookUseCase
  attr_accessor :loan

  validate :loan_found
  validate :book_may_belate

  def initialize(*args)
    super
    self.loan = book&.loan
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.belate!
    end
  end

  def loan_found
    return unless book.present?
    errors.add(:book_id, :loan_not_found) unless loan.present?
  end

end
