class BookUseCase::BorrowsController < ApplicationController

  def new
    @book_use_case_borrow = BookUseCase::Borrow.new(book_use_case_borrow_params)
    authorize! :create, @book_use_case_borrow
  end

  def create
    @book_use_case_borrow = BookUseCase::Borrow.new(book_use_case_borrow_params)
    authorize! :create, @book_use_case_borrow

    respond_to do |format|
      if @book_use_case_borrow.save
        format.html { redirect_to @book_use_case_borrow.book, notice: t('action.book_use_case.borrow.success', model: Book.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  private

    def book_use_case_borrow_params
      if params[:book_use_case_borrow].present?
        params.require(:book_use_case_borrow).permit(:book_id, :book_description, :lender_id, :lender_description, :due_date)
      else
        {}
      end
    end
end
