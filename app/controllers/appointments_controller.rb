class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :set_users_and_services, only:[:new, :create, :edit]
  
  # GET /appointments
  def index
    @appointments = Appointment.by_datetime
    authorize @appointments
  end

  # GET /appointments/1
  def show
    authorize @appointment
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    authorize @appointment
  end

  # GET /appointments/1/edit
  def edit
    authorize @appointment
    @status = Appointment::APPOINTMENT_STATUS
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(appointment_params)
    authorize @appointment

    if @appointment.save
      redirect_to @appointment, notice: 'Appointment was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /appointments/1
  def update
    authorize @appointment
    if @appointment.update(appointment_params)
     # if !current_user.admin?
     #   @appointment.update_attribute :status, Appointment::PENDING
     # end
      redirect_to @appointment, notice: 'Appointment was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /appointments/1
  def destroy
    authorize @appointment
    if current_user.admin?
      @appointment.destroy
    else
      @appointment.update_attribute :status, Appointment::CANCELED
    end
    redirect_to appointments_url, notice: 'Appointment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def appointment_params
      params.require(:appointment).permit(:user_id, :service_id, :appointment_date, :status)
    end

    def set_users_and_services
      @services = Service.all.collect { |x| [x.name, x.id] }
      @users = User.all.map do |user|
        if current_user.admin?
          [user.name, user.id]
        else
          [user.name, user.id] if user.id == current_user.id
        end
      end.compact
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action. VERY APPOINTMENT SUCH WOW"
      if user_signed_in?
        redirect_to appointments_path
      else
        redirect_to root_path
      end
    end

end
