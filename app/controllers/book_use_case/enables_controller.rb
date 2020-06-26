class BookUseCase::EnablesController < ApplicationController

  def new
    @book_use_case_enable = BookUseCase::Enable.new(book_use_case_enable_params)
    authorize! :create, @book_use_case_enable
  end

  def create
    @book_use_case_enable = BookUseCase::Enable.new(book_use_case_enable_params)
    authorize! :create, @book_use_case_enable

    respond_to do |format|
      if @book_use_case_enable.save
        format.html { redirect_to @book_use_case_enable.book, notice: t('action.book_use_case.enable.success', model: Book.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  private

    def book_use_case_enable_params
      if params[:book_use_case_enable].present?
        params.require(:book_use_case_enable).permit(:book_id, :book_description)
      else
        {}
      end
    end
end
