class BookUseCase::ProlongsController < ApplicationController

  def new
    @book_use_case_prolong = BookUseCase::Prolong.new(book_use_case_prolong_params)
    authorize! :create, @book_use_case_prolong
  end

  def create
    @book_use_case_prolong = BookUseCase::Prolong.new(book_use_case_prolong_params)
    authorize! :create, @book_use_case_prolong

    respond_to do |format|
      if @book_use_case_prolong.save
        format.html { redirect_to @book_use_case_prolong.book, notice: t('action.book_use_case.prolong.success', model: Book.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  private

    def book_use_case_prolong_params
      if params[:book_use_case_prolong].present?
        params.require(:book_use_case_prolong).permit(:book_id, :book_description, :due_date)
      else
        {}
      end
    end
end
