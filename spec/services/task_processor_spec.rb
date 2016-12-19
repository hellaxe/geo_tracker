require File.expand_path '../../spec_helper.rb', __FILE__

describe TaskProcessor do
    context 'method #assign' do
        it 'assigns task' do
            driver = create(:bob_key).user
            task = create(:new_task)
            TaskProcessor.assign(task, driver)
            expect(task.driver).to eq(driver)
            expect(task.status).to eq('assigned')
        end

        it 'raises an error when no driver present' do
            task = create(:new_task)
            expect do 
                TaskProcessor.assign(task, nil)
            end.to raise_error(ImpossibleStateTransitionError)
        end

        it 'raises an error when task is not new' do
            driver = create(:john_key).user
            assigned_task = create(:assigned_bob_task)
            
            expect do
                TaskProcessor.assign(assigned_task, driver)
            end.to raise_error(ImpossibleStateTransitionError)
        end
    end

    context 'method #finish' do
        it 'finish task' do
            assigned_task = create(:assigned_bob_task)
            driver = assigned_task.driver

            expect do
                TaskProcessor.finish(assigned_task, driver)
            end.to_not raise_error

            expect(assigned_task.status).to eq('finished')
        end

        it 'raises an error when task is not assigned' do
            task = create(:new_task)
            driver = create(:driver_bob)

            expect do
                TaskProcessor.finish(task, driver)
            end.to raise_error(ImpossibleStateTransitionError)
        end

        it 'raises an error when driver is not present' do
            assigned_task = create(:assigned_bob_task)

            expect do
                TaskProcessor.finish(assigned_task, nil)
            end.to raise_error(ImpossibleStateTransitionError)
        end

        it 'raises an error when task assigned to another driver' do
            assigned_task = create(:assigned_bob_task)
            another_driver = create(:driver_john)

            expect do
                TaskProcessor.finish(assigned_task, another_driver)
            end.to raise_error(ImpossibleStateTransitionError)
        end
    end
end