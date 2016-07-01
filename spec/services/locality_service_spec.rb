# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LocalityService, type: :service do
  it 'gets all the localities using the ids' do
    locality1 = build(:locality)
    locality2 = build(:locality, :another_locality)
    mock_localities = double('mock localities')
    expect(Locality).to receive(:where).with(id: [1, 2]).and_return(mock_localities)
    expect(mock_localities).to receive(:all).and_return([locality1, locality2])

    localities = described_class.fetch_all_localities([1, 2])

    expect(localities).to eq [locality1, locality2]
  end

  it 'gets only localities that exists' do
    locality1 = build(:locality)
    mock_localities = double('mock localities')
    expect(Locality).to receive(:where).with(id: [1, 2]).and_return(mock_localities)
    expect(mock_localities).to receive(:all).and_return([locality1])

    localities = described_class.fetch_all_localities([1, 2])

    expect(localities).to eq [locality1]
  end
end
