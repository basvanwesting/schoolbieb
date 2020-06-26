class BookUseCase::Enable
  include ActiveModel::Model

  attr_accessor :book_id
  attr_accessor :book
  attr_accessor :book_description

  validates :book_id, presence: true

  validate  :book_found
  validate  :book_may_enable

  def initialize(*args)
    super
    self.book               = Book.find_by(id: book_id)
    self.book_description ||= book&.description
  end

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.enable!
    end
  end

  def book_found
    return unless book_id
    errors.add(:book_id, :not_found) unless book.present?
  end

  def book_may_enable
    return unless book.present?
    errors.add(:book_id, :may_not_enable) unless book.may_enable?
  end

end
