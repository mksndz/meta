require 'rails_helper'
include SunspotMatchers

RSpec.describe Meta::ItemSearch, type: :model do
  it 'searches for items' do
    Meta::ItemSearch.search(keyword: 'Item')
    expect(Sunspot.session).to be_a_search_for(Item)
  end

  it 'accepts one field' do
    Meta::ItemSearch.search(keyword: 'Item')
    expect(Sunspot.session).to have_search_params(:fulltext, 'Item')
  end

  it 'accepts two fields' do
    Meta::ItemSearch.search(keyword: 'Item', collection_id: 1)
    expect(Sunspot.session).to have_search_params(:fulltext, 'Item')
    expect(Sunspot.session).to have_search_params(:with, :collection_id, 1)
  end

  it 'does not explode if it receives unknown params' do
    expect {
      Meta::ItemSearch.search(unknown: 'param')
    }.to_not raise_error
  end
end