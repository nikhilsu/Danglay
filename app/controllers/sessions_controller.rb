class SessionsController < ApplicationController

  def destroy
    delete_session
    redirect_to 'https://dev-774694.oktapreview.com'
  end

  private

    def delete_session
      session.delete(:userid)
    end
end
