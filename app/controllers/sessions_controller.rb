class SessionsController < ApplicationController

  def destroy
    delete_session
    debugger
    if Rails.env != 'staging'
    redirect_to 'https://dev-774694.oktapreview.com'
    else
      redirect_to 'https://dev-846101.oktapreview.com'
    end
  end

  private

    def delete_session
      session.clear
    end
end
