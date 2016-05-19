class UsersController < ApplicationController

  load_and_authorize_resource

  include Sorting
  include ErrorHandling

  before_action :set_data, only: [:new, :edit]
  before_action :confirm_restrictions, only: [:create, :update]

  class UserRestrictionsError < StandardError
  end

  rescue_from UserRestrictionsError do
    redirect_to :back, alert: I18n.t('meta.user.messages.errors.user_restriction_error')
  end


  def index
    if current_user.coordinator?
      @users = User.active
                   .where(creator_id: current_user.id)
                   .order(sort_column + ' ' + sort_direction)
                   .page(params[:page])
                   .per(params[:per_page])
    else
      @users = User.active
                   .order(sort_column + ' ' + sort_direction)
                   .page(params[:page])
                   .per(params[:per_page])
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    set_user_creator
    if @user.save
      redirect_to user_path(@user), notice: I18n.t('meta.defaults.messages.success.created', entity: 'User')
    else
      set_data
      render :new, alert: I18n.t('meta.defaults.messages.errors.not_created', entity: 'User')
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: I18n.t('meta.defaults.messages.success.updated', entity: 'User')
    else
      set_data
      render :edit, alert: I18n.t('meta.defaults.messages.errors.not_updated', entity: 'User')
    end
  end

  def destroy
    # todo determine if a soft delete would be better for users
    @user.destroy
    redirect_to users_url, notice: I18n.t('meta.defaults.messages.success.destroyed', entity: 'User')
  end

  private

  def set_roles
    @roles = Role.all
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :creator_id, role_ids: [], repository_ids: [], collection_ids: [])
  end

  def set_user_creator
    @user.creator = current_user
  end

  def set_data
    @data ||= {}
    @data[:roles] = Role.all
    @data[:repositories]= current_user.super? ? Repository.all : current_user.repositories
    @data[:collections] = current_user.super? ? Collection.all : current_user.collections
  end

  def confirm_restrictions
    # todo test coverage for this
    unless current_user.super?
      new_user_collection_ids = user_params[:collection_ids] || []
      new_user_repository_ids = user_params[:repository_ids] || []
      throw UserRestrictionsError unless (new_user_repository_ids - current_user.repository_ids).empty?
      throw UserRestrictionsError unless (new_user_collection_ids - current_user.collection_ids).empty?
      throw UserRestrictionsError if current_user.coordinator? and user_params[:role_ids]
    end
  end

end
