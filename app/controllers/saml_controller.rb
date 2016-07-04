# frozen_string_literal: true
class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token
  def init
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    request = OneLogin::RubySaml::Authrequest.new
    response.settings = saml_settings

    if response.is_valid?
      set_session response
      redirect_back_or(is_admin? ? admin_url : root_url)
    else
      redirect_to(request.create(saml_settings))
    end
  end

  private

  def set_session(response)
    session[:FirstName] = response.attributes[:FirstName]
    session[:LastName] = response.attributes[:LastName]
    session[:Email] = response.attributes[:Email]
  end

  def saml_settings
    idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    settings = idp_metadata_parser.parse(Rails.application.secrets[:idp_metadata])
    settings.assertion_consumer_service_url = "http://#{root_url}/saml/consume"
    settings.issuer = 'thedanglayfollowers'
    settings.name_identifier_format = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
    settings
  end
end
