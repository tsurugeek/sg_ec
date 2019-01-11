module ApplicationHelper
  def nav_item item_name, path, active_controller_names
    is_active = active_controller_names.include?(controller_name)

    tag.li class: "#{"active" if is_active}" do |li|
      concat li.a(item_name, href: path, class: "nav-link")
      concat li.span("(current)", class: "sr-only") if is_active
    end
  end

  def referer
    request.headers[:HTTP_TURBOLINKS_REFERRER]
  end
end
