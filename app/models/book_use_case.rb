class BookUseCase
  include ActiveModel::Model

  attr_accessor :book_id, :book, :book_description
  validates :book_id, presence: true
  validate  :book_found

  def initialize(*args)
    super
    self.book               = Book.find_by(id: book_id)
    self.book_description ||= book&.description
  end

  def book_found
    return unless book_id
    errors.add(:book_id, :not_found) unless book.present?
  end

  def book_may_borrow
    return unless book.present?
    errors.add(:book_id, :may_not_borrow) unless book.may_borrow?
  end

  def book_may_return
    return unless book.present?
    errors.add(:book_id, :may_not_return) unless book.may_return?
  end

  def book_may_prolong
    return unless book.present?
    errors.add(:book_id, :may_not_prolong) unless book.may_prolong?
  end

  def book_may_enable
    return unless book.present?
    errors.add(:book_id, :may_not_enable) unless book.may_enable?
  end

  def book_may_disable
    return unless book.present?
    errors.add(:book_id, :may_not_disable) unless book.may_disable?
  end


end
