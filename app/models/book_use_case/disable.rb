class BookUseCase::Disable < BookUseCase
  validate  :book_may_disable

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.disable!
    end
  end

  def book_may_disable
    return unless book.present?
    errors.add(:book_id, :may_not_disable) unless book.may_disable?
  end

end
