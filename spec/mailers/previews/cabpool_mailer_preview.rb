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

# Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/cabpool_leave_notifier
  def cabpool_leave_notifier
    CabpoolMailer.cabpool_leave_notifier(User.first, User.second)
  end

# Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/admin_notifier_for_new_cabpool
  def admin_notifier_for_new_cabpool
    CabpoolMailer.admin_notifier_for_new_cabpool(User.first)
  end

# Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/admin_notifier_for_new_user
  def admin_notifier_for_new_user
    CabpoolMailer.admin_notifier_for_new_user(User.first)
  end

# Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/admin_notifier_for_invalid_cabpool
  def admin_notifier_for_invalid_cabpool
    CabpoolMailer.admin_notifier_for_invalid_cabpool(Cabpool.first)
  end

# Preview this email at http://localhost:3000/rails/mailers/cabpool_mailer/admin_notifier_for_member_leaving
  def admin_notifier_for_member_leaving
    CabpoolMailer.admin_notifier_for_member_leaving(Cabpool.first, User.first)
  end
end
