class BookUseCase
  include ActiveModel::Model

  attr_accessor :book_id
  attr_accessor :book
  attr_accessor :book_description

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

end
