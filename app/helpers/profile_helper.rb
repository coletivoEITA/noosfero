module ProfileHelper

  def display_field(title, profile, field, force = false)
    if !force && !profile.active_fields.include?(field.to_s)
      return ''
    end
    value = profile.send(field)
    if !value.blank?
      if block_given?
        value = yield(value)
      end
      content_tag('tr', content_tag('td', title, :class => 'field-name') + content_tag('td', value))
    else
      ''
    end
  end

  def render_tabs(tabs)
    titles = tabs.inject(''){ |result, tab| result << content_tag(:li, link_to(tab[:title], '#'+tab[:id]), :class => 'tab') }
    contents = tabs.inject(''){ |result, tab| result << content_tag(:div, tab[:content], :id => tab[:id]) }

    content_tag :div, :class => 'ui-tabs' do
      content_tag(:ul, titles) + contents
    end
  end

  def load_profile_badge
    @activities = @profile.tracked_actions.paginate(:per_page => 30, :page => params[:page])
    @wall_items = []
    @network_activities = !@profile.is_a?(Person) ? @profile.tracked_notifications.paginate(:per_page => 30, :page => params[:page]) : []
    if logged_in? && current_person.follows?(@profile)
      @network_activities = @profile.tracked_notifications.paginate(:per_page => 30, :page => params[:page]) if @network_activities.empty?
      @wall_items = @profile.scraps_received.not_replies.paginate(:per_page => 30, :page => params[:page])
    end
    @tags = @profile.article_tags

    # invisible profile is handled by needs_profile
    if !@profile.display_info_to?(user)
      private_profile
    end
  end

  def private_profile
    if @profile.person?
      @action = :add_friend
      @message = _("The content here is available to %s's friends only.") % profile.short_name
    else
      @action = :join
      @message = _('The contents in this community is available to members only.')
    end
    @no_design_blocks = true
  end

end
