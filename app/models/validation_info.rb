class ValidationInfo < ActiveRecord::Base

  attr_accessible :validation_methodology, :restrictions, :organization

  belongs_to :organization

  validates_presence_of :organization
  validates_presence_of :validation_methodology

end
