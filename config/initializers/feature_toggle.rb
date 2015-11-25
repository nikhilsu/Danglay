#All toggles as per the environment should be defined here.

FEATURES = FeatureToggle.load(File.join(Rails.root, 'config', 'features.yml'))

if Rails.env.development?
  FEATURES.activate('user_feature')
end

if Rails.env.test?
  FEATURES.activate('user_feature')
end

if Rails.env.staging?
  FEATURES.activate('user_feature')
end

if Rails.env.production?
  FEATURES.deactivate('user_feature')
end