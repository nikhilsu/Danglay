require 'rails_helper'

RSpec.describe Locality, type: :model do
  it 'name should not be empty' do
    locality = Locality.create(name: "")
    expect(locality.valid?).to be false
  end
end
