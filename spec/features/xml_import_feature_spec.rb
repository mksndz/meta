require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'XML Import' do

  context 'Uploader user', js: true do

    let(:uploader_user) { Fabricate :uploader }
    let(:batch) { Fabricate :batch }
    let(:valid_xml_text) {
                    '<?xml version="1.0" encoding="UTF-8"?>
                        <items type="array">
                          <item>
                            <dpla type="boolean">true</dpla>
                            <public type="boolean">true</public>
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
                            <dcterms_is_shown_at type="array">
                              <dcterms_is_shown_at>http://dlg.galileo.usg.edu/id:geh_0091_ahc0091-002-004</dcterms_is_shown_at>
                            </dcterms_is_shown_at>
                            <dcterms_provenance type="array">
                              <dcterms_provenance>Atlanta History Center</dcterms_provenance>
                            </dcterms_provenance>
                            <valid_item type="boolean">true</valid_item>
                            <has_thumbnail type="boolean">false</has_thumbnail>
                            <dcterms_bibliographic_citation type="array">
                              <dcterms_bibliographic_citation>Cite as: Leo Frank papers, MSS 91, Kenan Research Center at the Atlanta History Center.</dcterms_bibliographic_citation>
                            </dcterms_bibliographic_citation>
                            <collection>
                              <slug>0091</slug>
                            </collection>
                          </item>
                        </items>'
    }

    before :each do
      login_as uploader_user, scope: :user
      batch.user = uploader_user
      batch.save
    end

    scenario 'sees a button to import XML and can load the form' do

      visit edit_batch_path(batch)

      expect(page).to have_link I18n.t('meta.batch.actions.populate_with_xml')

      click_on I18n.t('meta.batch.actions.populate_with_xml')

      expect(page).to have_text I18n.t('meta.batch.labels.import.xml_file') # todo why wont have_field work?
      expect(page).to have_field I18n.t('meta.batch.labels.import.xml_text')
      expect(page).to have_field I18n.t('meta.batch.labels.import.bypass_validations')

          end

    scenario 'receives a popup error if no file or text provided' do

      visit import_batch_path batch

      click_on I18n.t('meta.batch.actions.import')

      expect(page).to have_text 'No file or XML text was provided.'

    end

    # scenario 'adds some valid xml as text and submits the form' do
    #
      # valid_xml_text = '<?xml version="1.0" encoding="UTF-8"?>
      #                   <items type="array">
      #                     <item>
      #                       <dpla type="boolean">true</dpla>
      #                       <public type="boolean">true</public>
      #                       <dc_format type="array">
      #                         <dc_format>application/pdf</dc_format>
      #                       </dc_format>
      #                       <dc_right type="array"/>
      #                       <dc_date type="array">
      #                         <dc_date>1915-06-22/1915-06-30</dc_date>
      #                       </dc_date>
      #                       <dc_relation type="array"/>
      #                       <slug>ahc0091-002-004</slug>
      #                       <dcterms_medium type="array">
      #                         <dcterms_medium>Letters (correspondence)</dcterms_medium>
      #                       </dcterms_medium>
      #                       <dcterms_identifier type="array">
      #                         <dcterms_identifier>http://dlg.galileo.usg.edu/ahc/leofrank/do:ahc0091-002-004</dcterms_identifier>
      #                       </dcterms_identifier>
      #                       <dcterms_language type="array"/>
      #                       <dcterms_spatial type="array">
      #                         <dcterms_spatial>United States, Georgia, Fulton County, Atlanta, 33.7489954, -84.3879824</dcterms_spatial>
      #                       </dcterms_spatial>
      #                       <dcterms_publisher type="array">
      #                         <dcterms_publisher>Box 2 Folder 4, Leo Frank papers, MSS 91, Kenan Research Center at the Atlanta History Center.</dcterms_publisher>
      #                       </dcterms_publisher>
      #                       <dcterms_rights_holder type="array"/>
      #                       <dcterms_subject type="array">
      #                         <dcterms_subject>Jews--Georgia--Atlanta</dcterms_subject>
      #                       </dcterms_subject>
      #                       <dcterms_temporal type="array"/>
      #                       <dcterms_title type="array">
      #                         <dcterms_title>Letters of sympathy and support to Leo Frank, 1915 June 22 - June 30</dcterms_title>
      #                       </dcterms_title>
      #                       <dcterms_type type="array">
      #                         <dcterms_type>Text</dcterms_type>
      #                       </dcterms_type>
      #                       <dcterms_is_shown_at type="array">
      #                         <dcterms_is_shown_at>http://dlg.galileo.usg.edu/id:geh_0091_ahc0091-002-004</dcterms_is_shown_at>
      #                       </dcterms_is_shown_at>
      #                       <dcterms_provenance type="array">
      #                         <dcterms_provenance>Atlanta History Center</dcterms_provenance>
      #                       </dcterms_provenance>
      #                       <valid_item type="boolean">true</valid_item>
      #                       <has_thumbnail type="boolean">false</has_thumbnail>
      #                       <dcterms_bibliographic_citation type="array">
      #                         <dcterms_bibliographic_citation>Cite as: Leo Frank papers, MSS 91, Kenan Research Center at the Atlanta History Center.</dcterms_bibliographic_citation>
      #                       </dcterms_bibliographic_citation>
      #                       <collection>
      #                         <slug>0091</slug>
      #                       </collection>
      #                     </item>
      #                   </items>'
    #
    #   batch_item_attributes = Hash.from_xml valid_xml_text
    #
    #   visit import_batch_path batch
    #
    #   fill_in I18n.t('meta.batch.labels.import.xml_text'), with: valid_xml_text
    #
    #   click_on I18n.t('meta.batch.actions.import')
    #
    #   expect(page).to have_content('Batch Item Successfully Created')
    #   expect(page).to have_content batch.batch_items.last.slug
    #
    #   visit edit_batch_batch_item_path(batch, batch.batch_items.last)
    #
    #   expect(page).to have_content batch_item_attributes[:items][0][:dcterms_title]
    #
    # end

    scenario 'adds a valid xml file and submits the form' do

    end

    scenario 'adds some invalid xml text and submits the form while bypassing validations' do

    end

  end

end