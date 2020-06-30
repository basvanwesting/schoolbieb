class BookUseCase::Borrow
  include ActiveModel::Model

  DEFAULT_DUE_DATE_INTERVAL = 21.days

  attr_accessor :lender_id, :book_id
  attr_accessor :lending_date, :due_date

  attr_accessor :lender, :book, :loan
  attr_accessor :book_description, :lender_description

  validates :lender_id,    presence: true
  validates :book_id,      presence: true
  validates :lending_date, presence: true
  validates :due_date,     presence: true

  validate  :book_found
  validate  :lender_found
  validate  :book_may_borrow

  def initialize(*args)
    super
    self.book                 = Book.find_by(id: book_id)
    self.book_description   ||= book&.description
    self.lender               = Lender.find_by(id: lender_id)
    self.lender_description ||= lender&.description
    self.lending_date         = Date.today
    self.due_date           ||= lending_date + DEFAULT_DUE_DATE_INTERVAL
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

  def book_found
    return unless book_id
    errors.add(:book_id, :not_found) unless book.present?
  end

  def lender_found
    return unless lender_id
    errors.add(:lender_id, :not_found) unless lender.present?
  end

  def book_may_borrow
    return unless book.present?
    errors.add(:book_id, :may_not_borrow) unless book.may_borrow?
  end

end
