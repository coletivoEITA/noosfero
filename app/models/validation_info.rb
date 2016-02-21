class ValidationInfo < ApplicationRecord

  belongs_to :organization

  validates_presence_of :organization
  validates_presence_of :validation_methodology

  xss_terminate :only => [ :validation_methodology, :restrictions ], :on => 'validation'
end
