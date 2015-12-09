class CabpoolMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cabpool_mailer.cabpool_join_request.subject
  #
  def cabpool_join_request
    @greeting = "Hi"

    mail to: "to@example.org", subject: 'Request to join your Cab Pool'
  end
end
