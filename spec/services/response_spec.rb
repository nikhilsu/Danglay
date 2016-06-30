# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Response, type: :service do
  it 'returns a true when success method of Success class is called' do
    response = Success.new(build(:cabpool), 'Success Message')

    expect(response.success?).to be true
    expect(response.message).to eq 'Success Message'
  end

  it 'returns a false when success method of Failure class is called' do
    response = Failure.new(build(:cabpool), 'Failure Message')

    expect(response.success?).to be false
    expect(response.message).to eq 'Failure Message'
  end

  it 'raises a Not-Implemented exception when success method of Response class is invoked' do
    response = described_class.new(build(:cabpool), 'Message')

    expect { response.success? }.to raise_error(NotImplementedError)
    expect(response.message).to eq 'Message'
  end
end
