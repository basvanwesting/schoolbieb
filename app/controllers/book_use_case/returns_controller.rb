class BookUseCase::ReturnsController < ApplicationController

  def new
    @book_use_case_return = BookUseCase::Return.new(book_use_case_return_params)
    authorize! :create, @book_use_case_return
  end

  def create
    @book_use_case_return = BookUseCase::Return.new(book_use_case_return_params)
    authorize! :create, @book_use_case_return

    respond_to do |format|
      if @book_use_case_return.save
        format.html { redirect_to @book_use_case_return.book, notice: t('action.book_use_case.return.success', model: Book.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  private

    def book_use_case_return_params
      if params[:book_use_case_return].present?
        params.require(:book_use_case_return).permit(:book_id, :book_description)
      else
        {}
      end
    end
end
