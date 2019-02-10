class Admin::ProductsController < Admin::ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::DeleteRestrictionError do |exception|
    redirect_to admin_products_url, notice: "この商品がショッピングカートに入っている、または購入されているため削除できません。"
    # タイミングの問題でRailsが誤判断しても外部キー制約があるので削除できない。ただし、500エラーになるのでユーザーフレンドリーではない。
    # exception.sql_state
    # => "23000"
    # exception.error
    # => "Cannot delete or update a parent row: a foreign key constraint fails (`sg_ec_development`.`purchase_products`, CONSTRAINT `fk_rails_57ad37ee9d` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`))"
    # exception.errno
    # => 1451
    # exception.error_number
    # => 1451
  end

  def index
    @products = Product.order(:sort_no).all
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

  def update_sort_nos
    Product.update_sort_nos(params[:ids].try(:split, ","))

    redirect_to admin_products_path, notice: "#{Product.human_attribute_name(:sort_no)}を変更しました"
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
      params.require(:product).permit(:name, :price, :description, :hidden, :sort_no, :product_image, :remove_product_image)
    end
end
