require 'selenium-webdriver'
require 'test/unit'

module Test
  class TestReferenceCreate < Test::Unit::TestCase

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @home_url = 'http://127.0.0.1:3000/home'
      @new_reference_url = 'http://127.0.0.1:3000/references/new'
      wait = Selenium::WebDriver::Wait.new(:timeout => 5)

      @driver.navigate.to('http://127.0.0.1:3000/users/sign_in')
      wait.until {
        @driver.find_element(:name, 'commit')
      }

      email = @driver.find_element(:id, 'user_email')
      email.clear
      email.send_keys('a@hunter2.io')

      password = @driver.find_element(:id, 'user_password')
      password.clear
      password.send_keys('hunter2')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
        @driver.find_element(:class, 'alert').text
      }

      alert_text = @driver.find_element(:class, 'alert').text
      assert(alert_text.include? 'Signed in successfully.')
    end

    test '01 user can create a reference' do
      @driver.navigate.to(@new_reference_url)
      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
         @driver.find_element(:name, 'commit')
      }

      title = @driver.find_element(:id, 'reference_title')
      title.clear
      title.send_keys('Graph Theory')

      link = @driver.find_element(:id, 'reference_link')
      link.clear
      link.send_keys('https://theory.com/graph_theory')

      note = @driver.find_element(:id, 'reference_note')
      note.clear
      note.send_keys('Reference pertaining to elementary graph theory')

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

  end 
end
