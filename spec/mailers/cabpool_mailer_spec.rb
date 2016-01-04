require "rails_helper"

RSpec.describe CabpoolMailer, type: :mailer do
  describe "cabpool_join_request" do

    let(:mail) {
      request = build_stubbed(:request)
      @requesting_user = request.user
      @cabpool_user = build(:user, :existing_user)
      CabpoolMailer.cabpool_join_request(@cabpool_user, @requesting_user, request.approve_digest)
    }

    it "renders the headers" do
      expect(mail.subject).to eq('Someone wants to join your carpool!')
      expect(mail.to).to eq([@cabpool_user.email])
      expect(mail.from).to eq(['danglay@thoughtworks.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include "has requested to join your carpool."
    end
  end

  describe "cabpool_approve_request" do

    let(:mail) {
      @approved_user = build(:user)
      CabpoolMailer.cabpool_approve_request(@approved_user)
    }

    it "renders the headers" do
      expect(mail.subject).to eq('Your cabpool request has been approved!')
      expect(mail.to).to eq([@approved_user.email])
      expect(mail.from).to eq(['danglay@thoughtworks.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include "has just been approved!"
    end
  end

  describe "cabpool_reject_request" do

    let(:mail) {
      @rejected_user = build(:user)
      CabpoolMailer.cabpool_reject_request(@rejected_user)
    }

    it "renders the headers" do
      expect(mail.subject).to eq('Your cabpool request has been rejected')
      expect(mail.to).to eq([@rejected_user.email])
      expect(mail.from).to eq(['danglay@thoughtworks.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include "has been rejected."
    end
  end

  describe "cabpool leave notifier" do
    let(:mail) {
      @user = build(:user)
      @left_user = build(:user, :another_user)
      CabpoolMailer.cabpool_leave_notifier(@user, @left_user)
    }

    it 'should render the headers' do
      expect(mail.subject).to eq('Someone has left your cabpool!')
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(['danglay@thoughtworks.com'])
    end

    it 'should render the body' do
      expect(mail.body.encoded).to include "has left your carpool."
    end
  end

  describe "admin mail notifier" do
    let(:mail) {
      @user = build(:user)
      @user.cabpool = build(:cabpool)
      locality = build_stubbed(:locality)
      localities = [locality, locality]
      allow(@user.cabpool).to receive(:ordered_localities).and_return(localities)
      CabpoolMailer.admin_notifier_for_new_cabpool(@user)
    }

    it 'should send mail to admin when new cabpool is created' do
      expect(mail.subject).to eq('A new cabpool is created!')
      expect(mail.to).to include("sandeeph@thoughtworks.com")
    end

  end

  describe "admin mail for new member" do
    let(:mail) {
      @user = build(:user)
      @user.cabpool = build(:cabpool)
      locality = build_stubbed(:locality)
      localities = [locality, locality]
      allow(@user.cabpool).to receive(:ordered_localities).and_return(localities)
      CabpoolMailer.admin_notifier_for_new_user(@user)
    }

    it 'should send mail to admin about new user' do
      expect(mail.subject).to eq('A new member has joined a cabpool')
      expect(mail.to).to include("sandeeph@thoughtworks.com")
    end
  end

    describe "admin mail for inactive cabpool" do
      let(:mail) {
        @user = build(:user)
        @user.cabpool = build(:cabpool)
        locality = build_stubbed(:locality)
        localities = [locality, locality]
        allow(@user.cabpool).to receive(:ordered_localities).and_return(localities)
        CabpoolMailer.admin_notifier_for_invalid_cabpool(@user.cabpool)

      }

      it 'should send mail to admin about new user' do
        expect(mail.subject).to eq("A Cabpool is inactive")
        expect(mail.to).to include("sandeeph@thoughtworks.com")
      end
  end
end
