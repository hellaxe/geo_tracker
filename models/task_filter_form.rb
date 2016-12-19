class TaskFilterForm
    include Mongoid::Document

    field :loc, type: Array, default: []
    field :limit, type: Integer, default: 5

    validate :location_is_present
    validates :limit, numericality: { only_integer: true, 
        greater_than_or_equal_to: 0, 
        lesser_than_or_equal_to: 10 }

    def location_is_present
        unless self.loc.length == 2
            errors.add(:loc, 'should contain lat and long as [x, y]')
        end
    end

    def search
        chain = Task.new_tasks
        if loc.present?
            chain = chain.near(pickup_location: self.loc.map(&:to_f))
        end

        chain.limit(self.limit)
    end


end