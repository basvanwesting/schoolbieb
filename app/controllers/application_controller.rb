class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :store_or_reset_params_q, only: :index

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, alert: exception.message }
    end
  end

  helper_method :ransack_filter_present?

  def test_exception_notifier
    raise 'This is a test. This is only a test.'
  end

  private

  def ransack_filter_present?
    params[:q].present? && !params[:reset_q].present?
  end

  def store_or_reset_params_q
    session_key = "#{controller_path}_q"
    session[session_key] = nil if params[:reset_q].present?
    params[:q] = session[session_key] if params[:q].blank?
    current_query = (params[:q] || {}).select{|k,v | v.present? }
    session[session_key] = current_query if params[:q].present?
  end

end
