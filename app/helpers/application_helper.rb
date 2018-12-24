module ApplicationHelper
  def nav_active?(name)
    controller_name == name
  end
end
