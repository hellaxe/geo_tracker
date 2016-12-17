class User
    include Mongoid::Document

    field :username, type: String
end