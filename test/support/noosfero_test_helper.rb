module NoosferoTestHelper

  include ActionView::Helpers::TagHelper

  def params
    {}
  end

  def ui_icon(icon)
    icon
  end

  def will_paginate(arg1, arg2)
  end

  def check_box_tag(name, value = 1, checked = false, options = {})
    name
  end
  def stylesheet_link_tag(arg)
    arg
  end

  def strip_tags(html)
    html.gsub(/<[^>]+>/, '')
  end

  def icon_for_article(article)
    ''.html_safe
  end

end

