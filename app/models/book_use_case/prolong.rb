class BookUseCase::Prolong < BookUseCase
  DEFAULT_DUE_DATE_INTERVAL = 7.days

  attr_accessor :loan

  validate :loan_found
  validate :book_may_prolong

  def initialize(*args)
    super
    self.loan = Loan.find_by(
      book_id:     book_id,
      return_date: nil,
    )
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.prolong!
      loan.due_date += DEFAULT_DUE_DATE_INTERVAL
      loan.save!
    end
  end

  def loan_found
    return unless book.present?
    errors.add(:book_id, :loan_not_found) unless loan.present?
  end

end
