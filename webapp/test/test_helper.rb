ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # Signs in with the user passed to it
  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email,
                                              encrypted_password: Devise::Encryptor.digest(User, 'hunter2') } }
    #follow_redirect!
  end

end
