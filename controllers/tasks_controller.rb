class GeoTrackerApp < Sinatra::Base

    get '/api/tasks' do
        with_rescue do
            Authorizer.call(params[:api_key], :driver, :manager)
            find_user
            @user.tasks.to_json
        end
    end

    get '/api/tasks/nearest' do
        with_rescue do
            Authorizer.call(params[:api_key], :driver)

            Task.new_tasks.to_a.to_json
        end
    end

    # Dev Only action
    get '/api/tasks/create' do
        with_rescue do
            Task.create(manager: Manager.first)
        end
    end

    get '/api/tasks/:id/assign' do |id|
        with_rescue do
            Authorizer.call(params[:api_key], :driver)
            find_user
            task = Task.new_tasks.find(id)
            
            TaskProcessor.assign(task, @user)
        end
    end

    get '/api/tasks/:id/finish' do |id|
        with_rescue do
            Authorizer.call(params[:api_key], :driver)
            find_user
            binding.pry
            task = @user.tasks.assigned.find(id)
            
            TaskProcessor.finish(task)
        end
    end

    get '/api/tasks/:id' do |id|
        with_rescue do
            Authorizer.call(params[:api_key], :driver, :manager)
            find_user

            @user.tasks.find(id).to_json
        end
    end

    def with_rescue(&block)
        yield
    rescue NotAuthorizedError => e
        { message: e.message }.to_json
    rescue AlreadyAssignedError => e
        { message: e.message }.to_json
    end

    def find_user
        @user = ApiKey.find_by(key: params[:api_key]).user
    end
end