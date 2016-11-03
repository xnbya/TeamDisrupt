require 'selenium-webdriver'
require 'test/unit'

module Test
  class TestReferenceCreate < Test::Unit::TestCase

    def input_data(finder, finder_value, value)
      elem = @driver.find_element(finder, finder_value)
      elem.clear
      elem.send_keys(value)
    end

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @home_url = 'http://127.0.0.1:3000/home'
      @new_reference_url = 'http://127.0.0.1:3000/references/new'
      wait = Selenium::WebDriver::Wait.new(:timeout => 5)

      @driver.navigate.to('http://127.0.0.1:3000/users/sign_in')
      wait.until {
        @driver.find_element(:name, 'commit')
      }

      input_data(:id, 'user_email', 'a@hunter2.io')
      input_data(:id, 'user_password', 'hunter2')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
        @driver.find_element(:class, 'alert').text
      }

      alert_text = @driver.find_element(:class, 'alert').text
      assert(alert_text.include? 'Signed in successfully.')
    end

    test 'user can create a reference' do
      @driver.navigate.to(@new_reference_url)
      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
         @driver.find_element(:name, 'commit')
      }

      input_data(:id, 'reference_title', 'Graph Theory')
      input_data(:id, 'reference_link', 'https://theory.com/graph_theory')
      input_data(:id, 'reference_note', 'Reference pertaining to elementary graph theory')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
        @driver.find_elements(:tag_name, 'h3')
      }

      created = false

      @driver.find_elements(:tag_name, 'h3').each do |elem|
        if elem.text.include? 'Graph Theory'
          created = true
          break
        end
      end

      assert(created)
    end

    test 'user cant create a reference with empty link' do
      @driver.navigate.to(@new_reference_url)
      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
         @driver.find_element(:name, 'commit')
      }

      input_data(:id, 'reference_title', 'Sorting Things')
      input_data(:id, 'reference_link', '')
      input_data(:id, 'reference_note', 'Reference pertaining to sorting things')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
        @driver.find_elements(:tag_name, 'h3')
      }

      created = false

      @driver.find_elements(:tag_name, 'h3').each do |elem|
        if elem.text.include? 'Sorting Things'
          created = true
          break
        end
      end

      assert !(created)
    end
  end
end
