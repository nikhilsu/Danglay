# frozen_string_literal: true
class SessionsController < ApplicationController
  def destroy
    delete_session
    # TODO: Move this to env-specific config files
    redirect_to Rails.env.staging? || Rails.env.production? ? 'https://thoughtworks.okta.com' : 'https://dev-774694.oktapreview.com'
  end

  private

  def delete_session
    session.clear
  end
end
