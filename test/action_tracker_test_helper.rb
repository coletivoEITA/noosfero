module ActionTracker
  class Record
    def back_in_time(time = 25.hours)
      self.updated_at = Time.now.ago(time)
      self.send :update_without_callbacks
      self
    end
  end
end
