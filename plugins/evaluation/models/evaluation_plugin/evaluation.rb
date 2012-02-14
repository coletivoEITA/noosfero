class EvaluationPlugin::Evaluation < Noosfero::Plugin::ActiveRecord
  belongs_to :evaluation, :polymorphic => true

  validates_presence_of :evaluation_type
  validates_presence_of :evaluation_id

end
