class LoansController < ApplicationController
  before_action :set_loan, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, Loan
    @q = Loan.ransack(params[:q])
    @loans = @q.result.order("due_date DESC").page(params[:page]).per(100)
  end

  def show
    authorize! :read, @loan
  end

  def edit
    authorize! :update, @loan
  end

  def update
    authorize! :update, @loan
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to @loan, notice: t('action.update.success', model: Loan.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_params
      params.require(:loan).permit(:lending_date, :due_date, :return_date, :times_prolonged)
    end
end
