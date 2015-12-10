require "rails_helper"

RSpec.describe CabpoolMailer, type: :mailer do
  describe "cabpool_join_request" do
    let(:mail) { CabpoolMailer.cabpool_join_request(build_stubbed(:user), build_stubbed(:user))}

    it "renders the headers" do
      expect(mail.subject).to eq('Someone wants to join your carpool!')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['danglay@thoughtworks.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include "has requested to join your carpool."
    end
  end
end
