class BookUseCase::Borrow < BookUseCase
  DEFAULT_DUE_DATE_INTERVAL = 21.days

  attr_accessor :lender_id, :lender, :lender_description
  attr_accessor :lending_date, :due_date
  attr_accessor :loan

  validates :lender_id,    presence: true
  validates :lending_date, presence: true
  validates :due_date,     presence: true

  validate :lender_found
  validate :book_may_borrow
  validate :due_date_is_sanitized

  delegate :sanitize_due_date, to: Loan

  def initialize(*args)
    super
    self.lender               = Lender.find_by(id: lender_id)
    self.lender_description ||= lender&.description
    self.lending_date         = Date.today
    self.due_date           ||= sanitize_due_date(lending_date + DEFAULT_DUE_DATE_INTERVAL)
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      self.loan = Loan.create!(
        book_id:      book_id,
        lender_id:    lender_id,
        lending_date: lending_date,
        due_date:     due_date,
      )
      book.borrow!
    end
  end

  def lender_found
    return unless lender_id
    errors.add(:lender_id, :not_found) unless lender.present?
  end

  def due_date_is_sanitized
    return unless due_date.present?
    errors.add(:due_date, :not_sanitized) unless Loan.due_date_is_sanitized?(due_date)
  end

end
