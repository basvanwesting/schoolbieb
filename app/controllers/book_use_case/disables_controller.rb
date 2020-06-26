class BookUseCase::DisablesController < ApplicationController

  def new
    @book_use_case_disable = BookUseCase::Disable.new(book_use_case_disable_params)
    authorize! :create, @book_use_case_disable
  end

  def create
    @book_use_case_disable = BookUseCase::Disable.new(book_use_case_disable_params)
    authorize! :create, @book_use_case_disable

    respond_to do |format|
      if @book_use_case_disable.save
        format.html { redirect_to @book_use_case_disable.book, notice: t('action.book_use_case.disable.success', model: Book.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  private

    def book_use_case_disable_params
      if params[:book_use_case_disable].present?
        params.require(:book_use_case_disable).permit(:book_id, :book_description)
      else
        {}
      end
    end
end
