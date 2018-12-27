module ApplicationHelper
  # def nav_active?(name)
  #   controller_name == name
  # end

  def nav_item item_name, path, active_controller_name
    is_active = active_controller_name == controller_name

    tag.li class: "nav-item #{"active" if is_active}" do |li|
      concat li.a(item_name, href: path, class: "nav-link")
      concat li.span("(current)", class: "sr-only") if is_active
    end
  end
end
