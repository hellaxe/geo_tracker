class GenerateApiKey
    class << self
        def call(user)
            remove_old_key(user)
            
            user.api_key = ApiKey.create(key: SecureRandom.hex)
        end

        private
        def remove_old_key(user)
            if user.api_key.present?
                user.api_key.destroy
            end
        end
    end
end