class Item < ActiveRecord::Base
  include Slugged
  include DcHelper

  belongs_to :collection
  has_one :repository, through: :collection
  has_many :batch_items

  validates_uniqueness_of :slug, scope: :collection_id
  validates_presence_of :collection

  delegate :collection_title, to: :collection
  delegate :repository_id, to: :collection

  searchable do

    string :slug, stored: true

    # set empty proxy id field so sunspot knows about it
    # value is set prior to save
    # sunspot search will not work without this, but indexing will
    # see monkeypatch @ config/initializers/sunspot_indexer_id.rb
    string :sunspot_id, stored: true do
      ''
    end

    integer :collection_id, references: Collection
    integer :repository_id, references: Collection

    boolean :dpla
    boolean :public

    string :collection_title, stored: true

    string :in_collection, stored: true do
      collection ? collection.display_title : ''
    end

    # DC Fields for Searching
    # *_display fields created via copyFields
    text :dc_identifier
    text :dc_right
    text :dc_relation
    text :dc_format
    text :dc_date
    text :dcterms_is_part_of
    text :dcterms_contributor
    text :dcterms_creator
    text :dcterms_description
    text :dcterms_extent
    text :dcterms_medium
    text :dcterms_identifier
    text :dcterms_language
    text :dcterms_spatial
    text :dcterms_publisher
    text :dcterms_access_right
    text :dcterms_rights_holder
    text :dcterms_subject
    text :dcterms_temporal
    text :dcterms_title
    text :dcterms_type
    text :dcterms_is_shown_at
    text :dcterms_provenance
    text :dcterms_license


    # Fields for Faceting, etc.
    string :format, stored: true do
      dcterms_type.first ? dcterms_type.first : ''
    end

    string :sort_title do
      dcterms_title.first ? dcterms_title.first.downcase.gsub(/^(an?|the)\b/, '') : ''
    end

  end

  def title
    dcterms_title.first
  end

  def to_xml(options = {})
    default_options = {
        dasherize: false,
        # fields to not include
        except: [
            :collection_id,
            :created_at,
            :updated_at
        ],
        include: {
            collection: {
                only: [
                    :slug
                ]
            }
        }
    }
    super(options.merge!(default_options))
  end

  def self.index_query(params)
    options = {}
    fields = %w(collection_id public).freeze
    if params.present?
      fields.each do |f|
        options[f] = params[f] if params[f] && !params[f].empty?
      end
    end
    options.present? ? where(options) : all
  end

end

