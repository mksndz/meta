module ItemIndexing
  extend ActiveSupport::Concern

  included do

    searchable do

      string :slug, stored: true

      # set empty proxy id field so sunspot knows about it
      # value is set prior to save
      # sunspot search will not work without this, but indexing will
      # see monkeypatch @ config/initializers/sunspot_indexer_id.rb
      string :sunspot_id, stored: true do
        ''
      end

      boolean :dpla
      boolean :public

      string :in_collection, stored: true do
        collection ? collection.display_title : ''
      end

      # DC Fields for Searching
      # *_display fields created via copyFields
      text :dc_title
      text :dc_format
      text :dc_publisher
      text :dc_identifier
      text :dc_rights
      text :dc_contributor
      text :dc_coverage_t
      text :dc_coverage_s
      text :dc_date
      text :dc_source
      text :dc_subject
      text :dc_type
      text :dc_description
      text :dc_creator
      text :dc_language
      text :dc_relation

      # Fields for Faceting, etc.
      string :format, stored: true do
        dc_type.first ? dc_type.first : ''
      end

      string :sort_title do
        dc_title.first.downcase.gsub(/^(an?|the)\b/, '')
      end

    end

  end

end