require_dependency 'person'

class Person
  acts_as_taggable_on :tags
  N_('Fields of interest')
end
