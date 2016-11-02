require 'test_helper'

class ReferencesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "hostname with proto is valid url" do
    assert Reference.valid_url("http://example.com")
  end

  test "hostname on its own is not valid url" do
    assert_not Reference.valid_url("example.com")
  end

  test "url with root path is valid" do
    assert Reference.valid_url("http://example.com/")
  end

  test "url with nonroot path is valid" do
    assert Reference.valid_url("http://example.com/test")
  end
end
