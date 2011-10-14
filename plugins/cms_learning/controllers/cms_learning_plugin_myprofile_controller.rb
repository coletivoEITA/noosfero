class CmsLearningPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  protect 'edit_profile', :profile

  def product_categories
    @categories = ProductCategory.all :limit => 20, :conditions => ["name ~* ?", params[:q]]
    respond_to do |format|
      format.html
      format.json { render :json => @categories.collect{ |i| {:id => i.id, :name => i.name } } }
    end
  end

  def kinds
    @kinds = CmsLearningPlugin.learning_field.options.all :limit => 20, :conditions => ["name ~* ?", params[:q]]
    respond_to do |format|
      format.html
      format.json { render :json => @kinds.collect{ |i| {:id => i.name, :name => i.name } } }
    end
  end

end

