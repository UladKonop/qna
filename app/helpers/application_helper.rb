module ApplicationHelper
  def absolute_url_for(url)
    url.include?('http') ? url : "//#{url}"
  end
end
