require 'spec_helper'

describe ServicesController do

  let(:valid_attributes) { {:name=>('a'..'z').to_a.shuffle.slice(0..10).join, :price=>22.1, :duration=>25} }

  let!(:service) { create(:service) }

  before(:each) do
      controller.stub(:current_user).and_return(create(:user))
  end

  describe "GET index" do
    it "assigns all services as @services" do
      get :index
      assigns(:services).should eq(Service.all)
    end
  end

  describe "GET show" do
    it "assigns the requested service as @service" do
      get :show, {:id => service.id}
      assigns(:service).should eq(service)
    end
  end

  describe "GET new" do
    it "assigns a new service as @service" do
      get :new
      assigns(:service).should be_a_new(Service)
    end
  end

  describe "GET edit" do
    it "assigns the requested service as @service" do
      get :edit, {:id => service.id}
      assigns(:service).should eq(service)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Service" do
        expect {
          post :create, {:service => valid_attributes}
        }.to change(Service, :count).by(1)
      end

      it "assigns a newly created service as @service" do
        post :create, {:service => valid_attributes}
        assigns(:service).should be_a(Service)
        assigns(:service).should be_persisted
      end

      it "redirects to the created service" do
        post :create, {:service => valid_attributes}
        response.should redirect_to(Service.last)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Service.any_instance.stub(:save).and_return(false)
        post :create, {:service => { x:1 } }
      end

      it "assigns a newly created but unsaved service as @service" do
        assigns(:service).should be_a_new(Service)
      end

      it "re-renders the 'new' template" do
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested service" do
        Service.any_instance.should_receive(:update).with({ "name" => "params" })
        put :update, {:id => service.id, :service => { :name => "params" }}
      end

      it "assigns the requested service as @service" do
        put :update, {:id => service.to_param, :service => valid_attributes}
        assigns(:service).should eq(service)
      end

      it "redirects to the service" do
        put :update, {:id => service.to_param, :service => valid_attributes}
        response.should redirect_to(service)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Service.any_instance.stub(:save).and_return(false)
        put :update, {:id => service.to_param, :service => { x:1 }}
      end
      it "assigns the service as @service" do
        assigns(:service).should eq(service)
      end

      it "re-renders the 'edit' template" do
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested service" do
      expect {
        delete :destroy, {:id => service.to_param}
      }.to change(Service, :count).by(-1)
    end

    it "redirects to the services list" do
      delete :destroy, {:id => service.to_param}
      response.should redirect_to(services_url)
    end
  end

end
