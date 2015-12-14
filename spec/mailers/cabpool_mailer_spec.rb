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
end
