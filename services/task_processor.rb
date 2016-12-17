class TaskProcessor
    def self.assign(task, driver)
        raise AlreadyAssignedError unless task.status == 'new'

        task.driver = driver
        task.status = 'assigned'

        task.save
    end

    def self.finish(task)
        task.status = 'finished'

        task.save
    end
end