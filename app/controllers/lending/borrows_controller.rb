class Lending::BorrowsController < ApplicationController

  def new
    @lending_borrow = Lending::Borrow.new(lending_borrow_params)
  end

  def create
    @lending_borrow = Lending::Borrow.new(lending_borrow_params)

    respond_to do |format|
      if @lending_borrow.save
        format.html { redirect_to @lending_borrow.book, notice: t('action.lending.borrow.success', model: Book.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  private

    def lending_borrow_params
      params.require(:lending_borrow).permit(:book_id, :lender_id, :due_date)
    end
end
