class SessionsController < ApplicationController

  def destroy
    delete_session
    # TODO: Move this to env-specific config files
    if Rails.env == 'staging' or Rails.env == 'production'
      redirect_to 'https://thoughtworks.okta.com'
    else
      redirect_to 'https://dev-774694.oktapreview.com'
    end
  end

  private

    def delete_session
      session.clear
    end
end
