require 'selenium-webdriver'
require 'test/unit'

module Test
  class TestHomePage < Test::Unit::TestCase

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @url_signup = "http://127.0.0.1:3000/users/sign_up"
      @url_home = "http://127.0.0.1:3000/home"

      #Time for new email account
      Time::DATE_FORMATS[:type] = "%y%m%d%H%M"
      @start_time = Time.now
    end

    def teardown
      @driver.quit
    end

    def test_sign_up
      3.downto(1) do |email_num|
      	3.downto(1) do |pw_num|
      		3.downto(1) do |pwc_num|

      		  #Open
      			@driver.navigate.to @url_signup
            assert_equal('Webapp', @driver.title)

            #Waiting
      			wait = Selenium::WebDriver::Wait.new(:timeout => 600) # seconds
      			begin
      			  element = wait.until { @driver.find_element(:id => "user_name") }
      			ensure

      			end

      		#Setting
      			#name
      			name = @driver.find_element(:id, 'user_name')
      			name.send_keys "abc"
      			#email
      			email = @driver.find_element(:id, 'user_email')
      			email.clear
      			if email_num == 1 then
      		 		email.send_keys @start_time.to_s(:type) +  "@zzz.com"  #New email
      			elsif email_num == 2 then
      				email.send_keys "abc@zzz.com"	 	#It has already been taken
      		 	elsif email_num == 3 then
      				email.send_keys ""	 				#Null
      		 	end
      			#pw
      			pw = @driver.find_element(:id, 'user_password')
      			pw.clear
      			if pw_num == 1 then
      				pw.send_keys "123456"
      			elsif pw_num == 2 then
      				pw.send_keys "123"
      			elsif pw_num == 3 then
      				pw.send_keys ""
      			end
      			#confirm
      			pwc = @driver.find_element(:id, 'user_password_confirmation')
      			pwc.clear
      			if pwc_num == 1 then
      				pwc.send_keys "123456"
      			elsif pwc_num == 2 then
      				pwc.send_keys "123"
      			elsif pwc_num == 3 then
      				pwc.send_keys ""
      			end

        		#Click
      			sign = @driver.find_element(:name, 'commit')
      			sign.click

        		#Waiting
      			#Correct Case
      			if email_num == 1 and pw_num == 1 and pwc_num == 1 then
      				wait = Selenium::WebDriver::Wait.new(:timeout => 600) # seconds
      				begin
      				  element = wait.until { @driver.find_element(:xpath, "//a[contains(@href, '/references/create')]")}
      				ensure
      				end
      			#Wrong Case
      			else
      				wait = Selenium::WebDriver::Wait.new(:timeout => 600) # seconds
      				begin
      				  element = wait.until { @driver.find_element(:id => "error_explanation") }
      				ensure
      				end
      			end

      		#Check
      			#Correct Case
      			if email_num == 1 and pw_num == 1 and pwc_num == 1 then
              assert true
      			#Wrong Case
      			else
      				error_list = @driver.find_element(:id, 'error_explanation')
      				items = error_list.find_elements(:tag_name, 'li')
      				items.each do |item|
      					if item.text.encode('UTF-8') == "Email can't be blank" then
                  assert_equal(email_num, 3)
      					elsif item.text.encode('UTF-8') == "Email has already been taken" then
                  assert_equal(email_num, 2)
      					elsif item.text.encode('UTF-8') ==  "Password is too short (minimum is 6 characters)" then
                  assert_equal(pw_num, 2)
      					elsif item.text.encode('UTF-8') == "Password can't be blank" then
                  assert_equal(pw_num, 3)
      					elsif item.text.encode('UTF-8') == "Password confirmation doesn't match Password" then
                  assert_not_equal(pwc_num, pw_num)
      					end
      				end
      			end
      		end
      	end
      end
    end
  end
end
