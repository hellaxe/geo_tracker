class ApiKey
    include Mongoid::Document

    field :key, type: String
    belongs_to :user
end