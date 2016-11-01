require 'test_helper'

class ReferenceControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(email: "hunter@test.io",
                        encrypted_password: Devise::Encryptor.digest(User, 'hunter2'))
  end

  test "create reference" do
    sign_in_as(@user)
    @reference_controller = ReferenceController.new 
    #@reference_controller.reference({title: "Test", note: "Hunter test", link: "http://cs.ucl.ac.uk", user: @user.id })
    #@reference_controller.create
    assert true
  end
end
