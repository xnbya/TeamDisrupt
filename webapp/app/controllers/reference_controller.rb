class ReferenceController < ApplicationController
  before_action :authenticate_user!

  # Displays new reference form.
  def new
    @reference = Reference.new
  end

  # Creates a new reference.
  def create
    @reference = current_user.references.new(reference_params)

    #TODO: Sanitise links

    if @reference.save
      redirect_to '/home'
    else
      redirect_to '/references/create'
    end
  end

  # Shows all references.
  def index
    start = (params[:start].to_i > 0)? params[:start].to_i : 0
    @references = Reference.limit(5).offset(start)
  end

  # Shows a reference by its id.
  def show
    @reference = Reference.find(params[:id])
    @user = @reference.user
  end

  # Show edit form for a reference.
  def edit
    @reference = Reference.find(params[:id])
    @user = @reference.user

    # Don't delete if it doesn't belong to user!
    unless @user == current_user
      flash[:alert] = "You cannot edit this because you aren't #{@user.nil? ? "nil user" : @user.name}!"
      redirect_to @reference
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :link, :note)
  end

  # def verify_url()
  # end
  #TODO finish this
end
