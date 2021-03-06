module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  NO_THUMB_ICON = 'no_thumb.png'.freeze # todo replace with no thumb placeholder

  def iiif_urls(document, _options = {})
    iiif_ids = document['iiif_ids_sms']
    return nil if iiif_ids.blank?

    iiif_ids.map do |id|
      "#{Rails.application.secrets.iiif_base_uri}#{id}/info.json"
    end
  end

  def render_page_title
    if content_for?(:page_title)
      head_page_titleify content_for(:page_title)
    elsif content_for?(:title)
      head_page_titleify content_for(:title)
    elsif @page_title
      head_page_titleify @page_title
    elsif application_name
      application_name
    end
  end

  def record_thumbnail(document, _options)
    url = case document['sunspot_id_ss'].split(' ')[0]
          when 'Item'
            if document.has_key?('slug_ss') &&
               document.has_key?('collection_slug_ss') &&
               document.has_key?('repository_slug_ss')
              "https://dlg.galileo.usg.edu/#{document['repository_slug_ss']}/#{document['collection_slug_ss']}/do-th:#{document['slug_ss']}"
            else
              NO_THUMB_ICON
            end
          when 'Collection'
            document['thumbnail_ss'].gsub('http://', 'https://')
          else
            NO_THUMB_ICON
          end
    image_tag(url, class: 'thumbnail')
  end

  private

  def head_page_titleify(pre)
    pre.strip + ' - ' + application_name
  end

end