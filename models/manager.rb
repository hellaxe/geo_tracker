class Manager < User
    def tasks
        Task.where(manager_id: self.id)
    end
end