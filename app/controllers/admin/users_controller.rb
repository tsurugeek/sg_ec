class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to [:admin, @user], notice: I18n.t('messages.updated')
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: I18n.t('messages.destroyed')
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(shipping_address_attributes: [:id, :name, :postal_code, :prefecture, :city, :address, :building])
    end
end
