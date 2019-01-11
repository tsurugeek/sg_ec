class User::PurchaseHistoriesController < User::ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show]

  def index
    @purchase_histories = PurchaseHistory.includes(:purchase_products).order("purchased_at desc").page(params[:page]).all
  end

  def show
  end

  private
    def set_product
      @purchase_history = PurchaseHistory.find(params[:id])
    end
end
