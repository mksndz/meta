require 'faker'

Fabricator(:batch_import) do
  user { Fabricate :uploader }
  batch
  format { %w[file text].sample }
  match_on_id { false }
  xml {
    '<?xml version="1.0" encoding="UTF-8"?>
    <items type="array">
      <item>
        <portals type="array">
          <portal>
            <code>georgia</code>
          </portal>
        </portals>
        <collection>
          <record_id>geh_0091</record_id>
        </collection>
        <other_colls type="array">
          <other_coll>
            <record_id>lpb_aa</record_id>
          </other_coll>
        </other_colls>
        <dpla type="boolean">true</dpla>
        <public type="boolean">true</public>
        <local type="boolean">true</local>
        <dc_format type="array">
          <dc_format>application/pdf</dc_format>
        </dc_format>
        <dc_right type="array"/>
        <dc_date type="array">
          <dc_date>1915-06-22/1915-06-30</dc_date>
        </dc_date>
        <dc_relation type="array"/>
        <slug>ahc0091-002-004</slug>
        <dcterms_medium type="array">
          <dcterms_medium>Letters (correspondence)</dcterms_medium>
        </dcterms_medium>
        <dcterms_identifier type="array">
          <dcterms_identifier>http://dlg.galileo.usg.edu/ahc/leofrank/do:ahc0091-002-004</dcterms_identifier>
        </dcterms_identifier>
        <dcterms_language type="array"/>
        <dcterms_spatial type="array">
          <dcterms_spatial>United States, Georgia, Fulton County, Atlanta, 33.7489954, -84.3879824</dcterms_spatial>
        </dcterms_spatial>
        <dcterms_publisher type="array">
          <dcterms_publisher>Box 2 Folder 4, Leo Frank papers, MSS 91, Kenan Research Center at the Atlanta History Center.</dcterms_publisher>
        </dcterms_publisher>
        <dcterms_rights_holder type="array"/>
        <dcterms_subject type="array">
          <dcterms_subject>Jews--Georgia--Atlanta</dcterms_subject>
        </dcterms_subject>
        <dcterms_temporal type="array"/>
        <dcterms_title type="array">
          <dcterms_title>Letters of sympathy and support to Leo Frank, 1915 June 22 - June 30</dcterms_title>
        </dcterms_title>
        <dcterms_type type="array">
          <dcterms_type>Text</dcterms_type>
        </dcterms_type>
        <edm_is_shown_at type="array">
          <edm_is_shown_at>http://dlg.galileo.usg.edu/id:geh_0091_ahc0091-002-004</edm_is_shown_at>
        </edm_is_shown_at>
        <edm_is_shown_by type="array">
          <edm_is_shown_by>http://dlg.galileo.usg.edu/id:geh_0091_ahc0091-002-004</edm_is_shown_by>
        </edm_is_shown_by>
        <dcterms_provenance type="array">
          <dcterms_provenance>Atlanta History Center</dcterms_provenance>
        </dcterms_provenance>
        <dcterms_bibliographic_citation type="array">
          <dcterms_bibliographic_citation>Cite as: Leo Frank papers, MSS 91, Kenan Research Center at the Atlanta History Center.</dcterms_bibliographic_citation>
        </dcterms_bibliographic_citation>
      </item>
    </items>'
  }
end

Fabricator(:completed_batch_import, from: :batch_import) do
  results do
    {
      added: [
        {
          batch_item_id: 1,
          slug: 'ahc0091-002-004'
        }
      ],
      updated: [],
      failed: []
    }
  end
  validations { true }
  batch_items(count: 1)
  completed_at { Time.now.to_s }

end

Fabricator(:completed_batch_import_with_update, from: :batch_import) do

  results do
    {
      added: [],
      updated: [
        batch_item_id: 1,
        item_id: 1,
        slug: 'ahc0091-002-004'
      ],
      failed: []
    }
  end
  validations { true }
  batch_items(count: 1)
  completed_at { Time.now.to_s }

end

Fabricator(
  :completed_batch_import_with_failure,
  from: :completed_batch_import
) do
  results do
    {
      added: [],
      updated: [],
      failed: [
        {
          number: 1,
          message: 'Validation Failed'
        }
      ]
    }
  end
  validations { true }
  completed_at { Time.now.to_s }
end

Fabricator(
  :completed_batch_import_with_mixed_results,
  from: :completed_batch_import
) do
  results do
    {
      added: [
        {
          batch_item_id: 1,
          slug: 'ahc0091-002-004'
        }
      ],
      updated: [
        batch_item_id: 1,
        item_id: 1,
        slug: 'ahc0091-002-004'
      ],
      failed: [
        {
          number: 1,
          message: 'Validation Failed'
        }
      ]
    }
  end
  validations { true }
  completed_at { Time.now.to_s }
end

Fabricator(:completed_batch_import_from_file, from: :batch_import) do
  file_name { 'xml_file.xml' }
end

Fabricator(:completed_batch_import_from_search_result, from: :batch_import) do
  format { 'search query' }
end

Fabricator(:batch_import_to_match_on_id, from: :batch_import) do
  match_on_id { true }
  xml {
    '<?xml version="1.0" encoding="UTF-8"?>
    <items type="array">
      <item>
        <id>__ID__</id>
        <portals type="array">
          <portal>
            <code>__PORTAL_CODE__</code>
          </portal>
        </portals>
        <collection>
          <record_id>__COLLECTION_RECORD_ID__</record_id>
        </collection>
        <other_colls type="array" />
        <dpla type="boolean">true</dpla>
        <public type="boolean">true</public>
        <local type="boolean">true</local>
        <dc_format type="array">
          <dc_format>application/pdf</dc_format>
        </dc_format>
        <dc_right type="array"/>
        <dc_date type="array">
          <dc_date>1915-06-22/1915-06-30</dc_date>
        </dc_date>
        <dc_relation type="array"/>
        <slug>ahc0091-002-004</slug>
        <dcterms_medium type="array">
          <dcterms_medium>Letters (correspondence)</dcterms_medium>
        </dcterms_medium>
        <dcterms_identifier type="array">
          <dcterms_identifier>http://dlg.galileo.usg.edu/ahc/leofrank/do:ahc0091-002-004</dcterms_identifier>
        </dcterms_identifier>
        <dcterms_language type="array"/>
        <dcterms_spatial type="array">
          <dcterms_spatial>United States, Georgia, Fulton County, Atlanta, 33.7489954, -84.3879824</dcterms_spatial>
        </dcterms_spatial>
        <dcterms_publisher type="array">
          <dcterms_publisher>Box 2 Folder 4, Leo Frank papers, MSS 91, Kenan Research Center at the Atlanta History Center.</dcterms_publisher>
        </dcterms_publisher>
        <dcterms_rights_holder type="array"/>
        <dcterms_subject type="array">
          <dcterms_subject>Jews--Georgia--Atlanta</dcterms_subject>
        </dcterms_subject>
        <dcterms_temporal type="array"/>
        <dcterms_title type="array">
          <dcterms_title>Letters of sympathy and support to Leo Frank, 1915 June 22 - June 30</dcterms_title>
        </dcterms_title>
        <dcterms_type type="array">
          <dcterms_type>Text</dcterms_type>
        </dcterms_type>
        <edm_is_shown_at type="array">
          <edm_is_shown_at>http://dlg.galileo.usg.edu/id:geh_0091_ahc0091-002-004</edm_is_shown_at>
        </edm_is_shown_at>
        <edm_is_shown_by type="array">
          <edm_is_shown_by>http://dlg.galileo.usg.edu/id:geh_0091_ahc0091-002-004</edm_is_shown_by>
        </edm_is_shown_by>
        <dcterms_provenance type="array">
          <dcterms_provenance>Atlanta History Center</dcterms_provenance>
        </dcterms_provenance>
        <dcterms_bibliographic_citation type="array">
          <dcterms_bibliographic_citation>Cite as: Leo Frank papers, MSS 91, Kenan Research Center at the Atlanta History Center.</dcterms_bibliographic_citation>
        </dcterms_bibliographic_citation>
      </item>
    </items>'
  }
end

Fabricator(:batch_import_for_updating_record_id, from: :batch_import) do
  match_on_id { true }
  format { 'search result' }
  batch_items { [Fabricate(:batch_item)] }
end

Fabricator(:batch_import_with_xml_containing_cdata, from: :batch_import) do
  xml {
    '<?xml version="1.0" encoding="UTF-8"?>
    <items type="array">
      <item>
        <portals type="array">
          <portal>
            <code>georgia</code>
          </portal>
        </portals>
        <collection>
          <record_id>geh_0091</record_id>
        </collection>
        <dpla type="boolean">true</dpla>
        <public type="boolean">true</public>
        <local type="boolean">true</local>
        <dc_format type="array">
          <dc_format>application/pdf</dc_format>
        </dc_format>
        <dc_right type="array"/>
        <dc_date type="array">
          <dc_date>1915-06-22/1915-06-30</dc_date>
        </dc_date>
        <dc_relation type="array"/>
        <slug>ahc0091-002-004</slug>
        <dcterms_medium type="array">
          <dcterms_medium>PDF</dcterms_medium>
        </dcterms_medium>
        <dcterms_language type="array"/>
        <dcterms_spatial type="array">
          <dcterms_spatial>United States, Georgia, Fulton County, Atlanta, 33.7489954, -84.3879824</dcterms_spatial>
        </dcterms_spatial>
        <dcterms_rights_holder type="array"/>
        <dcterms_subject type="array">
          <dcterms_subject>Jews--Georgia--Atlanta</dcterms_subject>
        </dcterms_subject>
        <dcterms_temporal type="array"/>
        <dcterms_title type="array">
          <dcterms_title>Testing CDATA</dcterms_title>
        </dcterms_title>
        <dcterms_type type="array">
          <dcterms_type>Text</dcterms_type>
        </dcterms_type>
        <edm_is_shown_at type="array">
          <edm_is_shown_at><![CDATA[http://metis.galib.uga.edu/ssp/cgi-bin/legis-idx.pl?sessionid=518e2e7a-03c20a8e54-3823&type=toc&byte=362951]]></edm_is_shown_at>
        </edm_is_shown_at>
        <edm_is_shown_by type="array">
          <edm_is_shown_by><![CDATA[http://metis.galib.uga.edu/ssp/cgi-bin/legis-idx.pl?sessionid=518e2e7a-03c20a8e54-3823&type=toc&byte=362951]]></edm_is_shown_by>
        </edm_is_shown_by>
        <dcterms_provenance type="array">
          <dcterms_provenance>Atlanta History Center</dcterms_provenance>
        </dcterms_provenance>
      </item>
    </items>'
  }
end