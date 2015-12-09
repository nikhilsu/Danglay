# Preview all emails at http://localhost:3000/rails/mailers/cabpool_mailer
class CabpoolMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/cabpool_join_request
  def cabpool_join_request
    CabpoolMailer.cabpool_join_request
  end

end
