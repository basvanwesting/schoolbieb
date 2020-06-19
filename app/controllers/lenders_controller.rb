class LendersController < ApplicationController
  before_action :set_lender, only: [:show, :edit, :update, :destroy]

  def index
    @q = Lender.ransack(params[:q])
    @lenders = @q.result.order("last_name ASC, first_name ASC").page(params[:page]).per(100)
  end

  def show
  end

  def new
    @lender = Lender.new
  end

  def edit
  end

  def create
    @lender = Lender.new(lender_params)

    respond_to do |format|
      if @lender.save
        format.html { redirect_to @lender, notice: t('action.create.success', model: Lender.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @lender.update(lender_params)
        format.html { redirect_to @lender, notice: t('action.update.success', model: Lender.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @lender.destroy
    respond_to do |format|
      format.html { redirect_to lenders_url, notice: t('action.destroy.success', model: Lender.model_name.human) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lender
      @lender = Lender.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lender_params
      params.require(:lender).permit(:identifier, :first_name, :middle_name, :last_name, :group_name)
    end
end
