# Preview all emails at http://localhost:3000/rails/mailers/cabpool_mailer
class CabpoolMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/cabpool_join_request
  def cabpool_join_request
    user = User.find(16)
    currentUser = User.find(3)
    CabpoolMailer.cabpool_join_request(user, currentUser, currentUser.requests.first.approve_digest)
  end

# Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/cabpool_approve_request
  def cabpool_approve_request
    CabpoolMailer.cabpool_approve_request(User.first)
  end

# Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/cabpool_reject_request
  def cabpool_reject_request
    CabpoolMailer.cabpool_reject_request(User.first)
  end

end
