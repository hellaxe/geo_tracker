class GeoTrackerApp < Sinatra::Base

    get '/api/tasks' do
        with_rescue do
            Authorizer.call(@request_params['api_key'], :driver, :manager)
            find_user
            @user.tasks.to_json
        end
    end

    get '/api/tasks/nearest' do
        with_rescue do
            Authorizer.call(@request_params['api_key'], :driver)
            content_type :json
            
            form = TaskFilterForm.new(@request_params.fetch('form', {}))
            if form.valid?
                form.search.to_json
            else
                halt(500, { errors: { form: form.errors } }.to_json)
            end
        end
    end

    post '/api/tasks' do
        with_rescue do
            Authorizer.call(@request_params['api_key'], :manager)
            find_user

            task = Task.new(permitted_task_params)
            task.manager = @user

            if task.save
                task.to_json
            else
                halt(500, { errors: { task: task.errors } }.to_json)
            end
        end
    end

    patch '/api/tasks/:id/assign' do |id|
        with_rescue do
            Authorizer.call(@request_params['api_key'], :driver)
            find_user
            task = Task.new_tasks.find(id)
            
            TaskProcessor.assign(task, @user)
            status 204
        end
    end

    patch '/api/tasks/:id/finish' do |id|
        with_rescue do    
            Authorizer.call(@request_params['api_key'], :driver)
            find_user
            task = @user.tasks.assigned.find(id)
            
            TaskProcessor.finish(task, @user)
            status 204
        end
    end

    get '/api/tasks/:id' do |id|
        with_rescue do
            Authorizer.call(@request_params['api_key'], :driver, :manager)
            find_user

            @user.tasks.find(id).to_json
        end
    end

    def with_rescue(&block)
        pass unless request.accept? 'application/json'
        parse_request_data

        yield
    rescue NotAuthorizedError => e
        halt(401, { errors: { auth: e.message } }.to_json)
    rescue ImpossibleStateTransitionError => e
        halt(500, { errors: { task: e.message } }.to_json)
    end

    def find_user
        @user = ApiKey.find_by(key: @request_params['api_key']).user
    end

    def permitted_task_params
        @request_params.fetch('task', {}).select {|k, v| %w(title description 
            pickup_location delivery_location).include? k }
    end

    def parse_request_data
        request.body.rewind
        @request_params = params.merge(JSON.parse(request.body.read))

    rescue JSON::ParserError
        @request_params = params.dup
    end
end