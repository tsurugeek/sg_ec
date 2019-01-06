class User::CartProductsController < User::ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :set_product
  before_action :set_cart, except: [:new]
  before_action :set_cart_product, only: [:create, :update_num]

  def new
    @cart_product = @product.purchase_products.build
  end

  def create
    if @cart_product.valid_attribute?(:num) && @cart.add_product(@product, @cart_product.num)
      redirect_to edit_cart_path, notice: 'カートに保存しました'
    else
      render :new
    end
  end

  def update_num
    if @cart_product.invalid_attribute?(:num)
      render :update_num
    elsif @cart.update_product(@product, @cart_product.num)
      @cart_product = @cart.purchase_products.find_by(product:  @product)
      render :update_num
    else
      flash.now[:alert] = "数量を変更できませんでした。カートを再表示してから再度実行してください。"
      render partial: 'shared/message'
    end
  end

  def destroy
    @cart.remove_product(@product)
    redirect_to edit_cart_path, notice: 'カートから削除しました'
  end

  private
    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_cart
      @cart = current_user.cart
    end

    def set_cart_product
      @cart_product = @product.purchase_products.build(cart_product_params)
    end

    def cart_product_params
      params.require(:purchase_product).permit(:num)
    end
end
