class MembersBlock < PeopleBlockBase
  settings_items :show_join_leave_button, :type => :boolean, :default => false
  settings_items :visible_role, :type => :string, :default => nil
  attr_accessible :show_join_leave_button, :visible_role

  def self.description
    _('Members')
  end

  def help
    _('Clicking a member takes you to his/her homepage')
  end

  def default_title
    title = role ? role.name : n_('members')
    _('{#} %s') % title
  end

  def profiles
    role ? owner.members.with_role(role.id) : owner.members
  end

  def footer
    profile = self.owner
    role_key = visible_role
    s = show_join_leave_button
    proc do
      render :file => 'blocks/members', :locals => { :profile => profile, :show_join_leave_button => s, :role_key => role_key}
    end
  end

  def role
    visible_role && !visible_role.empty? ? Role.find_by_key_and_environment_id(visible_role, owner.environment) : nil
  end

  def roles
    Profile::Roles.organization_member_roles(owner.environment)
  end

  def extra_option
    data = {
      :human_name => _("Show join leave button"),
      :name => 'block[show_join_leave_button]',
      :value => true,
      :checked => show_join_leave_button,
      :options => {}
    }
  end

end
