class ProductsBlock < Block

  def self.description
    _('Products')
  end

  def default_title
    _('Products')
  end

  def help
    _('This block presents a list of your products.')
  end

  def content(args={})
    block = self
    lambda do
      render :file => 'blocks/products', :locals => {:block => block}
    end
  end

  def footer
    block = self
    lambda do
      link_to(_('View all products'), block.owner.public_profile_url.merge(:controller => 'catalog', :action => 'index'))
    end
  end

  settings_items :product_ids, Array
  def product_ids=(array)
    self.settings[:product_ids] = array
    if self.settings[:product_ids]
      self.settings[:product_ids] = self.settings[:product_ids].map(&:to_i)
    end
  end

  def products(reload = false)
    if product_ids.blank?
      products_list = owner.products(reload)
      result = []
      [4, products_list.size].min.times do
        p = products_list.rand
        result << p
        products_list -= [p]
      end
      result
    else
      product_ids.map {|item| owner.products.find(item) }
    end
  end

end
