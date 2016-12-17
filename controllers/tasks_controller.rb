class GeoTrackerApp < Sinatra::Base

    get '/api/tasks' do
        with_rescue do
            parse_json_body
            Authorizer.call(@json_body[:api_key], :driver, :manager)
            find_user
            @user.tasks.to_json
        end
    end

    get '/api/tasks/nearest' do
        with_rescue do
            parse_json_body
            Authorizer.call(@json_body[:api_key], :driver)
            content_type :json
            Task.new_tasks.near(pickup_location: @json_body[:loc]).limit(5).to_a.to_json
        end
    end

    post '/api/tasks' do
        with_rescue do
            parse_json_body
            Authorizer.call(@json_body[:api_key], :manager)
            find_user
            task = Task.new(@json_body[:task])
            task.manager = @user

            task.save
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
        @user = ApiKey.find_by(key: @json_body[:api_key]).user
    end

    def parse_json_body
        request.body.rewind
        @json_body = JSON.parse(request.body.read).symbolize_keys
    end
end