require 'rails_helper'

RSpec.describe "AdminsDevise", type: :request do
  let!(:product){create(:product, id: 1)}

  shared_examples "allowed" do |http_method, path|
    specify "#{http_method.upcase} [#{path}] is accessable" do
      send(http_method, path)
      expect(response).not_to redirect_to('/admins/sign_in')
      expect(response.body).not_to include("アカウント登録もしくはログインしてください")
    end
  end

  shared_examples 'forbidden' do |http_method, path|
    specify "#{http_method.upcase} [#{path}] is NOT accessable" do
      send(http_method, path)
      expect(response).to redirect_to('/admins/sign_in')
      follow_redirect!
      expect(response.body).to include("アカウント登録もしくはログインしてください")
    end
  end

  context "when admin has NOT logged in," do
    it_behaves_like 'forbidden', :get,  "/admin"
    it_behaves_like 'forbidden', :get,  "/admin/products"
    it_behaves_like 'forbidden', :get,  "/admin/users"
  end

  context "when admin has logged in," do
    before do
      sign_in create(:admin), scope: :admin
    end
    it_behaves_like 'allowed',   :get,  "/admin"
    it_behaves_like 'allowed',   :get,  "/admin/products"
    it_behaves_like 'allowed',   :get,  "/admin/users"
  end
end
