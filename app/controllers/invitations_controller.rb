class InvitationsController < Devise::InvitationsController

  after_action :set_user_creator, only: [:create]
  before_action :set_data, only: [:new, :create]
  before_action :configure_permitted_parameters, only: [:create]

  # show all pending invitations
  def index
    @pending_invitations = User.pending_invitation_response
    render 'index'
  end

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  private

  def set_user_creator
    resource.creator = resource.invited_by if resource.is_a? User
  end

  # todo this is identical to that in UserController
  def set_data
    @data ||= {}
    @data[:roles] = Role.all
    @data[:repositories]= current_user.super? ? Repository.all : current_user.repositories
    @data[:collections] = current_user.super? ? Collection.all : current_user.collections
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:invite).concat [
       { role_ids: [] },
       { repository_ids: [] },
       { collection_ids: [] }
     ]
  end

end