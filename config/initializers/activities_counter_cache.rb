if Delayed::Backend::ActiveRecord::Job.table_exists?
  job = Delayed::Backend::ActiveRecord::Job.all :conditions => ['handler LIKE ?', "%ActivitiesCounterCacheJob%"]
  if job.blank?
    Delayed::Backend::ActiveRecord::Job.enqueue(ActivitiesCounterCacheJob.new, {:priority => -3})
  end
end
