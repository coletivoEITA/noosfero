module AccountHelper

  def validation_classes
    'available unavailable valid invalid checking'
  end

  def checking_message(key)
    case key
    when :url then
      _('Checking availability of login name...')
    when :email then
      _('Checking if e-mail address is already taken...')
    end
  end
end
