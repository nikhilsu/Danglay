require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do

    let(:request) { double('request', url: 'host.com') }

    it 'should return request url if get' do
      allow(request).to receive(:get?).and_return(true)
      expect(store_location).to eq 'host.com'
    end

    it 'should return nil if not get' do
      allow(request).to receive(:get?).and_return(false)
      expect(store_location).to eq nil
    end

    it 'should return true if user logged in' do
      session[:userid] = build_stubbed(:user).id
      expect(is_logged_in?).to eq true
      session.clear
    end

    it 'should return false if user not logged in' do
      expect(is_logged_in?).to eq false
    end
end