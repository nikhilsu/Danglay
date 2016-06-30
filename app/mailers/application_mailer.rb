# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'danglay@thoughtworks-labs.net'
  layout 'mailer'
end
