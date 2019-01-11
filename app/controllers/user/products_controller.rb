class User::ProductsController < User::ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.published.order(:sort_no).page(params[:page]).per(20).all
  end

  def show
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end
end
