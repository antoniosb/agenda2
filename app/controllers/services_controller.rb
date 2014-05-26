class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  def index
    @services = Service.all
    authorize @services

    @service = Service.new
  end

  # GET /services/1
  def show
    authorize @service
  end

  # GET /services/new
  def new
    @service = Service.new
    authorize @service
  end

  # GET /services/1/edit
  def edit
    authorize @service
  end

  # POST /services
  def create
    @service = Service.new(service_params)
    authorize @service

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render action: 'show', status: :created, location: @service }
        format.js   { render action: 'show', status: :created, location: @service }
      else
        format.html { render action: 'new' } 
        format.json { render json: @service.errors, status: :unprocessable_entity }
        format.js   { render json: @service.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /services/1
  def update
    authorize @service
    if @service.update(service_params)
      redirect_to @service, notice: 'Service was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /services/1
  def destroy
    authorize @service
    @service.destroy
    redirect_to services_url, notice: 'Service was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def service_params
      params.require(:service).permit(:name, :price, :duration, :discount)
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action. VERY SERVICE MUCH WOW"
      if user_signed_in?
        redirect_to appointments_path
      else
        redirect_to root_path
      end
    end
end
