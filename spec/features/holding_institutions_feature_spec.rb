require 'rails_helper'
require 'chosen-rails/rspec'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Holding Institution management' do
  let(:holding_institution) do
    Fabricate(:empty_collection).holding_institutions.first
  end
  before :each do
    login_as Fabricate(:super), scope: :user
  end
  context 'basic CRUD functionality' do
    context 'index page' do
      scenario 'sees a list of all holding institutions and action buttons' do
        holding_institution.reload
        visit holding_institutions_path
        expect(page).to have_text holding_institution.authorized_name
        expect(page).to have_link I18n.t('meta.defaults.actions.view')
        expect(page).to have_link I18n.t('meta.defaults.actions.edit')
        expect(page).to have_link I18n.t('meta.defaults.actions.destroy')
      end
      scenario 'deleting a holding institution still in use shows an error message', js: true do
        Fabricate(:empty_collection, holding_institutions: [holding_institution])
        visit holding_institutions_path
        click_on I18n.t('meta.defaults.actions.destroy')
        page.accept_confirm do
          'Yes'
        end
        expect(page).to have_text 'Cannot delete Holding Institution as it remains assigned to'
      end
    end
    context 'show page' do
      it 'displays all record information' do
        holding_institution.repositories << Repository.last
        holding_institution.projects << Fabricate(:project)
        holding_institution.save
        visit holding_institution_path(holding_institution)
        expect(page).to have_text holding_institution.authorized_name
        expect(page).to have_text holding_institution.repositories.first.title
        expect(page).to have_text holding_institution.short_description
        expect(page).to have_text holding_institution.description
        expect(page).to have_text holding_institution.homepage_url
        expect(page).to have_text holding_institution.coordinates
        expect(page).to have_text holding_institution.strengths
        expect(page).to have_text holding_institution.public_contact_address
        expect(page).to have_text holding_institution.public_contact_email
        expect(page).to have_text holding_institution.public_contact_phone
        expect(page).to have_text holding_institution.collections.first.display_title
        expect(page).to have_text holding_institution.projects.first.title
        expect(page).to have_text holding_institution.contact_name
        expect(page).to have_text holding_institution.contact_email
        expect(page).to have_text holding_institution.galileo_member
        expect(page).to have_text holding_institution.harvest_strategy
        expect(page).to have_text holding_institution.oai_urls.first
        expect(page).to have_text holding_institution.ignored_collections
        expect(page).to have_text holding_institution.last_harvested_at
        expect(page).to have_text holding_institution.analytics_emails.first
        expect(page).to have_text holding_institution.subgranting
        expect(page).to have_text holding_institution.grant_partnerships
        expect(page).to have_text holding_institution.training
        expect(page).to have_text holding_institution.site_visits
        expect(page).to have_text holding_institution.consultations
        expect(page).to have_text holding_institution.impact_stories
        expect(page).to have_text holding_institution.newspaper_partnerships
        expect(page).to have_text holding_institution.committee_participation
        expect(page).to have_text holding_institution.other
      end
    end
    context 'edit page', js: true do
      before :each do
        visit edit_holding_institution_path(holding_institution)
      end
      it 'shows a chosen multi-select for Repositories' do
        expect(page).to have_css '#holding_institution_repository_ids_chosen'
      end
      it 'shows a chosen select for institution_type' do
        expect(page).to have_css '#holding_institution_institution_type_chosen'
      end
      context 'image uploading' do
        it 'allows for image uploading, saving and display' do
          holding_institution.remove_image!
          holding_institution.save
          visit edit_holding_institution_path(holding_institution)
          attach_file(
            I18n.t('activerecord.attributes.holding_institution.image'),
            Rails.root.to_s + '/spec/files/aarl.gif'
          )
          click_button I18n.t('meta.defaults.actions.save')
          expect(page).to have_current_path holding_institution_path holding_institution
          expect(page).to have_css "img[src*='record_image']"
        end
      end
    end
    context 'new page' do
      before :each do
        visit new_holding_institution_path
      end
      it 'saves an array value for OAI URLs' do
        fill_in I18n.t('activerecord.attributes.holding_institution.authorized_name'), with: 'Test'
        fill_in I18n.t('activerecord.attributes.holding_institution.oai_urls'), with: "URL 1\nURL 2"
        click_button I18n.t('meta.defaults.actions.save')
        expect(page).to have_text 'URL 1'
        expect(page).to have_text 'URL 2'
      end
    end
  end
end