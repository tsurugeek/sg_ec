# ショッピングカートの処理を最初からしなくてはならないエラー
class ShouldRestartCartError < StandardError
  def initialize message
    super message
  end
end
