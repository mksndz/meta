require 'rails_helper'
require 'devise/test_helpers'

RSpec.describe BatchesController, type: :controller do
  let(:super_user) { Fabricate(:super) }
  let(:valid_attributes) { { name: 'Test Batch', user_id: super_user.id } }
  let(:invalid_attributes) { { name: nil } }
  before(:each) { sign_in super_user }
  describe 'GET #index' do
    it 'assigns all batches as @batches' do
      batch = Batch.create! valid_attributes
      get :index
      expect(assigns(:batches)).to eq [batch]
    end
  end
  describe 'GET #show' do
    it 'assigns the requested batch as @batch' do
      batch = Batch.create! valid_attributes
      get :show, id: batch.id
      expect(assigns(:batch)).to eq batch
    end
  end
  describe 'GET #new' do
    it 'assigns a new batch as @batch' do
      get :new
      expect(assigns(:batch)).to be_a_new Batch
    end
  end
  describe 'GET #edit' do
    it 'assigns the requested batch as @batch' do
      batch = Batch.create! valid_attributes
      get :edit, id: batch.id
      expect(assigns(:batch)).to eq batch
    end
  end
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Batch' do
        expect do
          post :create, batch: valid_attributes
        end.to change(Batch, :count).by 1
      end
      it 'assigns a newly created batch as @batch' do
        post :create, batch: valid_attributes
        expect(assigns(:batch)).to be_a Batch
        expect(assigns(:batch)).to be_persisted
      end
      it 'redirects to the created batch' do
        post :create, batch: valid_attributes
        expect(response).to redirect_to Batch.last
      end
    end
    context 'with invalid params' do
      it 'assigns a newly created but unsaved batch as @batch' do
        post :create, batch: invalid_attributes
        expect(assigns(:batch)).to be_a_new Batch
      end
      it 're-renders the "new" template' do
        post :create, batch: invalid_attributes
        expect(response).to render_template 'new'
      end
    end
  end
  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { notes: 'Notes test' } }
      it 'updates the requested batch' do
        batch = Batch.create! valid_attributes
        put :update, id: batch.id, batch: new_attributes
        batch.reload
        expect(batch.notes).to eq 'Notes test'
      end
      it 'assigns the requested batch as @batch' do
        batch = Batch.create! valid_attributes
        put :update, id: batch.id, batch: valid_attributes
        expect(assigns(:batch)).to eq batch
      end
      it 'redirects to the batch' do
        batch = Batch.create! valid_attributes
        put :update, id: batch.id, batch: valid_attributes
        expect(response).to redirect_to batch
      end
    end
    context 'with invalid params' do
      it 'assigns the batch as @batch' do
        batch = Batch.create! valid_attributes
        put :update, id: batch.id, batch: invalid_attributes
        expect(assigns(:batch)).to eq(batch)
      end

      it 're-renders the "edit" template' do
        batch = Batch.create! valid_attributes
        put :update, id: batch.id, batch: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested batch' do
      batch = Batch.create! valid_attributes
      expect do
        delete :destroy, id: batch.id
      end.to change(Batch, :count).by(-1)
    end
    it 'redirects to the batches list' do
      batch = Batch.create! valid_attributes
      delete :destroy, id: batch.id
      expect(response).to redirect_to batches_url
    end
  end
  describe 'POST #commit' do
    it 'queues the requested batch for committing' do
      batch = Fabricate(:batch) { batch_items(count: 1) }
      post :commit, id: batch.id
      expect(response).to redirect_to batch
    end
  end
  describe 'GET #results' do
    it 'displays results of a committed batch' do
      batch = Fabricate(:batch) { batch_items(count: 1) }
      batch.commit
      get :results, id: batch.id
      expect(response).to render_template 'results'
    end
  end
  describe 'GET #recreate' do
    it 'recreates committed batch' do
      batch = Fabricate(:batch) { batch_items(count: 1) }
      batch.commit
      get :recreate, id: batch.id
      recreated_batch = Batch.find_by_name 'RECREATED ' + batch.name
      expect(response).to redirect_to recreated_batch
    end
  end
  describe 'GET #select' do
    before :each do
      @ids = '1,2,3,4'
      @batches = Fabricate.times 2, :batch
      xhr :get, :select, ids: @ids, format: :js
    end
    it 'assigns record ids as a comma separated string @ids' do
      expect(assigns(:ids)).to eq @ids
    end
    it 'assigns batches to @batches' do
      expect(assigns(:batches)).to eq @batches
    end
    it 'renders select template' do
      expect(response).to render_template 'select'
    end
  end
end
