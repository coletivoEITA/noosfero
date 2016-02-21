class MailingSent < ApplicationRecord

  belongs_to :mailing
  belongs_to :person

end
