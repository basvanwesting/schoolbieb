class BookUseCase::Enable < BookUseCase
  validate  :book_may_enable

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.enable!
    end
  end

  def book_may_enable
    return unless book.present?
    errors.add(:book_id, :may_not_enable) unless book.may_enable?
  end

end
