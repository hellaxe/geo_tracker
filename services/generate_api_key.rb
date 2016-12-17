class GenerateApiKey
    def self.call(user)
        remove_old_key(user)
        
        user.api_key = ApiKey.create(key: SecureRandom.hex)
    end

    private

    def self.remove_old_key(user)
        if user.api_key.present?
            user.api_key.destroy
        end
    end
end