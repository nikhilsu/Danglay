class CustomErrorsController < ApplicationController
  def page_not_found
    render 'not_found_error', status: 404
  end

  def server_error
    render 'internal_server_error', layout: 'layouts/error', status: 500
  end
end
