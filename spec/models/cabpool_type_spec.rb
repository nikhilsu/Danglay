require 'rails_helper'

RSpec.describe CabpoolType, type: :model do
  it 'name should not be empty' do
    cabpool_type = build(:cabpool_type, :without_name)
    expect(cabpool_type.valid?).to be false
  end

  it 'name should be unique' do
    create(:cabpool_type)
    same_cabpool_type = build(:cabpool_type)
    expect(same_cabpool_type.valid?).to be false
  end

  it 'should create a valid cabpool_type' do
    cabpool_type = build(:cabpool_type)
    expect(cabpool_type.valid?).to be true
  end
end
