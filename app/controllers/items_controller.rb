class ItemsController < ApplicationController

  load_and_authorize_resource
  include ErrorHandling
  include DcHelper
  include Sorting
  include Searchable
  include Filterable

  before_action :set_paper_trail_whodunnit
  before_action :set_data, only: [ :new, :copy, :edit ]

  def index

    set_filter_options [:repository, :collection, :public]

    if current_user.super?
        @items = Item.index_query(params)
                     .order(sort_column + ' ' + sort_direction)
                     .page(params[:page])
                     .per(params[:per_page])
                     .includes(:collection)
    else
        @items = Item.index_query(params)
                     .includes(:collection)
                     .where(collection: user_collection_ids)
                     .order(sort_column + ' ' + sort_direction)
                     .page(params[:page])
                     .per(params[:per_page])
                     .includes(:collection)
    end

  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(split_dc_params(item_params))
    if @item.save
      redirect_to item_path(@item), notice: I18n.t('meta.defaults.messages.success.created', entity: 'Item')
    else
      set_data
      render :new, alert: I18n.t('meta.defaults.messages.errors.not_created', entity: 'Item')
    end
  end

  def copy
    @item = Item.new(@item.attributes.except(:id))
    render :edit
  end

  def edit
  end

  def update
    if @item.update(split_dc_params(item_params))
      redirect_to item_path(@item), notice: I18n.t('meta.defaults.messages.success.updated', entity: 'Item')
    else
      set_data
      render :edit, alert: I18n.t('meta.defaults.messages.errors.not_updated', entity: 'Item')
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: I18n.t('meta.defaults.messages.success.destroyed', entity: 'Item')
  end

  def multiple_destroy
    Item.destroy(multiple_action_params[:entities].split(','))
    Sunspot.commit
    respond_to do |format|
      format.json { render json: {}, status: :ok  }
    end
  end

  def xml
    @items = Item.where id: multiple_action_params[:entities].split(',')
    respond_to do |format|
      format.xml { render xml: @items }
    end
  end

  def deleted
    @item_versions = ItemVersion.where(item_type: 'Item', event: 'destroy')
  end

  private

  def set_data
    @data = {}
    @data[:collections] = Collection.all.order(:display_title)
  end

  def item_params
    params[:item]['other_collections'].reject!{ |e| e.empty? } if params[:item]['other_collections']
    params.require(:item).permit(
        :collection_id,
        :slug,
        :dpla,
        :public,
        :date_range,
        :dc_identifier,
        :dc_right,
        :dc_relation,
        :dc_format,
        :dc_date,
        :dcterms_is_part_of,
        :dcterms_contributor,
        :dcterms_creator,
        :dcterms_description,
        :dcterms_extent,
        :dcterms_medium,
        :dcterms_identifier,
        :dcterms_language,
        :dcterms_spatial,
        :dcterms_publisher,
        :dcterms_access_right,
        :dcterms_rights_holder,
        :dcterms_subject,
        :dcterms_temporal,
        :dcterms_title,
        :dcterms_type,
        :dcterms_is_shown_at,
        :dcterms_provenance,
        :dcterms_license,
        :other_collections => [],
    )
  end

  def multiple_action_params
    params.permit(:entities)
  end

end
