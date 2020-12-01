class VacationsController < ApplicationController
  before_action :set_vacation, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, Vacation
    @q = Vacation.ransack(params[:q])
    @vacations = @q.result.order("start_date ASC").page(params[:page]).per(100)
  end

  def show
    authorize! :read, @vacation
  end

  def new
    @vacation = Vacation.new
    authorize! :create, @vacation
  end

  def edit
    authorize! :update, @vacation
  end

  def create
    @vacation = Vacation.new(vacation_params)
    authorize! :create, @vacation

    respond_to do |format|
      if @vacation.save
        format.html { redirect_to @vacation, notice: t('action.create.success', model: Vacation.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update, @vacation
    respond_to do |format|
      if @vacation.update(vacation_params)
        format.html { redirect_to @vacation, notice: t('action.update.success', model: Vacation.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize! :destroy, @vacation
    @vacation.destroy
    respond_to do |format|
      format.html { redirect_to vacations_url, notice: t('action.destroy.success', model: Vacation.model_name.human) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vacation
      @vacation = Vacation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vacation_params
      params.require(:vacation).permit(:start_date, :end_date, :due_date)
    end
end
