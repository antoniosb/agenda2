require 'spec_helper'

describe AppointmentsController do

  let!(:appointment) { create(:appointment) }

  let(:valid_attributes) {  {
      appointment_date: Time.now, 
      user_id: create(:user).id, 
      service_id: create(:service).id 
    } }

  describe "GET index" do
    it "assigns all appointments as @appointments" do
      get :index, {}
      assigns(:appointments).should eq(Appointment.all)
    end
  end

  describe "GET show" do
    it "assigns the requested appointment as @appointment" do
      get :show, {:id => appointment.to_param}
      assigns(:appointment).should eq(appointment)
    end
  end

  describe "GET new" do
    it "assigns a new appointment as @appointment" do
      get :new, {}
      assigns(:appointment).should be_a_new(Appointment)
    end
  end

  describe "GET edit" do
    it "assigns the requested appointment as @appointment" do
      get :edit, {:id => appointment.to_param}
      assigns(:appointment).should eq(appointment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Appointment" do
        expect {
          post :create, {:appointment => valid_attributes}
        }.to change(Appointment, :count).by(1)
      end

      it "assigns a newly created appointment as @appointment" do
        post :create, {:appointment => valid_attributes}
        assigns(:appointment).should be_a(Appointment)
        assigns(:appointment).should be_persisted
      end

      it "redirects to the created appointment" do
        post :create, {:appointment => valid_attributes}
        response.should redirect_to(Appointment.last)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Appointment.any_instance.stub(:save).and_return(false)
        post :create, {:appointment => { x:1 }}
      end
      
      it "assigns a newly created but unsaved appointment as @appointment" do
        assigns(:appointment).should be_a_new(Appointment)
      end

      it "re-renders the 'new' template" do
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested appointment" do
        # Assuming there are no other appointments in the database, this
        # specifies that the Appointment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Appointment.any_instance.should_receive(:update).with({ 'user_id' => "params" })
        put :update, {:id => appointment.to_param, :appointment => { 'user_id' => "params" }}
      end

      it "assigns the requested appointment as @appointment" do
        put :update, {:id => appointment.to_param, :appointment => valid_attributes}
        assigns(:appointment).should eq(appointment)
      end

      it "redirects to the appointment" do
        put :update, {:id => appointment.to_param, :appointment => valid_attributes}
        response.should redirect_to(appointment)
      end
    end

    describe "with invalid params" do
      it "assigns the appointment as @appointment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Appointment.any_instance.stub(:save).and_return(false)
        put :update, {:id => appointment.to_param, :appointment => { x:1 }}
        assigns(:appointment).should eq(appointment)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Appointment.any_instance.stub(:save).and_return(false)
        put :update, {:id => appointment.to_param, :appointment => { x:1 }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested appointment" do
      expect {
        delete :destroy, {:id => appointment.to_param}
      }.to change(Appointment, :count).by(-1)
    end

    it "redirects to the appointments list" do
      delete :destroy, {:id => appointment.to_param}
      response.should redirect_to(appointments_url)
    end
  end

end
