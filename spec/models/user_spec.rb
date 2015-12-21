require 'rails_helper'

RSpec.describe User, type: :model do
  it 'name should not be empty' do
    user = build(:user, :without_name)
    expect(user.valid?).to be false
  end

  it 'locality should be there' do
    user = build(:user)
    locality = build(:locality)
    expect(user.locality.name).to eq(locality.name)
  end

  it 'emp_id should not be empty' do
    user = build(:user, :without_emp_id)
    expect(user.valid?).to be false
  end

  it 'email should not be empty' do
    user = build(:user, :without_email)
    expect(user.valid?).to be false
  end

  it 'address should not be empty' do
    user = build(:user, :without_address)
    expect(user.valid?).to be false
  end

  it 'locality should not be empty' do
    user = build(:user, :without_locality)
    expect(user.valid?).to be false
  end

  it 'phone_no should not be empty' do
    user = build(:user, :without_phone_no)
    expect(user.valid?).to be false
  end

  it 'phone_no should not be more than 25 characters long' do
    user = build(:user, :greater_than_25_phone_no)
    expect(user.valid?).to be false
  end

  it 'phone_no should not be have invalid characters' do
    user = build(:user, :invalid_chars_phone_no)
    expect(user.valid?).to be false
  end

  it 'should be valid if everything is valid' do
    user = build(:user)
    expect(user.valid?).to be true
  end

  it "should have only one request" do
    user = build(:user)
    r1 = build(:request)
    r2 = build(:request)
    user.requests = [r1]
    expect(user.valid?).to be true
    user.requests = [r1, r2]
    expect(user.valid?).to be false
  end
end