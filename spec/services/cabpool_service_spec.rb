# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CabpoolService, type: :service do
  it 'persists the cabpool and return a success response when cabpool is valid and save is successful' do
    cabpool_to_persist = build(:cabpool)
    cabpools_associations = { localities: [], users: [] }

    expect(cabpool_to_persist).to receive(:valid_including_associations?).with(cabpools_associations).and_return(true)
    expect(cabpool_to_persist).to receive(:add_associations_in_order).with(cabpools_associations).once
    expect(cabpool_to_persist).to receive(:save).and_return(true)
    response = described_class.persist(cabpool_to_persist, cabpools_associations)

    expect(response.success?).to be true
    expect(response.message).to eq 'Operation Successful'
  end

  it 'does not persist the cabpool and return a failure response when cabpool is not valid' do
    cabpool_to_persist = build(:cabpool)
    cabpools_associations = { localities: [], users: [] }

    expect(cabpool_to_persist).to receive(:valid_including_associations?).with(cabpools_associations).and_return(false)
    response = described_class.persist(cabpool_to_persist, cabpools_associations)

    expect(response.success?).to be false
    expect(response.message).to eq 'Cannot persist cabpool because of the following validation errors'
  end

  it 'does not persist the cabpool and return a failure response when cabpool is valid but save fails' do
    cabpool_to_persist = build(:cabpool)
    cabpools_associations = { localities: [], users: [] }

    expect(cabpool_to_persist).to receive(:valid_including_associations?).with(cabpools_associations).and_return(true)
    expect(cabpool_to_persist).to receive(:add_associations_in_order).with(cabpools_associations).once
    expect(cabpool_to_persist).to receive(:save).and_return(false)
    response = described_class.persist(cabpool_to_persist, cabpools_associations)

    expect(response.success?).to be false
    expect(response.message).to eq 'Cannot persist cabpool because of the following validation errors'
  end

  it 'fetches all cabpool with a success reponse when the locality_ids are nil' do
    cabpools = [build(:cabpool)]
    expect(Cabpool).to receive(:all).and_return(cabpools)

    response = described_class.fetch_all_cabpools_of_a_particular_locality nil

    expect(response.success?).to be true
    expect(response.data).to eq cabpools
  end

  it 'fetches all cabpool and return a failure response when the locality_ids are empty' do
    cabpools = [build(:cabpool)]
    locality_hash = { key: '' }
    expect(Cabpool).to receive(:all).and_return(cabpools)

    response = described_class.fetch_all_cabpools_of_a_particular_locality locality_hash

    expect(response.success?).to be false
    expect(response.data).to eq cabpools
    expect(response.message).to eq 'Select a locality'
  end

  it 'fetches all cabpool belonging to a locality passed with a success response' do
    locality = build(:locality)
    cabpools = [build(:cabpool)]
    locality.cabpools = cabpools
    locality_hash = { key: '1' }

    expect(Locality).to receive(:find_by_id).with('1').and_return(locality).once
    response = described_class.fetch_all_cabpools_of_a_particular_locality locality_hash

    expect(response.success?).to be true
    expect(response.data).to eq cabpools
  end
end
