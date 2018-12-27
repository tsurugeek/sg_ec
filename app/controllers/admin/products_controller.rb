class Admin::ProductsController < Admin::ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to [:admin, @product], notice: I18n.t('messages.created')
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to [:admin, @product], notice: I18n.t('messages.updated')
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_url, notice: I18n.t('messages.destroyed')
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price, :description, :hidden, :sort_no)
    end
end
