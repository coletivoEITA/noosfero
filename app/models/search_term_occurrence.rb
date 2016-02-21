class SearchTermOccurrence < ApplicationRecord

  belongs_to :search_term
  validates_presence_of :search_term

  EXPIRATION_TIME = 1.year

  scope :valid, -> { where "search_term_occurrences.created_at > ?", DateTime.now - EXPIRATION_TIME }

end
