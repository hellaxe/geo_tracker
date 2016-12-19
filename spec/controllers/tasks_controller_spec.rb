require File.expand_path '../../spec_helper.rb', __FILE__

describe GeoTrackerApp do
    before(:all) do
        @headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end

    context 'GET /api/tasks' do
        it 'returns tasks for manager' do
            task = create(:new_task)
            key = GenerateApiKey.call(task.manager)
            json_params = { api_key: key.key }
            
            response = get '/api/tasks', json_params , @headers
            
            data = JSON.parse(response.body)

            expect(data).not_to be_empty
        end

        it 'returns tasks for driver' do
            key = create(:bob_key)
            json_params = { api_key: key.key }
            
            response = get '/api/tasks', json_params , @headers
            
            data = JSON.parse(response.body)

            expect(data).to be_empty
        end
    end

    context 'POST /api/tasks' do
        it 'creates task for manager' do
            task_params = {title: 'Test title', description: 'Test description', pickup_location: [1, 23], delivery_location: [0, 0]}
            key = create(:alice_key).key

            response = post '/api/tasks', { api_key: key, task: task_params }.to_json, @headers
            expect(response.status).to eq(200)

            data = JSON.parse(response.body)
            
            expect(data).to have_key('_id')
            expect(data).to have_key('title')
            expect(data).to have_key('description')
        end

        it 'returns 500 and errors if task data invalid' do
            task_params = {title: 'Test', description: 'Test description', pickup_location: [1, 23], delivery_location: [0, 0]}
            key = create(:alice_key).key

            response = post '/api/tasks', { api_key: key, task: task_params }.to_json, @headers
            expect(response.status).to eq(500)

            data = JSON.parse(response.body)

            expect(data).to have_key('errors')
            expect(data['errors']).to have_key('task')
        end

        it 'returns 401 if wrong key present' do
            task_params = { title: 'Test', description: 'Test description', pickup_location: [1, 23], delivery_location: [0, 0]}
            key = create(:alice_key).key + 'eewq'

            response = post '/api/tasks', { api_key: key, task: task_params }.to_json, @headers

            expect(response.status).to eq(401)
            data = JSON.parse(response.body)

            expect(data).to have_key('errors')
            expect(data['errors']).to have_key('auth')
        end
        
    end

    context 'GET /api/tasks/nearest' do
        it 'returns 401 for manager' do
            json_params = { api_key: create(:alice_key).key, form: {loc: [1,2]} }
            
            response = get '/api/tasks/nearest', json_params , @headers
            expect(response.status).to eq(401)
            
            data = JSON.parse(response.body)

            expect(data).to have_key('errors')
            expect(data['errors']).to have_key('auth')
        end

        it 'returns new tasks for driver' do 
            create(:new_task)
            create(:new_task, pickup_location: [1, 2])
            create(:new_task, pickup_location: [13, 21])
            json_params = { api_key: create(:bob_key).key, form: {loc: [1,2]} }
            
            response = get '/api/tasks/nearest', json_params, @headers
            expect(response.status).to eq(200)
            
            data = JSON.parse(response.body)

            expect(data).not_to be_empty
            expect(data.map {|t| t['status']}).to all(eq 'new')
        end

        it 'limited by 5 tasks'  do
            create(:new_task)
            10.times { create(:new_task, pickup_location: [rand(20).to_f, rand(20).to_f])}

            json_params = { api_key: create(:bob_key).key, form: {loc: [1,2]} }
            response = get '/api/tasks/nearest', json_params, @headers

            expect(response.status).to eq(200)
            
            data = JSON.parse(response.body)

            expect(data).not_to be_empty
            expect(data.length).to be <= 5
        end

        it 'returns nearest tasks' do
            tasks = [create(:new_task)]
            tasks += 10.times.map { create(:new_task, pickup_location: [rand(20).to_f, rand(20).to_f])}
            current_location = [10.1,12.8]

            json_params = { api_key: create(:bob_key).key, form: { loc: current_location } }
            response = get '/api/tasks/nearest', json_params, @headers

            expect(response.status).to eq(200)
            
            data = JSON.parse(response.body)

            distances = data.map do |t| 
                dest = t['pickup_location']

                Math.sqrt((dest[0] - current_location[0]) ** 2 + (dest[1] - current_location[1]) ** 2)
            end

            expect(distances).to eq(distances.sort)
        end

    end

    context 'PATCH /api/tasks/:id/assign' do
        it 'returns 401 for manager' do
            json_params = { api_key: create(:alice_key).key }
            
            response = patch '/api/tasks/random_id/assign', json_params
            expect(response.status).to eq(401)
            
            data = JSON.parse(response.body)

            expect(data).to have_key('errors')
            expect(data['errors']).to have_key('auth')
        end

        it 'assigns task to driver' do
            task = create(:new_task)
            key_instance = create(:bob_key)
            json_params = { api_key: key_instance.key }

            response = patch "/api/tasks/#{task.id}/assign", json_params
            expect(response.status).to eq(204)
            task.reload

            expect(task.driver).to eq(key_instance.user)
            expect(task.status).to eq('assigned')
        end

        it 'returns 500 if task is not new' do
            task = create(:new_task)
            key_instance = create(:bob_key)
            json_params = { api_key: key_instance.key }

            response = patch "/api/tasks/#{task.id}/assign", json_params
            response = patch "/api/tasks/#{task.id}/assign", json_params
            expect(response.status).to eq(500)
        end
    end

    context 'PATCH /api/tasks/:id/finish' do
        it 'returns 401 for manager' do
            json_params = { api_key: create(:alice_key).key }
            
            response = patch '/api/tasks/random_id/finish', json_params
            expect(response.status).to eq(401)
            
            data = JSON.parse(response.body)

            expect(data).to have_key('errors')
            expect(data['errors']).to have_key('auth')
        end

        it 'finish task for driver' do
            task = create(:assigned_bob_task)
            key_instance = GenerateApiKey.call(task.driver)
            json_params = { api_key: key_instance.key }

            response = patch "/api/tasks/#{task.id}/finish", json_params
            expect(response.status).to eq(204)
            task.reload

            expect(task.driver).to eq(key_instance.user)
            expect(task.status).to eq('finished')
        end

        it 'returns 500 if task is not assigned' do
            task = create(:assigned_bob_task)
            key_instance = GenerateApiKey.call(task.driver)
            json_params = { api_key: key_instance.key }

            response = patch "/api/tasks/#{task.id}/finish", json_params
            response = patch "/api/tasks/#{task.id}/finish", json_params
            expect(response.status).to eq(500)
        end
    end
end