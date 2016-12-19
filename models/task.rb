class Task
    include Mongoid::Document
    # include ActiveModel::Validations

    field :title, type: String
    field :description, type: String

    field :status, type: String, default: 'new'

    field :pickup_location, type: Array, default: []
    field :delivery_location, type: Array, default: []

    index({ pickup_location: "2d" }, { min: -200, max: 200, background: true })

    belongs_to :driver, class_name: 'Driver', optional: true
    belongs_to :manager, class_name: 'Manager'

    validates :driver, presence: true, if: Proc.new { |t| t.status != 'new' }
    validates :title, presence: true, length: { maximum: 100, minimum: 10 }
    validates :description, presence: true, length: { maximum: 1000, minimum: 10 }
    validate :locations_are_present

    def self.new_tasks
        self.where(status: 'new')
    end

    def self.assigned
        self.where(status: 'assigned')
    end

    def locations_are_present
        unless self.pickup_location.length == 2
            errors.add(:pickup_location, 'should contain lat and long as [x, y]')
        end

        unless self.delivery_location.length == 2
            errors.add(:delivery_location, 'should contain lat and long as [x, y]')
        end
    end
end