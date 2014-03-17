require 'net/imap'

class EmailPlugin::ImapAccount < EmailPlugin::Account

  set_table_name :email_plugin_accounts

  def fetch label
    imap = Net::IMAP.new self.host, self.port, true
    imap.login self.username, self.password

    imap.select label
    uids = imap.uid_sort ['FROM'], ['ALL'], 'UTF-8'
    uids.reverse!

    uids.each do |uid|
      message_id_query = "BODY[HEADER.FIELDS (MESSAGE-ID)]"
      data = imap.uid_fetch(uid, message_id_query)[0].attr[message_id_query]
      message_id = TMail::Mail.parse(data).message_id

      # search all the database for that message, another user may have that too
      message = EmailPlugin::Message.find_by_identifier message_id
      next if message.present?

      email = imap.uid_fetch(uid, "RFC822")[0].attr["RFC822"]
      message = MailFetcher.receive email

      self.group_messages message.to_a
    end

    imap.logout
    imap.disconnect
  end

end
