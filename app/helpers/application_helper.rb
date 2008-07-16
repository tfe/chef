# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # support pretty page titles (http://railscasts.com/episodes/30)
  def title(page_title)
    content_for(:title) { page_title }
  end

end
