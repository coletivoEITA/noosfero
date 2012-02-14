class EvaluationPlugin::Evaluation < Noosfero::Plugin::ActiveRecord
  belongs_to :evaluation, :polymorphic => true
  belongs_to :evaluator, :class_name => "Profile"
  belongs_to :evaluated, :class_name => "Profile"
 
  validates_presence_of :evaluation_type
  validates_presence_of :evaluation_id

end
