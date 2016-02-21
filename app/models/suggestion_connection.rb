class SuggestionConnection < ApplicationRecord

  belongs_to :suggestion, :class_name => 'ProfileSuggestion', :foreign_key => 'suggestion_id'
  belongs_to :connection, :polymorphic => true

end
