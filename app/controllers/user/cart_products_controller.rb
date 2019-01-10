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
      redirect_to edit_cart_path, notice: "#{Cart.model_name.human}に保存しました"
    else
      render :new
    end
  end

  # for ajax
  def update_num
    if @cart_product.invalid_attribute?(:num)
      render :update_num
    elsif @cart.update_product(params[:lock_version], @product, @cart_product.num)
      @cart_product = @cart.purchase_products.find_by(product:  @product)
      flash.now[:notice] = I18n.t('messages.updated')
      render :update_num
    else
      flash.now[:alert] = @cart_product.joined_messages
      render partial: 'shared/messages', formats: :js
    end
  rescue ActiveRecord::StaleObjectError => e
    flash[:alert] = I18n.t('activerecord.errors.messages.stale_object', record: Cart.model_name.human)
    js_redirect_to edit_cart_path
  rescue StandardError => e
    logger_error e
    flash[:alert] = "数量を更新できませんでした。しばらくしてから再度実施してください。"
    js_redirect_to edit_cart_path
  end

  def destroy
    @cart.remove_product(@product)
    redirect_to edit_cart_path, notice: "#{Cart.model_name.human}から削除しました"
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
      @cart_product.purchase = @cart
    end

    def cart_product_params
      params.require(:purchase_product).permit(:num)
    end
end
