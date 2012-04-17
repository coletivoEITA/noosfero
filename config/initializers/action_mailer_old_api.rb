# monkey patch for rails 3.1 ActionMailer::OldApi

class ActionMailer::Base
  def body(variables)
    variables.each{ |k,v| instance_variable_set("@#{k}", v) }
  end
end
