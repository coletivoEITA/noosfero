module JavascriptHelper

  def link_to_function name, function, html_options={}

    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'

    content_tag :a, name, html_options.merge(href: href, onclick: onclick)
  end
end
