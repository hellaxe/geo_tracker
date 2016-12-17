class GeoTrackerApp < Sinatra::Base
    get "/" do
        "It Works"
        # User.create(username: 'hell')
        
        User.all.to_json
    end
end