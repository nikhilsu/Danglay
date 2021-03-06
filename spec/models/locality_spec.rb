# frozen_string_literal: true
# == Schema Information
#
# Table name: localities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Locality, type: :model do
  # TODO: Rewrite with shoulda-matchers gem so that these become one-liners
  it 'name should not be empty' do
    locality = build(:locality, :without_name)
    expect(locality.valid?).to be false
  end

  it 'name should be unique' do
    create(:locality)
    same_locality = build(:locality)
    expect(same_locality.valid?).to be false
  end

  it 'creates a valid locality' do
    locality = build(:locality)
    expect(locality.valid?).to be true
  end
end
