require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  let!(:car) { create(:car) } 

  before do
    sign_in create(:user) 
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @cars" do
      get :index
      expect(assigns(:cars)).to include(car)
    end

    it "filters cars based on query" do
    debugger
      get :index, params: { query: car.name }
      expect(response).to have_http_status(:ok)
    #   expect(assigns(:cars)).to eq([car])
    end
  end

  describe "GET #show" do
  it "returns a successful response" do
    car = Car.create!(valid_attributes)
    get :show, params: { id: car.id }
    expect(response).to be_successful
  end

    it "assigns @car" do
      get :show, params: { id: car.id }
      expect(assigns(:car)).to eq(car)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new car to @car" do
      get :new
      expect(assigns(:car)).to be_a_new(Car)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { { car: { title: 'New Car', description: 'Great car', price: 20000, available: true } } }

      it "creates a new Car" do
        expect {
          post :create, params: valid_attributes
        }.to change(Car, :count).by(1)
      end

      it "redirects to the car show page" do
        post :create, params: valid_attributes
        expect(response).to redirect_to(Car.last)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { car: { title: '', description: 'Great car', price: nil, available: true } } }

      it "does not create a new Car" do
        expect {
          post :create, params: invalid_attributes
        }.to change(Car, :count).by(0)
      end

      it "renders the new template" do
        post :create, params: invalid_attributes
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #search" do
    it "returns a successful response" do
      get :search, params: { query: car.name }
      expect(response).to be_successful
    end

    it "assigns @cars based on search query" do
      get :search, params: { query: car.name }
      expect(assigns(:cars)).to include(car)
    end

    it "renders the index template" do
      get :search, params: { query: car.name }
      expect(response).to 
    end
  end
end
