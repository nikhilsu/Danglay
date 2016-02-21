class CabpoolMailer < ApplicationMailer
  include SessionsHelper
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cabpool_mailer.cabpool_join_request.subject
  #
  def cabpool_join_request(cabpool_user, cabpool, requesting_user, digest)
    @username = cabpool_user.name
    @current_user = requesting_user
    @digest = digest
    @cabpool = cabpool.id
    mail to: cabpool_user.email, subject: 'Someone wants to join your carpool!'
  end

  def cabpool_approve_request(approved_user)
    @username = approved_user.name
    mail to: approved_user.email, subject: 'Your cabpool request has been approved!'
  end

  def cabpool_reject_request(rejected_user)
    @username = rejected_user.name
    mail to: rejected_user.email, subject: 'Your cabpool request has been rejected'
  end

  def cabpool_leave_notifier(user,left_user)
    @username = user.name
    @left_user = left_user
    mail to: user.email, subject: 'Someone has left your cabpool!'
  end

  def admin_notifier_for_invalid_cabpool deleting_cabpool
    @cabpool = deleting_cabpool.id

    admins = Role.find_by_name("admin").users
    emails = []
    admins.each do |admin| emails << admin.email end
    mail to: emails , subject: "A Cabpool is inactive"
  end

  def admin_notifier_for_member_leaving cabpool, leaving_user
    @cabpool = cabpool.id
    @username = leaving_user.name

    admins = Role.find_by_name("admin").users
    emails = []
    admins.each do |admin| emails << admin.email end
    mail to: emails , subject: "A member is leaving the cabpool"
  end

  def admin_notifier_for_join_cabpool cabpool, requesting_user, digest
    @cabpool = cabpool.id
    @user = requesting_user
    @digest = digest

    admins = Role.find_by_name("admin").users
    emails = []
    admins.each do |admin| emails << admin.email end
    mail to: emails , subject: "Join Request for a cabpool"
  end
end
