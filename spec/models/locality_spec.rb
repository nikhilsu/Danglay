require 'rails_helper'

RSpec.describe Locality, type: :model do
  it 'name should not be empty' do
    locality = build(:locality, :without_name)
    expect(locality.valid?).to be false
  end

  it 'should create a valid locality' do
    locality = build(:locality)
    expect(locality.valid?).to be true
  end
end
