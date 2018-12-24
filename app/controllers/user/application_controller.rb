class User::ApplicationController < ApplicationController
  before_action :store_user_location!, if: :storable_location?

  private

  # ログイン後、元々リクエストのあったベージに移動するための設定
  # see: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_out_path_for(resource_or_scope)
    logger.debug{ "after_sign_out_path_for resource_or_scope=#{resource_or_scope}"}
    # オーバーライドしているメソッドの引数名は resource_or_scope となっているが、その説明文にはシンボルしか渡されない、と書いてある。
    # "this method receives a symbol with the scope, and not the resource"
    if resource_or_scope == :admin
      new_admin_session_path
    else
      root_path
    end
  end
end
