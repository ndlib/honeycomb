class CollectionsController < ApplicationController
  def index
    @collections = CollectionQuery.new.for_editor(current_user)
    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Collections,
                                         action: "index",
                                         collections: @collections)
    fresh_when(etag: cache_key.generate)
  end

  def show
    redirect_to collection_items_path(params[:id])
  end

  def new
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.build
  end

  def create
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.build

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t(".success")
      redirect_to collection_path(@collection)
    else
      render :new
    end
  end

  def edit
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)

    cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Collections,
                                         action: "edit",
                                         collection: @collection)
    fresh_when(etag: cache_key.generate)
  end

  def import_google_sheet
  end

  # Constructs and redirects to an auth request to google. Packs the collection id, file, and sheet
  # into state data so that this data persists the round trip.
  def import_authorize
    file_auth_params = params[:file_auth]
    session = GoogleSession.new
    authorization_uri = session.auth_request_uri(
      callback_uri: import_google_sheet_callback_collections_url,
      state_hash: {
        collection_id: params[:id],
        file: file_auth_params[:file_name],
        sheet: file_auth_params[:sheet_name] }
    )
    redirect_to authorization_uri
  end

  # This should get called whenever google redirects after a successful authorization request.
  # We'll get an authorization code in the params and use this to make the connection
  # to google to read the sheet data
  def import_google_sheet_callback
    state_hash = JSON.parse(Base64::decode64(params[:state]))
    session = GoogleSession.new
    session.connect(auth_code: params[:code], callback_uri: import_google_sheet_callback_collections_url)
    work_sheet = session.get_worksheet(file: state_hash["file"], sheet: state_hash["sheet"])

    # Just as a PoC, print the worksheet data
    render plain: work_sheet.rows
  end

  def update
    @collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(@collection)

    if SaveCollection.call(@collection, save_params)
      flash[:notice] = t(".success")
      redirect_to edit_collection_path(@collection)
    else
      render :edit
    end
  end

  def destroy
    check_admin_or_admin_masquerading_permission!

    @collection = CollectionQuery.new.find(params[:id])
    Destroy::Collection.new.cascade!(collection: @collection)

    flash[:notice] = t(".success")
    redirect_to collections_path
  end

  def exhibit
    collection = CollectionQuery.new.find(params[:collection_id])
    exhibit = EnsureCollectionHasExhibit.call(collection)

    redirect_to exhibit_path(exhibit)
  end

  def publish
    collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(collection)

    if Publish.call(collection)
      flash[:notice] = t(".success")
      redirect_to edit_collection_path(collection)
    else
      render :edit
    end
  end

  def unpublish
    collection = CollectionQuery.new.find(params[:id])
    check_user_edits!(collection)

    if Unpublish.call(collection)
      flash[:notice] = t(".success")
      redirect_to edit_collection_path(collection)
    else
      render :edit
    end
  end

  protected

  def save_params
    params.require(:collection).permit(:name_line_1, :name_line_2, :description, :id)
  end
end
