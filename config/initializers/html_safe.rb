# Disable Rails html autoescaping. This is due to noosfero using too much helpers/models to output html.
# It it would change too much code and make it hard to maintain.
class Object
  def html_safe?
    true
  end
end

