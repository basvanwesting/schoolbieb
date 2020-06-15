class Lending::ReturnsController < ApplicationController

  def new
    @lending_return = Lending::Return.new(lending_return_params)
  end

  def create
    @lending_return = Lending::Return.new(lending_return_params)

    respond_to do |format|
      if @lending_return.save
        format.html { redirect_to @lending_return.book, notice: t('action.lending.return.success', model: Book.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  private

    def lending_return_params
      if params[:lending_return].present?
        params.require(:lending_return).permit(:book_id)
      else
        {}
      end
    end
end
