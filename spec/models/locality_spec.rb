require 'rails_helper'

RSpec.describe Locality, type: :model do
    it "should add locality" do
      Locality.create!(:name => "Indira Nagar")
      expect(Locality.first.name).to eq("Indira Nagar")
    end
end
