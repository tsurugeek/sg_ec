class User::CartsController < User::ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_delivery_schedule, only: [:edit_shipping_address, :update]

  rescue_from ActiveRecord::StaleObjectError do |exception|
    redirect_to edit_cart_path, alert: "他のパソコン/スマートフォンで#{Cart.model_name.human}の情報が変更されました。再度操作を実施してください。"
  end

  rescue_from ShouldRestartCartError do |error|
    begin
      logger.info "ShouldRestartCartError occured: #{ShouldRestartCartError.message}"
      current_user.cart.state = 'initial'
      current_user.cart.save!
    rescue StandardError => e
      logger.fatal(e.message)
      logger.fatal(e.backtrace)
    end
    redirect_to edit_cart_path, alert: error.message
  end

  def show
  end

  def show_complete
  end

  def edit
    unless @cart.purchase_products.any?
      flash.now.notice = "#{Cart.model_name.human}は空です"
    end
  end

  def edit_shipping_address
    if @cart.ref_shipping_address.nil? && current_user.shipping_address.available?
      @cart.ref_shipping_address = true
    end
  end

  def update
    if params[:fix_products].present?
      if @cart.fix_products(params.require(:cart)[:lock_version])
        redirect_to edit_shipping_address_cart_path
      else
        render :edit # TODO:
      end

    elsif params[:fix_shipping_address].present?
      args = params.require(:cart).permit(
        :ref_shipping_address, :save_shipping_address, :delivery_scheduled_date, :delivery_scheduled_time, :lock_version,
        shipping_address_attributes: [:id, :name, :postal_code, :prefecture, :city, :address, :building]).to_unsafe_hash.symbolize_keys
      if @cart.fix_shipping_address(**args)
        redirect_to cart_path
      else
        render :edit_shipping_address
      end

    elsif params[:purchase].present?
      if @cart.purchase(params.require(:cart)[:lock_version])
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

  def set_delivery_schedule
    @delivery_schedule = DeliverySchedule.new
  end
end
