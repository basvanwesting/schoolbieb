class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def test_exception_notifier
    raise 'This is a test. This is only a test.'
  end
end
