require "rails_helper"

RSpec.describe CabpoolMailer, type: :mailer do
  describe "cabpool_join_request" do
    let(:mail) { CabpoolMailer.cabpool_join_request }

    it "renders the headers" do
      expect(mail.subject).to eq('Request to join your Cab Pool')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
