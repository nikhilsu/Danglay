class CabpoolMailer < ApplicationMailer
  include SessionsHelper
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cabpool_mailer.cabpool_join_request.subject
  #
  def cabpool_join_request(user, current_user, digest)
    @username = user.name
    @current_user = current_user
    @digest = digest
    mail to: user.email, subject: 'Someone wants to join your carpool!'
  end

  def cabpool_approve_request(user)
    mail to: ''
  end
end
