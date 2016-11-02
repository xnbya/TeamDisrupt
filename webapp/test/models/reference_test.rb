require 'test_helper'

class ReferenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "hostname with proto is valid url" do
    assert Reference.valid_url("http://example.com")
  end

  test "https proto is valid in url" do
    assert Reference.valid_url("https://example.com")
  end

  test "subdomain is valid in url" do
    assert Reference.valid_url("http://sub.example.com")
  end

  test "www is valid in url" do
    assert Reference.valid_url("http://www.example.com")
  end

  test "hostname on its own is not valid url" do
    assert_not Reference.valid_url("example.com")
  end

  test "url with new tld is valid" do
    assert Reference.valid_url("http://example.engineer")
  end

  test "url with root path is valid" do
    assert Reference.valid_url("http://example.com/")
  end

  test "url with nonroot path is valid" do
    assert Reference.valid_url("http://example.com/test")
  end

  test "url with no tld is not valid" do
    assert_not Reference.valid_url("http://example")
  end

  test "url with non existent tld is not valid" do
    assert_not Reference.valid_url("http://example.hunter2")
  end

end
