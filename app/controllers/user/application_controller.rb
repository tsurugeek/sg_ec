class User::ApplicationController < ApplicationController
  before_action :store_user_location!, if: :storable_location?

  private

  # ログイン後、元々リクエストのあったベージに移動するための設定
  # see: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
