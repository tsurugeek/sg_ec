require 'rails_helper'

RSpec.describe "Admin::Products", type: :request do
  let!(:product){create(:product)}

  before(:each) do
    sign_in create(:admin), scope: :admin
  end

  describe "GET /products" do
    it "returns http status 200" do
      get admin_products_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(product.name)
    end
  end

  describe "GET /products/new" do
    it "returns http status 200" do
      get admin_products_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /products" do
    it "creates a new product and redirects to show page" do
      product = Product.new
      product.name = "product.name"
      product.price = "12345"
      product.description = "product.description"
      product.hidden = "0"
      product.sort_no = "67890"
      product.remove_product_image = "0"
      product_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample2.png'), 'image/png')

      post admin_products_path, params: {product: product.attributes.merge(product_image: product_image)}
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to include("product.name")
      expect(response.body).to include("12345")
      expect(response.body).to include("product.description")
      expect(response.body).to include("67890")
      expect(response.body).to include("sample2.png")
      expect(response.body).to include(I18n.t('messages.created'))
    end
  end

  describe "GET /products/:id" do
    it "returns http status 200" do
      get admin_product_path(product)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /products/:id/edit" do
    it "returns http status 200" do
      get edit_admin_product_path(product)
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /products/:id" do
    it "udpates attribubtes and redirects to show page" do
      product.name = "product.name"
      product.price = "12345"
      product.description = "product.description"
      product.sort_no = "67890"
      product_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample2.png'), 'image/png')

      put admin_product_path(product), params: {product: product.attributes.merge(product_image: product_image)}
      expect(response).to have_http_status(302)
      follow_redirect!
      
      expect(response.body).to include("product.name")
      expect(response.body).to include("12345")
      expect(response.body).to include("product.description")
      expect(response.body).to include("67890")
      expect(response.body).to include("sample2.png")
      expect(response.body).to include(I18n.t('messages.updated'))
    end
  end

  describe "DELETE /products/:id" do
    it "destroys the product and redirects to index page" do
      delete admin_product_path(product)
      expect(response).to redirect_to(admin_products_path)

      get admin_products_path
      expect(response.body).not_to include("product@sample.com")
      expect(response.body).to include(I18n.t('messages.destroyed'))
    end
  end
end
