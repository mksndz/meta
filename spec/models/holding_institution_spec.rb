require 'rails_helper'

RSpec.describe HoldingInstitution, type: :model do
  it 'has none to begin with' do
    expect(HoldingInstitution.count).to eq 0
  end
  it 'has one after adding one' do
    Fabricate :holding_institution
    expect(HoldingInstitution.count).to eq 1
  end
  context 'when created' do
    let(:holding_institution) { Fabricate :holding_institution }
    it 'has a display_name' do
      expect(holding_institution.display_name).not_to be_empty
      expect(holding_institution.display_name).to be_a String
    end
    it 'has Projects' do
      projects = Fabricate.times(2, :project)
      holding_institution.projects = projects
      expect(holding_institution).to respond_to 'projects'
      expect(holding_institution.projects.first).to be_a Project
    end
    it 'has Repositories' do
      repositories = Fabricate.times(2, :empty_repository)
      holding_institution.repositories = repositories
      expect(holding_institution).to respond_to 'repositories'
      expect(holding_institution.repositories.count).to eq 2
      expect(holding_institution.repositories.first).to be_a Repository
    end
    it 'has Portals (via Repositories)' do
      repositories = Fabricate.times(2, :empty_repository)
      holding_institution.repositories = repositories
      expect(holding_institution.portal_names).to include Repository.last.portals.first.name
    end
  end
  context 'when Validating' do
    it 'requires a display_name' do
      holding_institution = Fabricate.build(:holding_institution, display_name: nil)
      holding_institution.valid?
      expect(holding_institution.errors).to have_key :display_name
    end
    it 'requires a unique display_name' do
      Fabricate :holding_institution, display_name: 'Taken'
      holding_institution = Fabricate.build(:holding_institution, display_name: 'Taken')
      holding_institution.valid?
      expect(holding_institution.errors).to have_key :display_name
    end
    it 'requires an institution_type' do
      holding_institution = Fabricate.build(:holding_institution, institution_type: nil)
      holding_institution.valid?
      expect(holding_institution.errors).to have_key :institution_type
    end
  end
  context 'when deleting' do
    let(:holding_institution) do
      Fabricate :holding_institution, display_name: 'Test'
    end
    it 'does not delete if an item still uses it' do
      Fabricate(
        :item_with_parents,
        holding_institutions: [holding_institution]
      )
      expect do
        holding_institution.destroy
      end.to raise_error HoldingInstitutionInUseError
    end
    it 'does not delete if a collection still uses it' do
      Fabricate(
        :empty_collection,
        holding_institutions: [holding_institution]
      )
      expect do
        holding_institution.destroy
      end.to raise_error HoldingInstitutionInUseError
    end
  end
end
