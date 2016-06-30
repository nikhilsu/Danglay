# frozen_string_literal: true
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    # TODO: Need to turn this on later since FactoryGirl is to be used with the intent that the generated object tree is fully valid
    # FactoryGirl.lint
  end
end
