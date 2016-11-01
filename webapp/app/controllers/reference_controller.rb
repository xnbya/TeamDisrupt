class ReferenceController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.new
  end

  def index
  end
end
