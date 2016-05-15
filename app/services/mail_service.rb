class MailService

  def self.send_member_addition_email_to_cabpool_members(approver, user)
    CabpoolMailer.member_addition_to_cabpool(approver, user).deliver_now
  end

  def self.send_email_to_admin_about_invalid_cabpool(deleting_cabpool)
    if deleting_cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_invalid_cabpool(deleting_cabpool).deliver_now
    end
  end

  def self.send_email_to_admins_to_request_cabpool_creation(requesting_user, timein, timeout, remarks)
    CabpoolMailer.admin_notifier_for_new_cabpool_creation_request(requesting_user, timein, timeout, remarks).deliver_now
  end

  def self.send_email_to_rejected_user(rejected_user)
    CabpoolMailer.cabpool_reject_request(rejected_user).deliver_now
  end

  def self.send_email_to_admin_when_user_leaves(users, leaving_user)
    cabpool = users.first.cabpool
    if cabpool.cabpool_type_id == 1
      CabpoolMailer.admin_notifier_for_member_leaving(cabpool, leaving_user).deliver_now
    end
  end

  def self.send_email_to_cabpool_users_on_member_leaving(users, current_user)
    users.collect do |user|
      CabpoolMailer.cabpool_leave_notifier(user, current_user).deliver_now
    end
  end

  def self.send_email_to_approved_user(approved_user)
    CabpoolMailer.cabpool_approve_request(approved_user).deliver_now
  end

  def self.send_email_to_cabpool_members_about_cabpool_update(updated_cabpool, member_updating_cabpool)
    CabpoolMailer.member_of_a_cabpool_updated_it(updated_cabpool, member_updating_cabpool).deliver_now
  end

  def self.send_emails_to_notify_join_request(cabpool, requesting_user, digest)
    if cabpool.cabpool_type.name == 'Company provided Cab'
      CabpoolMailer.admin_notifier_for_join_cabpool(cabpool, requesting_user, digest).deliver_now
    else
      cabpool.users.collect do |user|
        CabpoolMailer.cabpool_join_request(user, cabpool, requesting_user, digest).deliver_now
      end
    end
  end

  def self.send_emails_to_cabpool_members_when_admin_creates_a_pool(cabpool)
    cabpool.users.collect do |user|
      CabpoolMailer.cabpool_is_created(user, cabpool).deliver_now
    end
  end

  def self.send_email_to_cabpool_users_about_cabpool_update_by_admin(cabpool, members_before_cabpool_update)
    members_to_be_notified = cabpool.users | members_before_cabpool_update
    members_to_be_notified.collect do |user|
      CabpoolMailer.cabpool_updated_by_admin(user, cabpool).deliver_now
    end
  end
end