class RelationshipsController < ApplicationController
  before_action :load_relationship, only: :destroy
  before_action :load_user, only: :create
  before_action :authenticate_user!

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to profile_path(@user)}
      format.turbo_stream
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to profile_path(@user)}
      format.turbo_stream
    end
  end

  private
  def load_relationship
    @relationship = Relationship.find_by(id: params[:id])
    return if @relationship

    flash[:alert] = t "msg.relationship_not_found"
    redirect_to root_path
  end

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:alert] = t "msg.user_not_found"
    redirect_to root_path
  end
end
