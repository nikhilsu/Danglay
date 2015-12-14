require "rails_helper"

RSpec.describe CabpoolMailer, type: :mailer do
  describe "cabpool_join_request" do

    let(:mail) {
      request = build_stubbed(:request)
      @requesting_user = request.user
      @cabpool_user = build(:user, :existing_user)
      CabpoolMailer.cabpool_join_request(@cabpool_user, @requesting_user, request.approve_digest )
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
end
