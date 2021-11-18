# frozen_string_literal: true

require_relative '../../data/user_data'
require_relative '../../top_toolbar/top_toolbar'
require_relative 'modules/people_side_bar'
require_relative 'user_profile'

module TestingAppServer
  # AppServer People User creation form
  # https://user-images.githubusercontent.com/40513035/141932021-1800c838-6e02-4ac3-a94a-5c5f5ee2ca32.png
  class UserCreationForm
    include PageObject
    include PeopleSideBar
    include TopToolbar

    text_field(:first_name, xpath: "//input[@name='firstName']")
    text_field(:last_name, xpath: "//input[@name='lastName']")
    text_field(:email, xpath: "//input[@name='email']")
    label(:activation_link, xpath: "(//input[@name='passwordType']/../../label)[1]")
    label(:temporary_password, xpath: "(//input[@name='passwordType']/../../label)[2]")
    div(:generate_password, xpath: "(//div[@class = 'password-field-wrapper']/div)[2]")
    text_field(:password, xpath: "//input[@name='password']")

    button(:save_form, xpath: "//button[@class='sc-kNPwMy iHxaXx']") # add_id

    div(:success_toast, xpath: "//div[contains(@class, 'Toastify__toast--success')]")

    def initialize(instance)
      super(instance.webdriver.driver)
      @instance = instance
      wait_to_load
    end

    def wait_to_load
      @instance.webdriver.wait_until { first_name_element.present? }
    end

    def create_new_user(params = {})
      fill_user_form(params)
      @instance.webdriver.move_to_element_by_locator(save_form_element.selector[:xpath])
      save_form_element.click
      @instance.webdriver.wait_until { success_toast_element.present? }
      UserProfile.new(@instance)
    end

    def fill_user_form(params = {})
      self.first_name = params.first_name
      self.last_name = params.last_name
      self.email = params.mail
      add_password(params)
    end

    def add_password(params)
      case params.pwd_generation_type
      when :temporary_pwd
        temporary_password_element.click
        if params.generate_pwd
          generate_password_element.click
        else
          self.password = params.pwd
        end
      when :activation_link
        activation_link_element.click
      end
    end
  end
end
