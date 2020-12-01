class BookUseCase::Prolong < BookUseCase
  DEFAULT_DUE_DATE_INTERVAL = 21.days

  attr_accessor :loan, :due_date

  validates :due_date, presence: true

  validate :loan_found
  validate :book_may_prolong
  validate :due_date_is_sanitized

  delegate :sanitize_due_date, to: Loan

  def initialize(*args)
    super
    self.loan = book&.loan
    self.due_date ||= sanitize_due_date(
      [loan&.due_date, Date.today].compact.max + DEFAULT_DUE_DATE_INTERVAL
    )
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.prolong!
      loan.increment(:times_prolonged)
      loan.update(due_date: due_date)
    end
  end

  def loan_found
    return unless book.present?
    errors.add(:book_id, :loan_not_found) unless loan.present?
  end

  def due_date_is_sanitized
    return unless due_date.present?
    errors.add(:due_date, :not_sanitized) unless Loan.due_date_is_sanitized?(due_date)
  end

end
