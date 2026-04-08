class BandsController < ApplicationController
  before_action :set_band, only: [:show, :edit, :update, :destroy]
  before_action :set_band_scope, only: [:index, :show]
  before_action :require_login, only: [:new, :edit, :create, :update, :destroy]

  def index
    @bands = @scoped_bands.order(created_at: :desc).page(params[:page])
  end

  def show
    @band   = @scoped_bands.find(params[:id])
    @shows  = @band.shows.order(date: :desc)
    @videos = @band.videos.joins(:show).order('shows.date desc, videos.name')
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def new
    @band = Band.new
  end

  def edit
  end

  def create
    @band = Band.new(band_params.except(:image))

    if @band.save
      if band_params[:image]
        set_attached_attributes(band_params[:image])

        @band.image.attach(
          io: @attached_tempfile,
          key: @attached_key,
          content_type: @attached_content_type,
          filename: @attached_file_name
        )
      end

      redirect_to @band, notice: 'Band was successfully created.'
    else
      render :new
    end
  end

  def update
    if @band.update(band_params.except(:image))

      if band_params[:image]
        @band.image.purge

        set_attached_attributes(band_params[:image])

        @band.image.attach(
          io: @attached_tempfile,
          key: @attached_key,
          content_type: @attached_content_type,
          filename: @attached_file_name
        )
      end

      redirect_to @band, notice: 'Band was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @band.destroy
    redirect_to bands_url, notice: 'Band was successfully destroyed.'
  end

  private

  def set_band
    @band = Band.find(params[:id])
  end

  def set_band_scope
    @scoped_bands = current_user ? Band.all : Band.published
    @scoped_bands = @scoped_bands.search(params[:q]) if params[:q]
    @scoped_bands
  end

  def set_attached_attributes(image_params)
    @attached_tempfile = image_params.tempfile
    @attached_content_type = image_params.content_type
    @attached_file_ext = @attached_content_type.split("/").last
    @attached_file_name = "#{@band.id}.#{@attached_file_ext}"
    @attached_key = "bands/#{@attached_file_name}"
  end

  # Only allow a trusted parameter "white list" through.
  def band_params
    params.require(:band).permit(
      :name,
      :location,
      :bio,
      :website,
      :bandcamp,
      :facebook,
      :soundcloud,
      :instagram,
      :twitter,
      :image,
      :status
    )
  end
end
