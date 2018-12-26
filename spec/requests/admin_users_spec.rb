require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let!(:user){create(:user, email: "user@sample.com")}

  before(:each) do
    sign_in create(:admin), scope: :admin
  end

  describe "GET /users" do
    it "returns http status 200" do
      get admin_users_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(user.email)
    end
  end

  describe "GET /users/:id" do
    it "returns http status 200" do
      get admin_user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /users/:id/edit" do
    it "returns http status 200" do
      get edit_admin_user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /users/:id" do
    it "udpates attribubtes and redirects to show page" do
      user.shipping_address.name = "shipping_address.name"
      user.shipping_address.postal_code = "123-4567"
      user.shipping_address.prefecture = "shipping_address.prefecture"
      user.shipping_address.city = "shipping_address.city"
      user.shipping_address.address = "shipping_address.address"
      user.shipping_address.building = "shipping_address.building"
      put admin_user_path(user), params: {user: {shipping_address_attributes: user.shipping_address.attributes}}
      expect(response).to redirect_to(admin_user_path(user))

      get admin_user_path(user)
      expect(response.body).to include("shipping_address.name")
      expect(response.body).to include("123-4567")
      expect(response.body).to include("shipping_address.prefecture")
      expect(response.body).to include("shipping_address.city")
      expect(response.body).to include("shipping_address.address")
      expect(response.body).to include("shipping_address.building")
      expect(response.body).to include(I18n.t('messages.updated'))
    end
  end

  describe "DELETE /users/:id" do
    it "destroys the user and redirects to index page" do
      delete admin_user_path(user)
      expect(response).to redirect_to(admin_users_path)

      get admin_users_path
      expect(response.body).not_to include("user@sample.com")
      expect(response.body).to include(I18n.t('messages.destroyed'))
    end
  end
end
