class ReferenceController < ApplicationController
  before_action :authenticate_user!

  def new
    @reference = Reference.new
  end

  def create
    @reference = current_user.references.new(reference_params)
    if @reference.save
      redirect_to '/home'
    else
      redirect_to '/references/create'
    end
  end

  def index
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :link, :note)
  end
end
