class CmsLearningPluginLearning < Article

  settings_items :summary, :type => :string, :default => ""
  settings_items :good_practices, :type => :string, :default => ""

  has_many :resources, :foreign_key => 'article_id', :order => 'id asc', :class_name => 'ArticleResource', :dependent => :destroy
  has_many :resources_product_categories, :foreign_key => 'article_id', :order => 'id asc', :class_name => 'ArticleResource',
    :conditions => ['article_resources.resource_type = ?', 'ProductCategory']

  has_many :product_categories, :through => :resources, :source => :product_category, :foreign_key => 'article_id', :readonly => true,
    :class_name => 'ProductCategory', :conditions => ['article_resources.resource_type = ?', 'ProductCategory']
  def kinds
    CmsLearningPlugin.learning_field.values.all(:conditions => {:instance_id => self.id}, :order => 'id asc')
  end

  validates_presence_of :body
  validates_presence_of :summary
  validates_presence_of :good_practices

  attr_accessible :name, :body, :summary, :good_practices, :product_category_string_ids, :kind_option_contents

  def self.short_description
    _('Learning')
  end

  def self.description
    _('Share learnings to the network.')
  end

  def self.icon_name(article = nil)
    'cms-learning'
  end

  def self.type_name
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

  def product_category_string_ids
    ''
  end
  def product_category_string_ids=(ids)
    ids = ids.split(',')
    r = ProductCategory.find(ids)
    self.resources_product_categories.destroy_all
    @res_product_categories = ids.collect{ |id| r.detect{ |x| x.id == id.to_i } }.map do |pc|
      ArticleResource.new :resource_id => pc.id, :resource_type => ProductCategory.name
    end
  end

  def kind_option_contents
    ''
  end
  def kind_option_contents=(contents)
    contents = contents.split(',')
    field = CmsLearningPlugin.learning_field
    r = field.options.all :conditions => {:name => contents}
    kinds.each{ |k| k.destroy }
    options = contents.collect{ |c| r.detect{ |x| x.name == c } }
    @res_kinds = options.map do |o|
      FormerPluginValue.new :field => field, :option => o
    end
  end

  protected

  after_save :save_associated
  def save_associated
    @res_product_categories.each{ |c| c.article_id = self.id; c.save! } unless @res_product_categories.blank?
    @res_kinds.each{ |v| v.instance_id = self.id; v.save! } unless @res_kinds.blank?
  end

end
