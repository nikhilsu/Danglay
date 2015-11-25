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

  it 'should be valid if everything is valid' do
    user = build(:user)
    expect(user.valid?).to be true
  end
end