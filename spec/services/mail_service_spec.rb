# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MailService, type: :service do
  it 'calls member_addition_to_cabpool once' do
    mail_object = double
    approver = build(:user)
    user = build(:user, :another_user)
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:member_addition_to_cabpool).with(approver, user).and_return(mail_object).once

    described_class.send_member_addition_email_to_cabpool_members(approver, user)
  end

  it 'calls admin_notifier_for_invalid_cabpool once if cabpool type is company provided' do
    mail_object = double
    cabpool = build(:cabpool)
    cabpool.cabpool_type = :company_provided_cab
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:admin_notifier_for_invalid_cabpool).and_return(mail_object).once

    described_class.send_email_to_admin_about_invalid_cabpool(cabpool)
  end

  it 'does not invoke admin_notifier_for_invalid_cabpool once if cabpool type is not a company provided cab' do
    cabpool = build(:cabpool, :personal_car)
    expect(CabpoolMailer).to receive(:admin_notifier_for_invalid_cabpool).exactly(0).times

    described_class.send_email_to_admin_about_invalid_cabpool(cabpool)
  end

  it 'sends email to admins requesting creation of cabpool' do
    mail_object = double
    requesting_user = build(:user)
    timein = '9:30'
    timeout = '12:30'
    remarks = 'Remarks'
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:admin_notifier_for_new_cabpool_creation_request).and_return(mail_object).once

    described_class.send_email_to_admins_to_request_cabpool_creation(requesting_user, timein, timeout, remarks)
  end

  it 'sends an email to the user whose cabpool request has been rejected' do
    mail_object = double
    rejected_user = build(:user)
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:cabpool_reject_request).and_return(mail_object).once

    described_class.send_email_to_rejected_user(rejected_user)
  end

  it 'sends an email to admin if a user leaves a cabpool and the cabpool is company provided' do
    mail_object = double
    user = build(:user)
    another_user = build(:user, :another_user)
    leaving_user = build(:user, :yet_another_user)
    users = [user, another_user]
    cabpool = build(:cabpool)
    cabpool.users = users
    cabpool.cabpool_type = :company_provided_cab
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:admin_notifier_for_member_leaving).and_return(mail_object).once

    described_class.send_email_to_admin_when_user_leaves(users, leaving_user)
  end

  it 'does not send an email to admin if a user leaves and the cabpool is not company provided' do
    mail_object = double
    user = build(:user)
    another_user = build(:user, :another_user)
    leaving_user = build(:user, :yet_another_user)
    users = [user, another_user]
    cabpool = build(:cabpool)
    cabpool.users = users
    cabpool.cabpool_type = :external_cab
    expect(CabpoolMailer).to receive(:admin_notifier_for_member_leaving).and_return(mail_object).exactly(0)

    described_class.send_email_to_admin_when_user_leaves(users, leaving_user)
  end

  it 'sends an email to all members of a cabpool on member leaving' do
    mail_object = double
    user = build(:user)
    another_user = build(:user, :another_user)
    leaving_user = build(:user, :yet_another_user)
    users = [user, another_user]
    cabpool = build(:cabpool)
    cabpool.users = users
    expect(mail_object).to receive(:deliver_now).twice
    expect(CabpoolMailer).to receive(:cabpool_leave_notifier).and_return(mail_object).twice

    described_class.send_email_to_cabpool_users_on_member_leaving(users, leaving_user)
  end

  it 'sends an email a user who\'s cabpool join request has been approved' do
    mail_object = double
    approved_user = build(:user)
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:cabpool_approve_request).and_return(mail_object)

    described_class.send_email_to_approved_user(approved_user)
  end

  it 'sends email to all members of a cabpool when it has been edited/updated' do
    mail_object = double
    user = build(:user)
    another_user = build(:user, :another_user)
    member_updating_cabpool = build(:user, :yet_another_user)
    updated_cabpool = build(:cabpool)
    updated_cabpool.users = [user, another_user, member_updating_cabpool]
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:member_of_a_cabpool_updated_it).and_return(mail_object)

    described_class.send_email_to_cabpool_members_about_cabpool_update(updated_cabpool, member_updating_cabpool)
  end

  it 'sends email to all members of a cabpool when a join request has been raised for a non company provided pool' do
    mail_object = double
    digest = double
    user = build(:user)
    another_user = build(:user, :another_user)
    requesting_user = build(:user, :yet_another_user)
    cabpool = build(:cabpool, :personal_car)
    cabpool.users = [user, another_user]
    expect(mail_object).to receive(:deliver_now).twice
    expect(CabpoolMailer).to receive(:cabpool_join_request).with(user, cabpool, requesting_user, digest).and_return(mail_object)
    expect(CabpoolMailer).to receive(:cabpool_join_request).with(another_user, cabpool, requesting_user, digest).and_return(mail_object)

    described_class.send_emails_to_notify_join_request(cabpool, requesting_user, digest)
  end

  it 'sends email to all admins when a join request has been raised for a company provided pool' do
    mail_object = double
    digest = double
    user = build(:user)
    another_user = build(:user, :another_user)
    requesting_user = build(:user, :yet_another_user)
    cabpool = build(:cabpool)
    cabpool.cabpool_type = :company_provided_cab
    cabpool.users = [user, another_user]
    expect(mail_object).to receive(:deliver_now)
    expect(CabpoolMailer).to receive(:admin_notifier_for_join_cabpool).with(cabpool, requesting_user, digest).and_return(mail_object)

    described_class.send_emails_to_notify_join_request(cabpool, requesting_user, digest)
  end

  it 'sends email to members when admin creates a pool' do
    mail_object = double
    user = build(:user)
    another_user = build(:user, :another_user)
    cabpool = build(:cabpool)
    cabpool.cabpool_type = :company_provided_cab
    cabpool.users = [user, another_user]
    expect(mail_object).to receive(:deliver_now).twice
    expect(CabpoolMailer).to receive(:cabpool_is_created).with(user, cabpool).and_return(mail_object)
    expect(CabpoolMailer).to receive(:cabpool_is_created).with(another_user, cabpool).and_return(mail_object)

    described_class.send_emails_to_cabpool_members_when_admin_creates_a_pool(cabpool)
  end

  it 'sends email to previously existing, current and newly added members of a cabpool when admin updates a cabpool' do
    mail_object = double
    current_user = build(:user)
    previously_existing_user = build(:user, :another_user)
    newly_added_user = build(:user, :yet_another_user)
    members_before_cabpool_update = [current_user, previously_existing_user]
    cabpool = build(:cabpool)
    cabpool.users = [current_user, newly_added_user]
    expect(mail_object).to receive(:deliver_now).thrice
    expect(CabpoolMailer).to receive(:cabpool_updated_by_admin).with(current_user, cabpool).and_return(mail_object)
    expect(CabpoolMailer).to receive(:cabpool_updated_by_admin).with(previously_existing_user, cabpool).and_return(mail_object)
    expect(CabpoolMailer).to receive(:cabpool_updated_by_admin).with(newly_added_user, cabpool).and_return(mail_object)

    described_class.send_email_to_cabpool_users_about_cabpool_update_by_admin(cabpool, members_before_cabpool_update)
  end
end
