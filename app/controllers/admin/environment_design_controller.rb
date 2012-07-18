class EnvironmentDesignController < BoxOrganizerController

  protect 'edit_environment_design', :environment

  protected

  def available_blocks
    @available_blocks ||= [ ArticleBlock, LoginBlock, EnvironmentStatisticsBlock, RecentDocumentsBlock, EnterprisesBlock, CommunitiesBlock, PeopleBlock, SellersSearchBlock, LinkListBlock, FeedReaderBlock, SlideshowBlock, HighlightsBlock, FeaturedProductsBlock, CategoriesBlock, RawHTMLBlock ]

    @available_blocks += @plugins.dispatch(:environment_blocks, environment) if @plugins
  end

end
