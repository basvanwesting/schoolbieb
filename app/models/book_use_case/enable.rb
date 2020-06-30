class BookUseCase::Enable < BookUseCase
  validate :book_may_enable

  def save
    return unless valid?
    ActiveRecord::Base.transaction do
      book.enable!
    end
  end

end
