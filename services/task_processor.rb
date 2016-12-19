class TaskProcessor

    class << self
        def assign(task, driver)
            raise ImpossibleStateTransitionError if !driver.present? || !task.present?
            raise ImpossibleStateTransitionError unless task.status == 'new'

            task.driver = driver
            task.status = 'assigned'

            task.save
        end

        def finish(task, driver)
            raise ImpossibleStateTransitionError if !driver.present? || !task.present?
            
            if task.status != 'assigned' || task.driver_id != driver.id
                raise ImpossibleStateTransitionError
            end


            task.status = 'finished'

            task.save
        end
    end
    
end