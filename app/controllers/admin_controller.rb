class AdminController < ApplicationController
  before_action :require_admin!

  private

    def require_admin!
      Rails.logger.info "Current user: #{current_user.id}, #{current_user.email}"
      unless current_user.role?(Role::Admin)
        raise ActionController::RoutingError.new('Not Found')
      end
    end
end
