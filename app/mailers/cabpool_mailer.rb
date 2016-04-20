class CabpoolMailer < ApplicationMailer
  include SessionsHelper
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.cabpool_mailer.cabpool_join_request.subject
  #
  def cabpool_join_request(cabpool_user, cabpool, requesting_user, digest)
    @user = cabpool_user
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

  def admin_notifier_for_new_cabpool_creation_request requesting_user, timein, timeout, remarks
    @requesting_user  = requesting_user
    @timein = timein
    @timeout = timeout
    if(remarks == nil)
      @remarks = ""
    else
      @remarks = remarks
    end

    admins = Role.find_by_name("admin").users
    emails = []
    admins.each do |admin| emails << admin.email end
    mail to: emails , subject: "Cabpool creation request" 
  end

  def member_addition_to_cabpool approving_user, added_user
    @approving_user = approving_user.name
    @user = added_user.name
    @address = added_user.address
    
    emails =[]
    approving_user.cabpool.users.each do |user| emails << user.email if user != approving_user and user != added_user end
    mail to: emails , subject: "New member added to cabpool" if !emails.empty?
  end

  def cabpool_is_created user, cabpool
    @cabpool = cabpool
    @user = user
    mail to: user.email , subject: "You have been added to a cabpool"
  end

  def cabpool_updated_by_admin(user, members_needing_update_email)
    @user = user.name
    @members = members_needing_update_email

    mail to: user.email, subject: "Members of your cabpool have been updated"
  end
end
