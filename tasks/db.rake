namespace :db do

    task :seed do
        require 'ffaker'

        Driver.destroy_all
        Manager.destroy_all
        Task.destroy_all
        ApiKey.destroy_all

        10.times do 
            create_driver
        end

        3.times do 
            create_manager
        end

        30.times do
            create_task
        end
    end

    def create_driver
        driver = Driver.create(username: FFaker::Name.name)
        GenerateApiKey.call(driver)
    end

    def create_manager
        manager = Manager.create(username: FFaker::Name.name)
        GenerateApiKey.call(manager)
    end

    def create_task
        manager = Manager.all.to_a.sample

        Task.create(manager: manager, title: FFaker::Lorem.sentence, 
                    description: FFaker::Lorem.phrase, 
                    pickup_location: [FFaker::Geolocation.lat,FFaker::Geolocation.lng ],
                    delivery_location: [FFaker::Geolocation.lat,FFaker::Geolocation.lng ])
    end
end