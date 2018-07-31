require 'faker'

Fabricator(:fulltext_ingest) do
  title { Faker::Hipster.sentence(2) }
  description { Faker::Hipster.sentence(7) }
  user { Fabricate :super }
  file { Faker::File.file_name }
end

Fabricator(:completed_fulltext_ingest_success, from: :fulltext_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
  finished_at { Faker::Time.between(Date.today, Date.today + 1) }
  results do
    {
      status: 'success',
      files: {
        r1_c1_i1: { status: 'success', item: Fabricate(:item_with_parents).id },
        r1_c1_i2: { status: 'success', item: Fabricate(:item_with_parents).id }
      }
    }
  end
end

Fabricator(:completed_fulltext_ingest_with_errors, from: :fulltext_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
  finished_at { Faker::Time.between(Date.today, Date.today + 1) }
  results do
    {
      status: 'partial failure',
      files: {
        r1_c1_i1: { status: 'success', item: Fabricate(:item_with_parents).id },
        r1_c1_i2: { status: 'failed', reason: 'Exception message' }
      }
    }
  end
end

Fabricator(:completed_fulltext_ingest_total_failure, from: :fulltext_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
  finished_at { Faker::Time.between(Date.today, Date.today + 1) }
  results do
    {
      status: 'failed',
      files: {
        r1_c1_i1: { status: 'failed', reason: 'Exception message' },
        r1_c1_i2: { status: 'failed', reason: 'Exception message' }
      }
    }
  end
end

Fabricator(:queued_fulltext_ingest, from: :fulltext_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
end

Fabricator(:undone_fulltext_ingest, from: :fulltext_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
  undone_at { Faker::Time.between(Date.today, Date.today + 1) }
end