class User::CartsController < User::ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_delivery_schedule, only: [:edit_shipping_address, :fix_shipping_address]
  before_action :check_external_changes_with_update, only: [:edit, :edit_shipping_address, :show]

  rescue_from ActiveRecord::StaleObjectError do |exception|
    redirect_to edit_cart_path, alert: I18n.t('activerecord.errors.messages.stale_object', record: Cart.model_name.human)
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
    if @cart.ref_shipping_address?
      # 保存した後、再度この画面に戻ってくると表示されてしまうので消しておく
      @cart.shipping_address.clear
    end
  end

  def fix_products
    if @cart.fix_products(params.require(:cart)[:lock_version])
      redirect_to edit_shipping_address_cart_path
    else
      # 画面に表示できるようなvalidationエラーは発生していないはず
      logger.error @cart.joined_messages
      redirect_to edit_cart_path, alert: "処理を続行できませんでした。しばらくしてから再度実施してください。"
    end
  end

  def fix_shipping_address
    args = params.require(:cart).permit(
      :ref_shipping_address, :save_shipping_address, :delivery_scheduled_date, :delivery_scheduled_time, :lock_version,
      shipping_address_attributes: [:id, :name, :postal_code, :prefecture, :city, :address, :building]).to_unsafe_hash.symbolize_keys
    if @cart.fix_shipping_address(**args)
      redirect_to cart_path
    else
      render :edit_shipping_address
    end
  end

  def purchase
    if @cart.purchase(params.require(:cart)[:lock_version])
      redirect_to show_complete_cart_path
    else
      # 画面に表示できるようなvalidationエラーは発生していないはず
      logger.error @cart.joined_messages
      redirect_to edit_shipping_address_cart_path, alert: "処理を続行できませんでした。しばらくしてから再度実施してください。"
    end
  rescue ShouldRestartCartError => e
    redirect_to edit_cart_path
  end

  private

  def set_cart
    @cart = current_user.cart
  end

  def set_delivery_schedule
    @delivery_schedule = DeliverySchedule.new
  end

  def check_external_changes_with_update
    @cart.check_external_changes(with_update: true)
  rescue ShouldRestartCartError => e
    begin
      logger.info "ShouldRestartCartError occured: #{e.message}"
      flash.now[:alert] = e.message
    rescue StandardError => e
      logger.fatal(e.message)
      logger.fatal(e.backtrace)
    end
  end
end
