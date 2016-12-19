require File.expand_path '../../spec_helper.rb', __FILE__

describe Task do
    it 'requires manager' do
        task = build(:new_task, manager: nil)
        expect(task.save).to be false

        expect(task.errors).to have_key(:manager)
    end

    it 'requires driver when assigned or finished' do
        task = build(:assigned_bob_task, driver: nil)
        expect(task.save).to be false
        expect(task.errors).to have_key(:driver)

        task.status = 'finished'
        expect(task.save).to be false
        expect(task.errors).to have_key(:driver)
    end

    it 'requires title' do
        task = build(:new_task, title: '')

        expect(task.save).to be false
        expect(task.errors).to have_key(:title)
    end

    it 'requires description' do
        task = build(:new_task, description: '')

        expect(task.save).to be false
        expect(task.errors).to have_key(:description)
    end

    it 'requires title between 10 and 100 symbols' do
        too_small = 'h'
        too_long = 'h' * 101
        valid = 'h' * 100
        task = build(:new_task, title: too_small)

        expect(task.save).to be false
        expect(task.errors).to have_key(:title)        

        task.title = too_long

        expect(task.save).to be false
        expect(task.errors).to have_key(:title)

        task.title = valid
        expect(task.save).to be true
    end

    it 'requires description between 10 and 1000 symbols' do
        too_small = 'h'
        too_long = 'h' * 1001
        valid = 'h' * 10
        task = build(:new_task, description: too_small)

        expect(task.save).to be false
        expect(task.errors).to have_key(:description)

        task.description = too_long

        expect(task.save).to be false
        expect(task.errors).to have_key(:description)

        task.description = valid
        expect(task.save).to be true
    end
end