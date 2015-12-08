#All toggles as per the environment should be defined here.

FEATURES = FeatureToggle.load(File.join(Rails.root, 'config', 'features.yml'))

if Rails.env.development?
  FEATURES.activate('user_feature', 'okta_feature', 'create_cabpool_feature')
end

if Rails.env.test?
  FEATURES.activate('user_feature', 'okta_feature', 'create_cabpool_feature')
end

if Rails.env.staging?
  FEATURES.activate('user_feature', 'okta_feature')
  FEATURES.deactivate('create_cabpool_feature')

end

if Rails.env.production?
  FEATURES.activate('user_feature', 'okta_feature', 'create_cabpool_feature')
end