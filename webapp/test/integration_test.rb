require 'selenium-webdriver'
require 'active_support/all'
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
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)

      @driver.navigate.to('http://127.0.0.1:3000/users/sign_in')
      wait.until {
        @driver.find_element(:name, 'commit')
      }

      input_data(:id, 'user_email', 'a@hunter2.io')
      input_data(:id, 'user_password', 'hunter2')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until {
        @driver.find_element(:class, 'alert').text
      }

      alert_text = @driver.find_element(:class, 'alert').text
      assert(alert_text.include? 'Signed in successfully.')
    end

    test 'user can create a reference' do
      @driver.navigate.to(@new_reference_url)
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until {
         @driver.find_element(:name, 'commit')
      }

      input_data(:id, 'reference_title', 'Graph Theory')
      input_data(:id, 'reference_link', 'https://theory.com/graph_theory')
      input_data(:id, 'reference_note', 'Reference pertaining to elementary graph theory')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait.until {
        @driver.find_element(:tag_name, 'h1')
      }

      created = false

      @driver.find_elements(:tag_name, 'h1').each do |elem|
        if elem.text.include? 'Graph Theory'
          created = true
          break
        end
      end

      assert(created)
    end

    test 'user cant create a reference with empty link' do
      @driver.navigate.to(@new_reference_url)
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until {
         @driver.find_element(:name, 'commit')
      }

      input_data(:id, 'reference_title', 'Sorting Things')
      input_data(:id, 'reference_link', '')
      input_data(:id, 'reference_note', 'Reference pertaining to sorting things')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until {
        @driver.find_element(:class, 'alert').text
      }

      alert_text = @driver.find_element(:class, 'alert').text
      assert(alert_text.include? 'Not a valid URL!')
    end

  end

  class TestUserCreate < Test::Unit::TestCase

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

    test "user signup scenarios" do
      3.downto(1) do |email_num|
      	3.downto(1) do |pw_num|
      		3.downto(1) do |pwc_num|

      		  #Open
      			@driver.navigate.to @url_signup
            assert_equal('Webapp', @driver.title)

            #Waiting
      			wait = Selenium::WebDriver::Wait.new(:timeout => 15) # seconds
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
            @start_time = Time.now
      			if email_num == 1 then
      		 		email.send_keys @start_time.to_s(:type).gsub(/\s+/, "") +  "@zzz.com"  #New email
      			elsif email_num == 2 then
      				email.send_keys "a@hunter2.io"	 	#It has already been taken
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
      				wait = Selenium::WebDriver::Wait.new(:timeout => 15) # seconds
      				begin
      				  element = wait.until { @driver.find_element(:class, 'alert')}
                assert(element.text.include? 'Welcome! You have signed up successfully.')
      				ensure
      				end
      			#Wrong Case
      			else
      				wait = Selenium::WebDriver::Wait.new(:timeout => 15) # seconds
      				begin
      				  element = wait.until { @driver.find_element(:id => 'error_explanation') }
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
                  assert_equal(3, email_num)
      					elsif item.text.encode('UTF-8') == "Email has already been taken" then
                  assert_equal(2, email_num)
      					elsif item.text.encode('UTF-8') ==  "Password is too short (minimum is 6 characters)" then
                  assert_equal(2, pw_num)
      					elsif item.text.encode('UTF-8') == "Password can't be blank" then
                  assert_equal(3, pw_num)
      					elsif item.text.encode('UTF-8') == "Password confirmation doesn't match Password" then
                  assert_not_equal(pw_num, pwc_num)
      					end
      				end
      			end
      		end
      	end
      end
    end
  end

  class TestReferenceModification < Test::Unit::TestCase

    def input_data(finder, finder_value, value)
      elem = @driver.find_element(finder, finder_value)
      elem.clear
      elem.send_keys(value)
    end

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @home_url = 'http://127.0.0.1:3000/home'
      @new_reference_url = 'http://127.0.0.1:3000/references/new'
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)

      #Time for new email account
      Time::DATE_FORMATS[:type] = "%y%m%d%H%M"
      @start_time = Time.now

      @driver.navigate.to('http://127.0.0.1:3000/users/sign_in')
      wait.until {
        @driver.find_element(:name, 'commit')
      }

      input_data(:id, 'user_email', 'a@hunter2.io')
      input_data(:id, 'user_password', 'hunter2')

      @driver.find_element(:name, 'commit').click

      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until {
        @driver.find_element(:class, 'alert').text
      }

      alert_text = @driver.find_element(:class, 'alert').text
      assert(alert_text.include? 'Signed in successfully.')
    end

    test "can modify reference" do
      list = @driver.find_element(:xpath, "//div[contains(@class, 'container-fluid')]")
      new_a = list.find_element(:xpath, "//a[contains(@href, '/references/new')]")
      items = list.find_elements(:xpath, "//a[contains(@href, '/references/')]")

      items.each do |item|
        if item != new_a then
          item.click #Top item is selected
          break
        end
      end

      wait = Selenium::WebDriver::Wait.new(:timeout => 600) # seconds
      begin
        element = wait.until { @driver.find_element(:xpath, "//a[contains(@href, '/edit')]")}
      ensure
        #puts "Wait@edit"
      end

      edit = @driver.find_element(:xpath, "//a[contains(@href, '/edit')]")
      edit.click

      wait = Selenium::WebDriver::Wait.new(:timeout => 600) # seconds
      begin
        element = wait.until { @driver.find_element(:class, "edit_reference")}
      ensure
        #puts "Wait@edit_detail"
      end

      #Modify
      #title
      title = @driver.find_element(:id, 'reference_title')
      title.clear
      title.send_keys "Test_" + @start_time.to_s(:type)
      #link
      link = @driver.find_element(:id, 'reference_link')
      link.clear
      link.send_keys "test_r1.txt"
      #note
      note = @driver.find_element(:id, 'reference_note')
      note.clear
      note.send_keys @start_time.to_s(:type)
      #Click
      create = @driver.find_element(:name, 'commit')
      create.click
      #Waiting
      wait = Selenium::WebDriver::Wait.new(:timeout => 600) # seconds

      begin
        element = wait.until { @driver.find_element(:xpath, "//a[contains(@href, '/edit')]")}
      ensure
        #puts "Wait@edit_result"
      end

      #Check
      list = @driver.find_element(:xpath, "//div[contains(@class, 'container-fluid')]")
      #title
      items = list.find_elements(:tag_name, 'h1')
      flag_t = false
      items.each do |item|
        if item.text.encode('UTF-8') == "Test_" + @start_time.to_s(:type) then
          flag_t = true
        end
      end
      #link
      items = list.find_elements(:xpath, "//a[contains(@href, 'http://test_r1.txt')]")
      flag_l = false
      if items != nil then
        flag_l = true
      end
      #note
      items = list.find_elements(:tag_name, 'p')
      flag_n = false
      items.each do |item|
        if item.text.encode('UTF-8') == @start_time.to_s(:type) then
        flag_n = true
        end
      end

      if flag_t == true and flag_l == true and flag_n == true then
        assert true
      else
        assert false
      end
    end
  end
end
