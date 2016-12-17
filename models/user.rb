class User
    include Mongoid::Document

    field :username, type: String

    has_one :api_key

    def driver?
        self._type == 'Driver'
    end

    def manager?
        self._type == 'Manager'
    end
end