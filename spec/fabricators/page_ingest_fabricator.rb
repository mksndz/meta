require 'faker'

Fabricator(:page_ingest) do
  title { Faker::Hipster.sentence 3 }
  description { Faker::Hipster.sentence 7 }
  file File.open(Rails.root.join('spec', 'files', 'pages.json'))
  user
end

Fabricator(:queued_page_ingest, from: :page_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
end

Fabricator(:page_ingest_with_json, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  page_json do
    [
      { id: Fabricate(:item_with_parents).record_id,
        pages: [
          { fulltext: 'First page fulltext', file_type: 'jp2', number: 1 },
          { fulltext: 'Second page fulltext', file_type: 'jp2', number: 2 }
        ] },
      { id: Fabricate(:item_with_parents).record_id,
        pages: [
          { fulltext: 'First page fulltext', file_type: 'jp2', number: 1 }
        ] }
    ]
  end
end

Fabricator(:page_ingest_with_unpaginated_fulltext, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  page_json do
    [
      { id: Fabricate(:item_with_parents).record_id,
        fulltext: 'Item-level un-paginated full text',
        pages: [
          { file_type: 'jp2', number: 1 },
          { file_type: 'jp2', number: 2 }
        ] },
      { id: Fabricate(:item_with_parents).record_id,
        pages: [
          { fulltext: '', file_type: 'jp2', number: 1 }
        ] }
    ]
  end
end

Fabricator(:page_ingest_with_item_file_type, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  page_json do
    [
      { id: Fabricate(:item_with_parents).record_id,
        file_type: 'jp2',
        pages: [
          { number: 1 },
          { number: 2, file_type: 'jpeg' }
        ] },
      { id: Fabricate(:item_with_parents).record_id,
        pages: [
          { fulltext: '', file_type: 'tiff', number: 1 }
        ] }
    ]
  end
end

Fabricator(:page_ingest_with_fulltext_conflict, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  page_json do
    [{ id: Fabricate(:item_with_parents).record_id,
       fulltext: 'Item-level un-paginated full text',
       pages: [
         { file_type: 'jp2', number: 1 }
       ] }]
  end
end

Fabricator(:page_ingest_with_internal_fulltext_conflict, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  page_json do
    [{ id: Fabricate(:item_with_parents, fulltext: nil).record_id,
       fulltext: 'Item-level un-paginated full text',
       pages: [
         { fulltext: 'Page-level fulltext', file_type: 'jp2', number: 1 }
       ] }]
  end
end

Fabricator(:page_ingest_with_bad_id, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  page_json do
    [{ id: 'bad id',
       pages: [
         { fulltext: 'First page fulltext', file_type: 'jp2', number: 1 }
       ] },
     { id: Fabricate(:item_with_parents, fulltext: nil).record_id,
       pages: [
         { fulltext: 'First page fulltext', file_type: 'jp2', number: 1 }
       ] }]
  end
end

Fabricator(:page_ingest_with_bad_page, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  page_json do
    [
      { id: Fabricate(:item_with_parents).record_id,
        pages: [{ text: 'First page fulltext', file_type: 'jp2' }] }
    ]
  end
end

Fabricator(:page_ingest_with_json_and_mixed_results, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  finished_at { Faker::Time.between(Time.zone.today, Time.zone.today + 1) }
  results_json do
    {
      status: 'partial success',
      message: '2 pages created',
      errors: [
        { item_id: 'a_b_c', message: 'Could not import' }
      ],
      added: [
        { item_id: '1', message: 'Succeeded Page', id: '1' },
        { item_id: '2', message: 'Second Succeeded Page', id: '2' }
      ]
    }
  end
end

Fabricator(:page_ingest_with_json_and_success, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  finished_at { Faker::Time.between(Time.zone.today, Time.zone.today + 1) }
  results_json do
    {
      status: 'success', message: '2 pages created',
      added: [
        { item_id: '1', message: 'Succeeded Page', id: '1' },
        { item_id: '2', message: 'Second Succeeded Page', id: '2' }
      ],
      errors: []
    }
  end
end

Fabricator(:page_ingest_with_json_and_total_failure, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  finished_at { Faker::Time.between(Time.zone.today, Time.zone.today + 1) }
  results_json do
    {
      status: 'failed',
      message: 'Worker failed completely',
      added: [],
      errors: []
    }
  end
end

Fabricator(:page_ingest_with_json_and_failed_pages, from: :page_ingest) do
  queued_at { Faker::Time.between(Time.zone.today - 1, Time.zone.today) }
  finished_at { Faker::Time.between(Time.zone.today, Time.zone.today + 1) }
  results_json do
    {
      status: 'failed',
      message: 'All Pages failed to ingest',
      added: [],
      errors: [
        { item_id: 'a_b_c', message: 'Could not import' },
        { item_id: 'a_b_c', message: 'Could not import' }
      ]
    }
  end
end

Fabricator(:page_ingest_for_updating_existing_page, from: :page_ingest) do
  file ''
  page_json do
    [
      { id: Fabricate(:item_with_parents, fulltext: nil).record_id,
        pages: [
          { fulltext: 'Updated fulltext',
            file_type: 'jp2',
            number: Fabricate(:page, item: Item.last).number }
        ] }
    ]
  end
end
