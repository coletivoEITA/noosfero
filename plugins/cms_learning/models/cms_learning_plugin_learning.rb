class CmsLearningPluginLearning < Article

  settings_items :summary, :type => :string, :default => ""
  settings_items :good_practices, :type => :string, :default => ""

  has_many :product_categories, :foreign_key => 'resource_id', :class_name => 'ProductCategory',
    :conditions => ['articles.resource_type = ?', 'ProductCategory'], :order => 'id asc'
  has_many :kinds, :foreign_key => 'resource_id', :class_name => 'ProductCategory',
    :conditions => ['articles.resource_type = ?', 'FormerPluginValue'], :order => 'id asc'

  def self.short_description
    _('Learning')
  end

  def self.description
      _('Share learnings to the network.')
  end

  def self.icon_name(article = nil)
    'learning'
  end

  def name
    _('Learning')
  end

  def to_html(options = {})
    lambda do
      @controller.append_view_path CmsLearningPlugin.view_path
      render :file => 'cms/cms_learning_plugin_page'
    end
  end

  def default_parent
    profile.articles.find_by_name _('Learnings'), :conditions => {:type => 'Folder'}
  end

  def use_media_panel?
    true
  end

  def tiny_mce?
    true
  end

  attr_accessible :product_category_string_ids
  def product_category_string_ids
    ''
  end
  def product_category_string_ids=(ids)
    ids = ids.split(',')
    r = ProductCategory.find(ids)
    self.product_categories = ids.collect {|id| r.detect {|x| x.id == id.to_i}}
    self.product_categories.update_all ['resource_type = ?', 'ProductCategory']
  end

  attr_accessible :kind_option_ids
  def kind_option_ids
    ''
  end
  def kind_option_ids=(ids)
    ids = ids.split(',')
    r = FormerPluginOptions.find(ids)
    self.kinds = ids.collect {|id| r.detect {|x| x.id == id.to_i}}
    self.kinds.update_all ['resource_type = ?', 'FormerPluginValue']
  end

end
