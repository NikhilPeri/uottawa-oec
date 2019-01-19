require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do

  describe "POST #twilio" do
    it "returns http success" do
      post :twilio
      expect(response).to have_http_status(:success)
    end
  end
end
