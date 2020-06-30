class BookUseCase::Disable < BookUseCase
  validate :book_may_disable

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.disable!
    end
  end

end
