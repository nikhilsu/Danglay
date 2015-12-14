# Preview all emails at http://localhost:3000/rails/mailers/cabpool_mailer
class CabpoolMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/cabpool_join_request
  def cabpool_join_request
    user = User.find(16)
    currentUser = User.find(3)
    CabpoolMailer.cabpool_join_request(user, currentUser, currentUser.requests.first.approve_digest)
  end

end
