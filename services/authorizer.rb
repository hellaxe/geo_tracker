class Authorizer
    def self.call(api_key, *roles)
        key = ApiKey.find_by(key: api_key)
        
        raise NotAuthorizedError, 'API Key does not exists' if key.nil?

        if roles.present?
            user = key.user
            authorized = roles.select do |role|
                user._type == role.to_s.classify
            end.any?

            raise NotAuthorizedError.new('Forbidden action for this key') unless authorized
        end
    end
end