class DeviseParentController < ActionController::Base

  private

  def after_sign_out_path_for(resource_or_scope)
    logger.debug{ "after_sign_out_path_for resource_or_scope=#{resource_or_scope}"}
    # オーバーライドされるメソッドの引数名は resource_or_scope となっているが、その説明文にはシンボルしか渡されない、と書いてある。モデルオブジェクトが渡されることはない。
    # "this method receives a symbol with the scope, and not the resource"
    if resource_or_scope == :admin
      new_admin_session_path
    else
      root_path
    end
  end
end
