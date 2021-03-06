require 'faker'

Fabricator(:repository) do
  slug do
    Faker::Internet.slug(
      Faker::Lorem.sentence(3).chomp('.'),
      '-'
    )
  end
  title { 'Repo ' + Faker::Lorem.sentence(4) }
  portals(count: 1)
  collections(count: 1) do |attrs|
    Fabricate.build(
      :collection,
      portals: attrs[:portals],
      items: [
        Fabricate.build(:item, portals: attrs[:portals])
      ]
    )
  end
end

Fabricator(:empty_repository, from: :repository) do
  collections []
end

Fabricator(:repository_public_true, from: :repository) do
  public true
end