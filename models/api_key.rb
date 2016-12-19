class ApiKey
    include Mongoid::Document
    include ActiveModel::Validations

    validates :key, uniqueness: true

    field :key, type: String
    belongs_to :user, optional: true
end