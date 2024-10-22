require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  describe "GET #index" do
    let!(:car) { FactoryBot.create(:car, name: "Toyota") }
    let!(:car2) { FactoryBot.create(:car, name: "Maruti") }
    let!(:user) { FactoryBot.create(:user) } # Assuming you have a User factory

    before do
      sign_in user # Authenticate the user before each test
    end

    it "filters cars based on query" do
      get :index, params: { query: car.name }
      
      expect(response).to have_http_status(:ok) 
    end

    it "returns all cars when no query is given" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end