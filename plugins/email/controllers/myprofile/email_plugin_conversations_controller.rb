class EmailPluginConversationsController < MyProfileController

  no_design_blocks

  def index
    @conversations = profile.email_conversations.paginate :page => params[:page], :per_page => 25
    hash = {}; @conversations.each do |conversation|
      hash[conversation.id] = {
        :id => conversation.id,
        :read => conversation.read_at.present?, :from => conversation.from, :subject => conversation.title, :date => conversation.date,
        :messages => (conversation.messages.map do |message|
          {
            :id => message.id,
            :from => message.from, :to => message.to, :date => message.human_date,
            :body => message.body,
          }
        end),
      }
    end
    render :json => hash
  end

end
