require 'rails_helper'

RSpec.describe User, type: :model do
  # TODO: Rewrite with shoulda-matchers gem so that these become one-liners
  it 'name should not be empty' do
    user = build(:user, :without_name)
    expect(user.valid?).to be false
  end

  it 'locality should be there' do
    user = build(:user)
    locality = build(:locality)
    user.locality = locality
    expect(user.locality.name).to eq(locality.name)
  end

  it 'emp_id should not be empty' do
    user = build(:user, :without_emp_id)
    expect(user.valid?).to be false
  end

  it '2 users cannot have the same employee ID' do
    user_with_an_emp_id = build(:user)
    user_with_an_emp_id.save
    user_with_the_same_emp_id = build(:user)
    expect(user_with_the_same_emp_id.valid?).to be false
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

  it "can have multiple requests" do
    user = build(:user)
    r1 = build(:request)
    r2 = build(:request)
    user.requests = [r1]
    expect(user.valid?).to be true
    user.requests = [r1, r2]
    expect(user.valid?).to be true
  end

  it "emp_id cannot be re-written" do
    user = build(:user)
    expect{
      user.update_attribute(:emp_id, 19211)
    }.to raise_error(ActiveRecord::ActiveRecordError, 'emp_id is marked as readonly')
  end

  it 'should have default role as user' do
    user = create(:user)
    expect(user.role.name).to eq "user"
  end

  it 'should have role as admin if user with admin role is created' do
    user = create(:user, :with_admin_role)
    expect(user.role.name).to eq "admin"
  end

  it 'emp_id cannot be alphabetic' do
    user = build(:user, :with_alphabetic_emp_id)
    expect(user.valid?).to be false
  end

  it 'emp_id cannot be more than 10 digits' do
    user = build(:user, :with_large_emp_id)
    expect(user.valid?).to be false
  end

  it 'emp_id cannot be less than 4 digits' do
    user = build(:user, :with_small_emp_id)
    expect(user.valid?).to be false
  end

  it 'emp_id can have 5 digits' do
    user = build(:user)
    expect(user.valid?).to be true
  end

end
