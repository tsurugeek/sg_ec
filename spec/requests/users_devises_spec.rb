require 'rails_helper'

# see: Rails.application.routes.routes.map{|route| ActionDispatch::Routing::RouteWrapper.new(route)}.map{|route| puts ":#{route.verb.downcase}, #{route.path.gsub("(.:format)", "")}"} && nil
RSpec.describe "UsersDevise", type: :request do
  let!(:product){create(:product, id: 1)}

  shared_examples "allowed" do |http_method, path|
    specify "#{http_method.upcase} [#{path}] is accessable" do
      send(http_method, path)
      expect(response).not_to redirect_to('/users/sign_in')
      expect(response.body).not_to include("アカウント登録もしくはログインしてください")
    end
  end

  shared_examples 'forbidden' do |http_method, path|
    specify "#{http_method.upcase} [#{path}] is NOT accessable" do
      send(http_method, path)
      expect(response).to redirect_to('/users/sign_in')
      follow_redirect!
      expect(response.body).to include("アカウント登録もしくはログインしてください")
    end
  end

  context "when user has NOT logged in," do
    it_behaves_like 'allowed',   :get,    "/"
    it_behaves_like 'forbidden', :put,    "/products/1/cart_product/update_num"
    it_behaves_like 'allowed',   :get,    "/products/1/cart_product/new"
    it_behaves_like 'forbidden', :delete, "/products/1/cart_product"
    it_behaves_like 'forbidden', :post,   "/products/1/cart_product"
    it_behaves_like 'allowed',   :get,    "/products"
    it_behaves_like 'forbidden', :put,    "/cart/fix_products"
    it_behaves_like 'forbidden', :get,    "/cart/edit_shipping_address"
    it_behaves_like 'forbidden', :put,    "/cart/fix_shipping_address"
    it_behaves_like 'forbidden', :put,    "/cart/purchase"
    it_behaves_like 'forbidden', :get,    "/cart/show_complete"
    it_behaves_like 'forbidden', :get,    "/cart/edit"
    it_behaves_like 'forbidden', :get,    "/cart"
    it_behaves_like 'forbidden', :get,    "/purchase_histories"
    it_behaves_like 'forbidden', :get,    "/purchase_histories/1"
  end

  context "when user has logged in," do
    before do
      sign_in create(:user), scope: :user
    end
    it_behaves_like 'allowed',   :get,  "/"
    it_behaves_like 'allowed',   :get,  "/products"
    it_behaves_like 'allowed',   :get,  "/products/1/cart_product/new"
    it_behaves_like 'allowed',   :get,  "/cart/edit"
    it_behaves_like 'allowed',   :get,  "/purchase_histories"
  end
end
