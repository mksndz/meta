require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:super_user) {
    Fabricate(:super)
  }

  before(:each) do
    sign_in super_user
  end

  let(:valid_attributes) {
    {
        email: 'test@user.com',
        password: 'password',
    }
  }

  let(:valid_session) { {} }

  describe 'GET #index' do

    it 'assigns all users as @users' do
      user = User.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:users)).to include(user)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      get :show, {:id => user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create! valid_attributes
      delete :destroy, {:id => user.to_param}, valid_session
      expect(response).to redirect_to(users_url)
    end
  end

end
