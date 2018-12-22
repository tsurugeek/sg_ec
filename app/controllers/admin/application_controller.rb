class Admin::ApplicationController < BaseApplicationController
  before_action :store_admin_location!, if: :storable_location?
  before_action :authenticate_admin!

  private

  # ログイン後、元々リクエストのあったベージに移動したいので、そのページのURLを保存するかどうか判定する
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  # ログイン後、元々リクエストのあったベージに移動するための設定
  # see: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
  def store_admin_location!
    store_location_for(:admin, request.fullpath)
  end
end
