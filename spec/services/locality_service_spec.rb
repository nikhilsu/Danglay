require 'rails_helper'

RSpec.describe LocalityService , type: :service do

  it 'should get all the localities using the ids' do
    locality1 = build(:locality)
    locality2 = build(:locality, :another_locality)
    expect(Locality).to receive(:find_by_id).with(1).and_return(locality1)
    expect(Locality).to receive(:find_by_id).with(2).and_return(locality2)

    localities = LocalityService.fetch_all_localities([1, 2])

    expect(localities).to eq [locality1, locality2]
  end

  it 'should get only localities that exists' do
    locality1 = build(:locality)
    expect(Locality).to receive(:find_by_id).with(1).and_return(locality1)
    expect(Locality).to receive(:find_by_id).with(2).and_return(nil)

    localities = LocalityService.fetch_all_localities([1, 2])

    expect(localities).to eq [locality1]
  end
end