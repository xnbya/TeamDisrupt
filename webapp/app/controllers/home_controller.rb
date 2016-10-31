class HomeController < ApplicationController
    before_action :authenticate_user!, only: [:home]

    def index
      redirect_to :home if user_signed_in?
    end

    def home
    end
end
