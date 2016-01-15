class SamlController < ApplicationController

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
      if is_admin?
        redirect_back_or(admin_url)
      else
        redirect_back_or(root_url)
      end
    else
      redirect_to(request.create(saml_settings))
    end
  end

  private

  def set_registered_uid(user_id)
    user =  User.find_by_email(user_id)
    unless user.nil?
      session[:registered_uid] = user.id
    end
  end

  def set_session response
    session[:userid] = response.nameid
    set_registered_uid(response.attributes[:Email])
    session[:FirstName] = response.attributes[:FirstName]
    session[:LastName] = response.attributes[:LastName]
    session[:Email] = response.attributes[:Email]
  end

  def saml_settings
    idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    settings = idp_metadata_parser.parse(idp_metadata[Rails.env])
    settings.assertion_consumer_service_url = "http://#{request.host}/saml/consume"
    settings.issuer = 'thedanglayfollowers'
    settings.name_identifier_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    settings
  end

  def idp_metadata
    {
      'development' => ENV['development_meta'],

      'qa' => ENV['qa_meta'],

      'test' => ENV['test_meta'],

      'staging' => ENV['staging_meta'],

      'production' => ENV['prod_meta']
    }
  end
end
