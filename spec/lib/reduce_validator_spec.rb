require 'rails_helper'

RSpec.describe ReduceValidator, type: :lib do

  it 'should return if errors on an attribute does not exists' do
    model = mock_model('Model')
    model.errors.add(:name, 'message one')
    model.errors.add(:name, 'message two')
    reduce_validator = ReduceValidator.new({:attributes => { presence: true}})

    reduce_validator.validate_each(model, :attribute_without_validation_errors, 10)

    expect(model.errors[:name].size).to be 2
    expect(model.errors[:attribute_without_validation_errors].empty?).to be true
  end

  it 'should remove all error messages on an attribute except the first one if the number of errors is more than 1' do
    model = mock_model('Model')
    model.errors.add(:name, 'Validation error one')
    model.errors.add(:name, 'Validation error two')
    reduce_validator = ReduceValidator.new({:attributes => { presence: true}})

    reduce_validator.validate_each(model, :name, 'Ola')

    expect(model.errors[:name].size).to be 1
    expect(model.errors[:name]).to eq ['Validation error one']

  end

  it 'should not reduce/remove error messages on an attribute if the number of errors is not more than 1' do
    model = mock_model('Model')
    model.errors.add(:name, 'Some Validation error')
    reduce_validator = ReduceValidator.new({:attributes => { presence: true}})

    reduce_validator.validate_each(model, :name, 'Ola')

    expect(model.errors[:name].size).to be 1
  end
end
