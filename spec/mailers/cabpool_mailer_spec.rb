require 'rails_helper'

RSpec.describe CabpoolMailer, type: :mailer do
  describe 'cabpool_join_request' do

    let(:mail) {
      request = build_stubbed(:request)
      @requesting_user = request.user
      @cabpool = request.cabpool
      @cabpool_user = build(:user, :existing_user)
      CabpoolMailer.cabpool_join_request(@cabpool_user, @cabpool, @requesting_user, request.approve_digest)
    }

    it 'renders the headers' do
      expect(mail.subject).to eq('Someone wants to join your carpool!')
      expect(mail.to).to eq([@cabpool_user.email])
      expect(mail.from).to eq(['danglay@thoughtworks-labs.net'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include 'has requested to join your carpool.'
    end
  end

  describe 'cabpool_approve_request' do

    let(:mail) {
      @approved_user = build(:user)
      CabpoolMailer.cabpool_approve_request(@approved_user)
    }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your cabpool request has been approved!')
      expect(mail.to).to eq([@approved_user.email])
      expect(mail.from).to eq(['danglay@thoughtworks-labs.net'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include 'has just been approved!'
    end
  end

  describe 'cabpool_reject_request' do

    let(:mail) {
      @rejected_user = build(:user)
      CabpoolMailer.cabpool_reject_request(@rejected_user)
    }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your cabpool request has been rejected')
      expect(mail.to).to eq([@rejected_user.email])
      expect(mail.from).to eq(['danglay@thoughtworks-labs.net'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include 'has been rejected.'
    end
  end

  describe 'cabpool leave notifier' do
    let(:mail) {
      @user = build(:user)
      @left_user = build(:user, :another_user)
      CabpoolMailer.cabpool_leave_notifier(@user, @left_user)
    }

    it 'should render the headers' do
      expect(mail.subject).to eq('Someone has left your cabpool!')
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(['danglay@thoughtworks-labs.net'])
    end

    it 'should render the body' do
      expect(mail.body.encoded).to include 'has left your carpool.'
    end
  end

  describe 'admin mail for inactive cabpool' do
    let(:mail) {
      @user = build(:user)
      cabpool = build(:cabpool)
      cabpool.id = 100
      @user.cabpool = cabpool
      locality = build_stubbed(:locality)
      localities = [locality, locality]
      allow(@user.cabpool).to receive(:ordered_localities).and_return(localities)
      CabpoolMailer.admin_notifier_for_invalid_cabpool(@user.cabpool)
    }

    it 'should send mail to admin about new user' do
      expect(mail.subject).to eq('A Cabpool is inactive')
      expect(mail.to).to include('sandeeph@thoughtworks.com')
    end
  end

  describe 'admin mail when a user leaves' do
    let(:mail) {
      @user = build(:user)
      cabpool = build(:cabpool)
      cabpool.id = 100
      @user.cabpool = cabpool
      locality = build_stubbed(:locality)
      localities = [locality, locality]
      allow(@user.cabpool).to receive(:ordered_localities).and_return(localities)
      CabpoolMailer.admin_notifier_for_member_leaving(@user.cabpool, @user)

    }

    it 'should send mail to admin about new user' do
      expect(mail.subject).to eq('A member is leaving the cabpool')
      expect(mail.to).to include('sandeeph@thoughtworks.com')
    end
  end

  describe 'admin mail when a user Requests a company provided cabpool' do
    let(:mail) {
      request = build_stubbed(:request)
      @user = build(:user)
      @cabpool = build(:cabpool)
      allow(@cabpool).to receive(:id).and_return(1)
      CabpoolMailer.admin_notifier_for_join_cabpool(@cabpool, @user, request.approve_digest)
    }

    it 'should send mail to admin to accept or reject the request' do
      expect(mail.subject).to eq('Join Request for a cabpool')
      expect(mail.to).to include('sandeeph@thoughtworks.com')
    end
  end
  
  describe 'admin mail when a user Requests a creation of company provided cabpool' do
    let(:mail) {
      @user = build(:user)
      @timein = Time.now
      @timeout = Time.now
      @remarks = 'some remarks'
      CabpoolMailer.admin_notifier_for_new_cabpool_creation_request(@user, @timein, @timeout, @remarks)
    }

    it 'should send mail to admin to create a request for creation of cabpool by admin' do
      expect(mail.subject).to eq('Cabpool creation request')
      expect(mail.to).to include('sandeeph@thoughtworks.com')
    end
  end

  describe 'mail to other members of a cabpool when a user accepts a new member' do

    it 'should send mail to other members of a cabpool when a user accepts a new member' do
      approving_user = build(:user)
      user = build(:user)
      cabpool = build(:cabpool)
      allow(User).to receive(:find_by).and_return(approving_user)
      allow(approving_user).to receive(:cabpool).and_return(cabpool)

      mail = CabpoolMailer.member_addition_to_cabpool(approving_user, user)

      expect(mail.subject).to eq('New member added to cabpool')
      expect(mail.body.encoded).to include 'has added'
    end

    it 'should send no mails when a user is a part of a pool with no other members in it and accepts a new member' do
      approving_user = build(:user)
      user = build(:user)
      cabpool = build(:cabpool)
      cabpool.users = [approving_user]
      allow(User).to receive(:find_by).and_return(approving_user)
      allow(approving_user).to receive(:cabpool).and_return(cabpool)

      mail = CabpoolMailer.member_addition_to_cabpool(approving_user, user)

      expect(mail.subject).to be nil
      expect(mail.body).to be_empty
    end
  end

  describe 'mail to members of a cabpool when admin creates a cabpool' do
    let (:mail) {
      user = build(:user)
      cabpool = build(:cabpool)
      allow(User).to receive(:find_by).and_return(user)
      allow(Cabpool).to receive(:find_by).and_return(cabpool)
      CabpoolMailer.cabpool_is_created(user, cabpool)
    }

    it 'should send mail to members of a cabpool when admin creates a cabpool' do
      expect(mail.subject).to eq('You have been added to a cabpool')
      expect(mail.body.encoded).to include 'new cabpool'
    end
  end

  describe 'should send mail to members of a cabpool when admin updates a cabpool' do
    let (:mail) {
      user = build(:user)
      another_user = build(:user, another_user)
      allow(User).to receive(:find_by).and_return(user)
      cabpool = build(:cabpool)
      cabpool.users = [user, another_user]
      allow(cabpool).to receive(:ordered_localities).and_return(cabpool.localities)
      CabpoolMailer.cabpool_updated_by_admin(user, cabpool)
    }

    it 'should send mail to members of a cabpool when admin updates a cabpool' do
      expect(mail.subject).to eq('Cabpool Updated by Admin')
    end
  end

  describe 'cabpool updated notifier' do
    it 'should send emails to all members of a cabpool that has been updated except the person updating it' do
      updated_cabpool = build(:cabpool)
      localities = [build(:locality)]
      allow(updated_cabpool).to receive(:ordered_localities).and_return(localities)
      user_updating_the_cabpool = build(:user)
      another_user_part_of_the_cabpool = build(:user, :another_user)
      updated_cabpool.users = [user_updating_the_cabpool, another_user_part_of_the_cabpool]

      mail = CabpoolMailer.member_of_a_cabpool_updated_it(updated_cabpool, user_updating_the_cabpool)

      expect(mail.subject).to eq('The cabpool that you are a part of has been updated')
    end

    it 'should not send any emails when the user updating the cabpool is the only user of that cabpool' do
      updated_cabpool = build(:cabpool)
      user_updating_the_cabpool = build(:user)
      updated_cabpool.users = [user_updating_the_cabpool]

      mail = CabpoolMailer.member_of_a_cabpool_updated_it(updated_cabpool, user_updating_the_cabpool)

      expect(mail.subject).to be nil
      expect(mail.body).to be_empty
    end
  end
end
