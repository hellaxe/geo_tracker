class Driver < User
    def tasks
        Task.where(driver_id: self.id)
    end
end