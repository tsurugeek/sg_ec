class User::CartsController < User::ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  rescue_from ActiveRecord::StaleObjectError do |exception|
    redirect_to edit_cart_path, alert: '他のパソコン/スマートフォンでカートの情報が変更されました。再度操作を実施してください。'
  end

  def show
  end

  def show_complete
  end

  def edit
    unless @cart.purchase_products.any?
      flash.now.notice = 'ショッピングカートは空です'
    end
  end

  def edit_shipping_address
    if @cart.ref_shipping_address.nil? && current_user.shipping_address.available?
      @cart.ref_shipping_address = true
    end
  end

  def update
    if params[:fix_products].present?
      if @cart.update(state: Cart.states[:products_fixed])
        redirect_to edit_shipping_address_cart_path
      else
        render :edit # TODO:
      end

    elsif params[:fix_shipping_address].present?
      @cart.attributes = cart_params
      if @cart.update_shipping_address
        redirect_to cart_path
      else
        render :edit_shipping_address
      end

    elsif params[:purchase].present?
      @cart.attributes = cart_params
      if @cart.purchase
        redirect_to show_complete_cart_path
      else
        render :show
      end
    end
  end

  private

  def set_cart
    @cart = current_user.cart
  end

  def cart_params
    params.require(:cart).permit(:ref_shipping_address, :save_shipping_address, :lock_version, shipping_address_attributes: [:id, :name, :postal_code, :prefecture, :city, :address, :building])
  end
end
