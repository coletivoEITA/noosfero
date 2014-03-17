require 'iconv'

class EmailPlugin::Account < Noosfero::Plugin::ActiveRecord

  Utf8Ignore = Iconv.new 'UTF-8//IGNORE', 'UTF-8'
  AddressDump = proc{ |l| l.to_a.map{ |a| "#{a.name} <#{a.address}>" }.join(',') }

  belongs_to :profile

  has_many :conversations, :class_name => 'EmailPlugin::Conversation', :foreign_key => :owner_id

  validates_presence_of :profile

  def fetch label
    raise "Not implemented"
  end

  def group_messages messages
    messages.each do |message|
      if message.in_reply_to.blank?
        ref_message = nil
      elsif back_reference_message = self.profile.email_messages.find_by_in_reply_to(message.identifier)
        ref_message = back_reference_message
      elsif reference_message = self.profile.email_messages.find_by_identifier(message.in_reply_to)
        ref_message = reference_message
      end

      conversation = ref_message.conversations.profile(self.profile).first rescue nil
      conversation ||= self.conversations.create! :profile => self.profile, :owner => self, :title => message.subject
      conversation.messages << message

      # wordaround rails bug
      conversation['owner_type'] = self.class.name
      conversation.send :update_without_callbacks
    end
  end

  class MailFetcher < ActionMailer::Base
    def receive email
      EmailPlugin::Message.create! :identifier => email.message_id.to_s,
        :date => email.date,
        :from => AddressDump.call(email.from_addrs), :to => AddressDump.call(email.to_addrs),
        :cc => AddressDump.call(email.cc_addrs), :bcc => AddressDump.call(email.bcc_addrs),
        :subject => Utf8Ignore.iconv(email.subject),
        :body => Utf8Ignore.iconv(email.body), :content_type => email.content_type,
        :in_reply_to => email.in_reply_to
    end
  end

  # Load for development
  ImapAccount
end

