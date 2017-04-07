class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end
  
  def create_trip
    case params[:d_timezone]
    when "Eastern Time (US & Canada)"
      d_utc_time = params[:d_datetime] + 5.hours
    when "Central Time (US & Canada)"
      d_utc_time = params[:d_datetime] + 6.hours
    when "Mountain Time (US & Canada)"
      d_utc_time = params[:d_datetime] + 7.hours
    when "Pacific Time (US & Canada)"
      d_utc_time = params[:d_datetime] + 8.hours
    else
      puts "ERROR PARSING DATE"
      return false
    end
    
    if params[:d_datetime].in_time_zone(params[:d_timezone]).dst?
      d_utc_time = d_utc_time - 1.hour
    end
    
    case params[:a_timezone]
    when "Eastern Time (US & Canada)"
      a_utc_time = params[:a_datetime] + 5.hours
    when "Central Time (US & Canada)"
      a_utc_time = params[:a_datetime] + 6.hours
    when "Mountain Time (US & Canada)"
      a_utc_time = params[:a_datetime] + 7.hours
    when "Pacific Time (US & Canada)"
      a_utc_time = params[:a_datetime] + 8.hours
    else
      puts "ERROR PARSING DATE"
      return false
    end
    
    if params[:a_datetime].in_time_zone(params[:a_timezone]).dst?
      a_utc_time = a_utc_time - 1.hour
    end
    
    confirmation_number = params[:confirmation]
    
    current_user.trips.create(depart_time: d_utc_time, depart_time_zone: params[:d_timezone], return_time: a_utc_time, return_time_zone: params[:a_timezone], confirmation_number: confirmation_number)
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.fetch(:page, {})
    end
end
