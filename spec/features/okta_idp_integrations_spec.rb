require 'rails_helper'

RSpec.feature "OktaIdpIntegrations", type: :feature do
  # scenario 'unauthorized user tries to access root' do
  #   stub_request(:any, "localhost:3000/saml/init").
  #       to_return(:body => "abc", :status => 200,
  #                 :headers => { 'Content-Length' => 3 })
  #   response = Net::HTTP.get("localhost" , '/saml/init', 3000)
  #   #current_path.should == root_path
  #   expect(response).to eq 'abc'
  # end
end
