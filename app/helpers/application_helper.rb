module ApplicationHelper
  # page title helper
  def full_title(page_title = '')
    base_title = "First App"
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
