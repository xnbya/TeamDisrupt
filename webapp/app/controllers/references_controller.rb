class ReferencesController < ApplicationController
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
      alert = "Saved!"
      redirect_to home_path
    else
      redirect_to new_reference_path
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

  def update
    @reference = Reference.find(params[:id])
    @user = @reference.user

    params[:reference][:link] = url_format(params[:reference][:link])
    unless params[:reference][:link].nil?
      if @user==current_user
        if @reference.update_attributes(reference_params)
          redirect_to @reference
        else
          flash[:alert] = "Something went wrong!"
        end
      else
        flash[:alert] = "You can't do that!"
        redirect_to @reference
      end
    else
      flash[:alert] = "Not a valid url!"
      redirect_to edit_reference_path(@reference)
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :link, :note)
  end

  def url_format(str)
    allowed_chars = "[-A-Za-z0-9@:%._\+~#=?&//=]"
    print str
    unless (/^(https?\:)?\/\// =~ str)
      str = "http://" << str
    end

    if /^(https?:)?\/\/#{allowed_chars}{2,256}\.[a-z]{2,6}\b(#{allowed_chars}*)?/ =~ str
      return str
    else
      return nil
    end
  end

end
