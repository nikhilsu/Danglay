class SamlController < ApplicationController

  def init
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    request = OneLogin::RubySaml::Authrequest.new
    response.settings = saml_settings

    # We validate the SAML Response and check if the user already exists in the system
    if response.is_valid?
      # authorize_success, log the user
      session[:userid] = response.nameid
      set_registered_uid(response.attributes[:Email])
      session[:FirstName] = response.attributes[:FirstName]
      session[:LastName] = response.attributes[:LastName]
      session[:Email] = response.attributes[:Email]
      redirect_back_or(root_url)
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
      'development' => '<?xml version="1.0" encoding="UTF-8"?><md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" entityID="http://www.okta.com/exk5fn90zik3RdpS30h7"><md:IDPSSODescriptor WantAuthnRequestsSigned="true" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"><md:KeyDescriptor use="signing"><ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><ds:X509Data><ds:X509Certificate>MIIDpDCCAoygAwIBAgIGAVE5/l75MA0GCSqGSIb3DQEBBQUAMIGSMQswCQYDVQQGEwJVUzETMBEG
      A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
      MBIGA1UECwwLU1NPUHJvdmlkZXIxEzARBgNVBAMMCmRldi03NzQ2OTQxHDAaBgkqhkiG9w0BCQEW
      DWluZm9Ab2t0YS5jb20wHhcNMTUxMTI0MTQ1NDUwWhcNMjUxMTI0MTQ1NTUwWjCBkjELMAkGA1UE
      BhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDTALBgNV
      BAoMBE9rdGExFDASBgNVBAsMC1NTT1Byb3ZpZGVyMRMwEQYDVQQDDApkZXYtNzc0Njk0MRwwGgYJ
      KoZIhvcNAQkBFg1pbmZvQG9rdGEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
      8qowgy2O0W0W6WVPEqTxeTCK/unYLu46WYIh/mNKyHEpzTCng1eu0IE1pViqhVi7uhJ43CSbQXFa
      TA0cjeIf1I/6hUj+eYdNySLYhDKa+m/VW3kj4NMpCC4POTYOZVMkC9dM8V9ysjpC5WlIW8avuhqZ
      XVlVbF3Ibj+isNqzUu443LWh75Z/wQ88l+zb5kh6cm1zDpw0PZeC89n2hmqwFJUoMwPtHKPyzAFB
      dbm2R5hFcV6NLkThE5Q5F/HIt7qlZw7l/IRSQHykeoIvVGAfRsrTnBVo+UUL4WGgYGVwoNb3qLFs
      q49+BNyFtRhHoc/Jqzqug3PoY6vbjoCqvEsniQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQDm+Xz3
      HLiUwJH4tSEdzxafrH0uwwljptqyLiNIzFl2CirHErOeryvdegnu9cUtvadL7VWSBtHo0bmDAGwX
      ki2oqTUrXDtp0N2vCJLQ19MCtPGDMMufbRhW3e/uoKELmJPPPuvAnQ9h50naWRK4d6E80ReYvrXa
      NkxRGyv336gej4oe8wuCcawf0oN+YUZoUDg9Q57+j6Md4OWGOQ/d328b8AKlrkzJj26zyoAZFLkj
      gyzbUG4DFys0jf5HAp6pVVAceKGwR+DDdXFU+vboHduCGoaUhAMDUQGmyD0JRgkqmikaF+si/3AB
      /6+omCKrcNI3Zzdex8fokRdP17H21QLj</ds:X509Certificate></ds:X509Data></ds:KeyInfo></md:KeyDescriptor><md:SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/slo/saml"/><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/sso/saml"/><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/sso/saml"/></md:IDPSSODescriptor></md:EntityDescriptor>',

      'qa' => '<?xml version="1.0" encoding="UTF-8"?><md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" entityID="http://www.okta.com/exk5fvjra2CUKZq1f0h7"><md:IDPSSODescriptor WantAuthnRequestsSigned="true" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"><md:KeyDescriptor use="signing"><ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><ds:X509Data><ds:X509Certificate>MIIDpDCCAoygAwIBAgIGAVE5/l75MA0GCSqGSIb3DQEBBQUAMIGSMQswCQYDVQQGEwJVUzETMBEG
A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
MBIGA1UECwwLU1NPUHJvdmlkZXIxEzARBgNVBAMMCmRldi03NzQ2OTQxHDAaBgkqhkiG9w0BCQEW
DWluZm9Ab2t0YS5jb20wHhcNMTUxMTI0MTQ1NDUwWhcNMjUxMTI0MTQ1NTUwWjCBkjELMAkGA1UE
BhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDTALBgNV
BAoMBE9rdGExFDASBgNVBAsMC1NTT1Byb3ZpZGVyMRMwEQYDVQQDDApkZXYtNzc0Njk0MRwwGgYJ
KoZIhvcNAQkBFg1pbmZvQG9rdGEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
8qowgy2O0W0W6WVPEqTxeTCK/unYLu46WYIh/mNKyHEpzTCng1eu0IE1pViqhVi7uhJ43CSbQXFa
TA0cjeIf1I/6hUj+eYdNySLYhDKa+m/VW3kj4NMpCC4POTYOZVMkC9dM8V9ysjpC5WlIW8avuhqZ
XVlVbF3Ibj+isNqzUu443LWh75Z/wQ88l+zb5kh6cm1zDpw0PZeC89n2hmqwFJUoMwPtHKPyzAFB
dbm2R5hFcV6NLkThE5Q5F/HIt7qlZw7l/IRSQHykeoIvVGAfRsrTnBVo+UUL4WGgYGVwoNb3qLFs
q49+BNyFtRhHoc/Jqzqug3PoY6vbjoCqvEsniQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQDm+Xz3
HLiUwJH4tSEdzxafrH0uwwljptqyLiNIzFl2CirHErOeryvdegnu9cUtvadL7VWSBtHo0bmDAGwX
ki2oqTUrXDtp0N2vCJLQ19MCtPGDMMufbRhW3e/uoKELmJPPPuvAnQ9h50naWRK4d6E80ReYvrXa
NkxRGyv336gej4oe8wuCcawf0oN+YUZoUDg9Q57+j6Md4OWGOQ/d328b8AKlrkzJj26zyoAZFLkj
gyzbUG4DFys0jf5HAp6pVVAceKGwR+DDdXFU+vboHduCGoaUhAMDUQGmyD0JRgkqmikaF+si/3AB
/6+omCKrcNI3Zzdex8fokRdP17H21QLj</ds:X509Certificate></ds:X509Data></ds:KeyInfo></md:KeyDescriptor><md:SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_stagingdanglay_1/exk5fvjra2CUKZq1f0h7/slo/saml"/><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_stagingdanglay_1/exk5fvjra2CUKZq1f0h7/sso/saml"/><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_stagingdanglay_1/exk5fvjra2CUKZq1f0h7/sso/saml"/></md:IDPSSODescriptor></md:EntityDescriptor>',

      'test' => '<?xml version="1.0" encoding="UTF-8"?><md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" entityID="http://www.okta.com/exk5fn90zik3RdpS30h7"><md:IDPSSODescriptor WantAuthnRequestsSigned="true" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"><md:KeyDescriptor use="signing"><ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><ds:X509Data><ds:X509Certificate>MIIDpDCCAoygAwIBAgIGAVE5/l75MA0GCSqGSIb3DQEBBQUAMIGSMQswCQYDVQQGEwJVUzETMBEG
      A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
      MBIGA1UECwwLU1NPUHJvdmlkZXIxEzARBgNVBAMMCmRldi03NzQ2OTQxHDAaBgkqhkiG9w0BCQEW
      DWluZm9Ab2t0YS5jb20wHhcNMTUxMTI0MTQ1NDUwWhcNMjUxMTI0MTQ1NTUwWjCBkjELMAkGA1UE
      BhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDTALBgNV
      BAoMBE9rdGExFDASBgNVBAsMC1NTT1Byb3ZpZGVyMRMwEQYDVQQDDApkZXYtNzc0Njk0MRwwGgYJ
      KoZIhvcNAQkBFg1pbmZvQG9rdGEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
      8qowgy2O0W0W6WVPEqTxeTCK/unYLu46WYIh/mNKyHEpzTCng1eu0IE1pViqhVi7uhJ43CSbQXFa
      TA0cjeIf1I/6hUj+eYdNySLYhDKa+m/VW3kj4NMpCC4POTYOZVMkC9dM8V9ysjpC5WlIW8avuhqZ
      XVlVbF3Ibj+isNqzUu443LWh75Z/wQ88l+zb5kh6cm1zDpw0PZeC89n2hmqwFJUoMwPtHKPyzAFB
      dbm2R5hFcV6NLkThE5Q5F/HIt7qlZw7l/IRSQHykeoIvVGAfRsrTnBVo+UUL4WGgYGVwoNb3qLFs
      q49+BNyFtRhHoc/Jqzqug3PoY6vbjoCqvEsniQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQDm+Xz3
      HLiUwJH4tSEdzxafrH0uwwljptqyLiNIzFl2CirHErOeryvdegnu9cUtvadL7VWSBtHo0bmDAGwX
      ki2oqTUrXDtp0N2vCJLQ19MCtPGDMMufbRhW3e/uoKELmJPPPuvAnQ9h50naWRK4d6E80ReYvrXa
      NkxRGyv336gej4oe8wuCcawf0oN+YUZoUDg9Q57+j6Md4OWGOQ/d328b8AKlrkzJj26zyoAZFLkj
      gyzbUG4DFys0jf5HAp6pVVAceKGwR+DDdXFU+vboHduCGoaUhAMDUQGmyD0JRgkqmikaF+si/3AB
      /6+omCKrcNI3Zzdex8fokRdP17H21QLj</ds:X509Certificate></ds:X509Data></ds:KeyInfo></md:KeyDescriptor><md:SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/slo/saml"/><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/sso/saml"/><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_railsoktatest_1/exk5fn90zik3RdpS30h7/sso/saml"/></md:IDPSSODescriptor></md:EntityDescriptor>',

      'staging' => '<?xml version="1.0" encoding="UTF-8"?><md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" entityID="http://www.okta.com/exk5h48wbe56CxRDE0h7"><md:IDPSSODescriptor WantAuthnRequestsSigned="true" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"><md:KeyDescriptor use="signing"><ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><ds:X509Data><ds:X509Certificate>MIIDpDCCAoygAwIBAgIGAVEzgPhwMA0GCSqGSIb3DQEBBQUAMIGSMQswCQYDVQQGEwJVUzETMBEG
A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
MBIGA1UECwwLU1NPUHJvdmlkZXIxEzARBgNVBAMMCmRldi04NDYxMDExHDAaBgkqhkiG9w0BCQEW
DWluZm9Ab2t0YS5jb20wHhcNMTUxMTIzMDg0MDA4WhcNMjUxMTIzMDg0MTA4WjCBkjELMAkGA1UE
BhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDTALBgNV
BAoMBE9rdGExFDASBgNVBAsMC1NTT1Byb3ZpZGVyMRMwEQYDVQQDDApkZXYtODQ2MTAxMRwwGgYJ
KoZIhvcNAQkBFg1pbmZvQG9rdGEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
hax/2rMWAUgLDUASgjGqRwZhxj83KhwHVaALs3HvKBKBaidJOXAIjn99NU2Yt20R24uDsBsPQj2Q
xA6FkpjWIOmvih8rIa/se1kkYbRlSSa7+A55AAvgiW4pRBOxOhP8wxu+2z7ziYX1LoEDsSr+dYMz
tt0KmteOS7qQezJTNyj+Qjv10FPLxiPTHlcB/FoQend8Yiw7e8cP4dNzRoZD1YfUdbLD+C+UvQzj
uG6VIpbO5mI+IuPoQh8vKdGSSvy4vu8EsJLVr3UyTC8eHJ7n7ROkan1XVYdkCg6vo5pyVZRcPaCS
uSGWrypY+2ROF5YmsVZdXWptrs3PQwN5Ipnb8wIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQBKJ4EC
GFPxAmKz+5RuxFvpuhWtP+mp0nZ4Qzk3ng6XdtETwlEejvmf+qjvI91oCGas1lI/e33GEyyxtAiv
8xG2awX5SCzIfnf6pJD3o3hdDZB4xAJ/WwaapHAPa4miy9RyVzP8NxgGoCntEd+FFDvy6+OPSPqJ
Ln1+9s3Nr3pA5UTI8fvO1ozG2fDWlUDwicpNSGuGd15DgCjmwGF4xU+4hg2pMBDWAe8cV5+9wYVS
Ejy8fNv0yAeqZELtF7wTEHtuzobeoZ3jU/Qf2KfSEcbGfkOX6ZyyOwf2hpPqoWiMR8OLn+JKYm2K
ACKnoYeC/VN0GcF7l8X+H4uof4Z9WOWD</ds:X509Certificate></ds:X509Data></ds:KeyInfo></md:KeyDescriptor><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-846101.oktapreview.com/app/thoughtworksdev846101_stagingdanglay_1/exk5h48wbe56CxRDE0h7/sso/saml"/><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://dev-846101.oktapreview.com/app/thoughtworksdev846101_stagingdanglay_1/exk5h48wbe56CxRDE0h7/sso/saml"/></md:IDPSSODescriptor></md:EntityDescriptor>',

      'production' => '<?xml version="1.0" encoding="UTF-8"?><md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" entityID="http://www.okta.com/exk5fgemhmh7kaalr0h7"><md:IDPSSODescriptor WantAuthnRequestsSigned="true" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"><md:KeyDescriptor use="signing"><ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><ds:X509Data><ds:X509Certificate>MIIDpDCCAoygAwIBAgIGAVE5/l75MA0GCSqGSIb3DQEBBQUAMIGSMQswCQYDVQQGEwJVUzETMBEG
      A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
      MBIGA1UECwwLU1NPUHJvdmlkZXIxEzARBgNVBAMMCmRldi03NzQ2OTQxHDAaBgkqhkiG9w0BCQEW
      DWluZm9Ab2t0YS5jb20wHhcNMTUxMTI0MTQ1NDUwWhcNMjUxMTI0MTQ1NTUwWjCBkjELMAkGA1UE
      BhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDTALBgNV
      BAoMBE9rdGExFDASBgNVBAsMC1NTT1Byb3ZpZGVyMRMwEQYDVQQDDApkZXYtNzc0Njk0MRwwGgYJ
      KoZIhvcNAQkBFg1pbmZvQG9rdGEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
      8qowgy2O0W0W6WVPEqTxeTCK/unYLu46WYIh/mNKyHEpzTCng1eu0IE1pViqhVi7uhJ43CSbQXFa
      TA0cjeIf1I/6hUj+eYdNySLYhDKa+m/VW3kj4NMpCC4POTYOZVMkC9dM8V9ysjpC5WlIW8avuhqZ
      XVlVbF3Ibj+isNqzUu443LWh75Z/wQ88l+zb5kh6cm1zDpw0PZeC89n2hmqwFJUoMwPtHKPyzAFB
      dbm2R5hFcV6NLkThE5Q5F/HIt7qlZw7l/IRSQHykeoIvVGAfRsrTnBVo+UUL4WGgYGVwoNb3qLFs
      q49+BNyFtRhHoc/Jqzqug3PoY6vbjoCqvEsniQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQDm+Xz3
      HLiUwJH4tSEdzxafrH0uwwljptqyLiNIzFl2CirHErOeryvdegnu9cUtvadL7VWSBtHo0bmDAGwX
      ki2oqTUrXDtp0N2vCJLQ19MCtPGDMMufbRhW3e/uoKELmJPPPuvAnQ9h50naWRK4d6E80ReYvrXa
      NkxRGyv336gej4oe8wuCcawf0oN+YUZoUDg9Q57+j6Md4OWGOQ/d328b8AKlrkzJj26zyoAZFLkj
      gyzbUG4DFys0jf5HAp6pVVAceKGwR+DDdXFU+vboHduCGoaUhAMDUQGmyD0JRgkqmikaF+si/3AB
      /6+omCKrcNI3Zzdex8fokRdP17H21QLj</ds:X509Certificate></ds:X509Data></ds:KeyInfo></md:KeyDescriptor><md:SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_blahrails_1/exk5fgemhmh7kaalr0h7/slo/saml"/><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat><md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_blahrails_1/exk5fgemhmh7kaalr0h7/sso/saml"/><md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://dev-774694.oktapreview.com/app/thoughtworksdev774694_blahrails_1/exk5fgemhmh7kaalr0h7/sso/saml"/></md:IDPSSODescriptor></md:EntityDescriptor>'
    }
  end
end
