class GeoTrackerApp < Sinatra::Base
    get "/" do
        drivers = Driver.all.to_a
        managers = Manager.all.to_a
        { 
            managers: managers.map {|m| {key: m.api_key.key, tasks: m.tasks.count} },
            drivers: drivers.map {|d| {key: d.api_key.key, tasks: d.tasks.count} },
        }.to_json

    end

    get '/tasks' do
        Task.all.to_a.to_json
    end
end