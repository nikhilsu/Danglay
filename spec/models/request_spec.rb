require 'rails_helper'

RSpec.describe Request, type: :model do

  it "should have a user" do
    request = build(:request, :without_user)
    expect(request.valid?).to be false
  end

  it "should have a cabpool" do
    request = build(:request, :without_cabpool)
    expect(request.valid?).to be false
  end

  it "should create a valid request" do
    request = build(:request)
    expect(request.valid?).to be true
  end
end
