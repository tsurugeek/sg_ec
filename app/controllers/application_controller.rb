class ApplicationController < ActionController::Base

  private

  # ログイン成功後、元々リクエストのあったベージに移動したいので、そのページのURLを保存すべきかどうか判定する
  # see: https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def logger_error e
    logger.error "#{e.message}, #{e.backtrace}"
  end

  def js_redirect_to path
    render partial: 'shared/redirect', locals: {location: path}, formats: 'js'
  end
end
