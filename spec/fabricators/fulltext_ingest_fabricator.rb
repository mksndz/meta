require 'faker'

Fabricator(:fulltext_ingest) do
  title { Faker::Hipster.sentence(2) }
  description { Faker::Hipster.sentence(7) }
  user { Fabricate :super }
  file File.open("#{Rails.root}/spec/files/fulltext.zip")
end

Fabricator(:completed_fulltext_ingest_success, from: :fulltext_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
  finished_at { Faker::Time.between(Date.today, Date.today + 1) }
  results do
    {
      status: 'success',
      message: 'Hooray',
      files: {
        succeeded: [Fabricate(:item_with_parents).id, Fabricate(:item_with_parents).id],
        failed: {}
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
      message: 'Message',
      files: {
        succeeded: [Fabricate(:item_with_parents).id],
        failed: {
          r1_c1_i2: 'Exception message'
        }
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
      message: 'Overall failure',
      files: {
        succeeded: [],
        failed: {
          r1_c1_i1: 'Exception message',
          r1_c1_i2: 'Exception message'
        }
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

Fabricator(:completed_fulltext_ingest_for_undoing, from: :fulltext_ingest) do
  queued_at { Faker::Time.between(Date.today - 1, Date.today) }
  finished_at { Faker::Time.between(Date.today, Date.today + 1) }
  results do
    {
      status: 'success',
      message: 'Hooray',
      files: {
        succeeded: [Fabricate(:item_with_parents).id],
        failed: {}
      }
    }
  end
end