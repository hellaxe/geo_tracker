class Task
    include Mongoid::Document
    # include ActiveModel::Validations

    field :title, type: String
    field :description, type: String

    field :status, type: String, default: 'new'

    field :pickup_location, type: Array
    field :delivery_location, type: Array

    index({ pickup_location: "2d" }, { min: -200, max: 200 })

    belongs_to :driver, class_name: 'Driver', optional: true
    belongs_to :manager, class_name: 'Manager'

    def self.new_tasks
        self.where(status: 'new')
    end

    def self.assigned
        self.where(status: 'assigned')
    end
end