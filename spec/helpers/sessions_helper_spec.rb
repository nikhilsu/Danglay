# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:request) { double('request', url: 'host.com', fullpath: '/saml/init') }

  it 'returns request url if get' do
    allow(request).to receive(:get?).and_return(true)
    expect(store_location).to eq 'host.com'
  end

  it 'returns request url if get' do
    allow(request).to receive(:get?).and_return(true)
    allow(request).to receive(:fullpath).and_return('/')
    store_location
    expect(session[:forward_url]).to be nil
  end

  it 'deletes the forward_url in the session if not get' do
    session[:forward_url]
    allow(request).to receive(:get?).and_return(false)
    store_location
  end

  it 'returns nil and destroy forward url if not get' do
    allow(request).to receive(:get?).and_return(false)
    session[:forward_url] = 'anything'
    store_location
    expect(session[:forward_url]).to eq nil
  end

  it 'returns true if user logged in' do
    session[:Email] = build_stubbed(:user).email
    expect(is_logged_in?).to eq true
    session.clear
  end

  it 'returns false if user not logged in' do
    expect(is_logged_in?).to eq false
  end

  it 'returns the current user when current user is called' do
    user = build_stubbed(:user, :existing_user)
    expect(current_user).to eq nil
    session[:Email] = user.email
    expect(current_user.email).to eq user.email
  end

  it 'returns true if the current user is an admin' do
    user = build_stubbed(:user)
    names = user.name.split(' ')
    session[:FirstName] = names[0]
    session[:LastName] = names[1]
    session[:Email] = user.email
    role = build_stubbed(:role, :admin_role)
    user.role = role
    allow(User).to receive(:find_by_email).and_return(user)

    expect(is_admin?).to be true
  end
end
