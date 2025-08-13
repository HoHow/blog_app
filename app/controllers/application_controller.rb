class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?
  # 目前登入的使用者
  # 如果使用者已經登入，則會回傳使用者物件，否則回傳 nil
  # 使用者登入後，會將使用者 id 儲存在 session 中
  # 在 controller 中，可以使用 current_user 來取得目前登入的使用者
  # 在 view 中，可以使用 current_user 來顯示目前登入的使用者
  # 在 model 中，可以使用 current_user 來取得目前登入的使用者
  # 在 helper 中，可以使用 current_user 來取得目前登入的使用者
  # 在 helper 中，可以使用 logged_in? 來判斷目前是否登入
  # 在 helper 中，可以使用 require_login 來判斷目前是否登入
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  # 目前是否登入
  # 如果使用者已經登入，則會回傳 true，否則回傳 false
  # 使用者登入後，會將使用者 id 儲存在 session 中
  # 在 controller 中，可以使用 logged_in? 來判斷目前是否登入
  # 在 view 中，可以使用 logged_in? 來判斷目前是否登入
  # 在 model 中，可以使用 logged_in? 來判斷目前是否登入
  # 在 helper 中，可以使用 logged_in? 來判斷目前是否登入
  def logged_in?
    current_user.present?
  end
  private
  # 要求使用者登入
  # 如果使用者未登入，則會重定向到登入頁面
  # 在 controller 中，可以使用 require_login 來要求使用者登入
  # 在 view 中，可以使用 require_login 來要求使用者登入
  # 在 model 中，可以使用 require_login 來要求使用者登入
  # 在 helper 中，可以使用 require_login 來要求使用者登入
  def require_login
    if !logged_in?
      redirect_to login_path, alert: "請先登入"
    end
  end
end
