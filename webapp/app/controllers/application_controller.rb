class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_nav

  def set_nav
    @nav_items = [
      {
        :name => "Home",
        :url => root_path
      },

      {
        :name => "Sign In",
        :url => new_user_session_path
      }
    ]

    @nav_items_user = [
      {
        :name => "Home",
        :url => home_path
      },

      {
        :name => "References",
        :url => references_path
      }
    ]
  end
end
