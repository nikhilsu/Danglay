require 'rails_helper'

RSpec.describe CabpoolPersister, type: :service do

  it 'should persist the cabpool and return a success response when cabpool is valid and save is successful' do
    cabpool_to_persist = build(:cabpool)
    cabpools_associations = {localities: [], users: []}

    expect(cabpool_to_persist).to receive(:valid_including_associations?).with(cabpools_associations).and_return(true)
    expect(cabpool_to_persist).to receive(:add_associations_in_order).with(cabpools_associations).once
    expect(cabpool_to_persist).to receive(:save).and_return(true)
    response = CabpoolPersister.new(cabpool_to_persist, cabpools_associations).persist

    expect(response.success?).to be true
    expect(response.message).to eq 'Operation Successful'
    end

  it 'should not persist the cabpool and return a failure response when cabpool is not valid' do
    cabpool_to_persist = build(:cabpool)
    cabpools_associations = {localities: [], users: []}

    expect(cabpool_to_persist).to receive(:valid_including_associations?).with(cabpools_associations).and_return(false)
    response = CabpoolPersister.new(cabpool_to_persist, cabpools_associations).persist

    expect(response.success?).to be false
    expect(response.message).to eq 'Cannot persist cabpool because of the following validation errors'
  end

  it 'should not persist the cabpool and return a failure response when cabpool is valid but save fails' do
    cabpool_to_persist = build(:cabpool)
    cabpools_associations = {localities: [], users: []}

    expect(cabpool_to_persist).to receive(:valid_including_associations?).with(cabpools_associations).and_return(true)
    expect(cabpool_to_persist).to receive(:add_associations_in_order).with(cabpools_associations).once
    expect(cabpool_to_persist).to receive(:save).and_return(false)
    response = CabpoolPersister.new(cabpool_to_persist, cabpools_associations).persist

    expect(response.success?).to be false
    expect(response.message).to eq 'Cannot persist cabpool because of the following validation errors'
  end
end