require 'rails_helper'

describe Page do
  context 'basic attributes' do
    let(:page) { Fabricate :page_with_item_and_text }
    it 'has an Item' do
      expect(page.item).to be_an Item
    end
    it 'has a number as a string' do
      expect(page.number).to be_a String
    end
    it 'has a title' do
      expect(page.title).to be_a String
    end
    it 'has fulltext' do
      expect(page.fulltext).to be_a String
    end
    context 'validations' do
      it 'requires a number' do
        p = Fabricate.build(:page, number: nil)
        p.valid?
        expect(p.errors).to have_key :number
      end
      it 'requires a unique number per Item' do
        i = Fabricate(:item_with_parents_and_pages)
        p = Fabricate.build(:page, number: i.pages.first.number, item: i)
        p.valid?
        expect(p.errors).to have_key :number
      end
    end
  end
end
