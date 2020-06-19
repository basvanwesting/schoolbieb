class CurrentUsersController < ApplicationController

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if current_user.update(user_params)
        sign_in(current_user, bypass: true)
        format.html { redirect_to current_user_path, notice: t('action.update.success', model: User.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:password)
    end
end
