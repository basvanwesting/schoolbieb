class LendersController < ApplicationController
  before_action :set_lender, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, Lender
    @q = Lender.ransack(params[:q])
    @lenders = @q.result.order("last_name ASC, first_name ASC").page(params[:page]).per(100)
  end

  def stickers
    authorize! :update, Lender
    scope = Lender
    scope = scope.where("1 = 0") unless ransack_filter_present?
    @q = scope.ransack(params[:q])
    @lenders = @q.result.order("last_name ASC, first_name ASC").page(params[:page]).per(60)
  end

  def show
    authorize! :read, @lender
  end

  def new
    @lender = Lender.new
    authorize! :create, @lender
  end

  def edit
    authorize! :update, @lender
  end

  def create
    @lender = Lender.new(lender_params)
    authorize! :create, @lender

    respond_to do |format|
      if @lender.save
        format.html { redirect_to @lender, notice: t('action.create.success', model: Lender.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update, @lender
    respond_to do |format|
      if @lender.update(lender_params)
        format.html { redirect_to @lender, notice: t('action.update.success', model: Lender.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize! :destroy, @lender
    @lender.destroy
    respond_to do |format|
      format.html { redirect_to lenders_url, notice: t('action.destroy.success', model: Lender.model_name.human) }
    end
  end

  def qr
    authorize! :read, Lender
    session[:current_qr_lender_id] = @lender.id
    respond_to do |format|
      format.html { redirect_to @lender, notice: 'Redirected from QR Code of Lender' }
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
