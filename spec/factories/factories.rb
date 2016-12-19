FactoryGirl.define do
    factory :driver_bob, class: Driver do
        username    "Bob"
    end

    factory :driver_john, class: Driver do
        username    "John"
    end

    factory :manager_alice, class: Manager do
        username    "Alice"
    end

    factory :manager_craig, class: Manager do
        username    "Craig"
    end

    factory :bob_key, class: ApiKey do
        key         "qwe123"
        association :user, factory: :driver_bob
    end

    factory :john_key, class: ApiKey do
        key         "asd123"
        association :user, factory: :driver_john
    end

    factory :alice_key, class: ApiKey do
        key         "dsa123"
        association :user, factory: :manager_alice
    end

    factory :craig_key, class: ApiKey do
        key         "ewq123"
        association :user, factory: :manager_craig
    end

    factory :new_task, class: Task do
        title       'Task Title'
        description 'Task Description'
        pickup_location [90, 90]
        delivery_location [27, 53]
        association :manager, factory: :manager_alice
    end

    factory :assigned_bob_task, class: Task do
        title       'Task Title'
        description 'Task Description'
        pickup_location [90, 90]
        delivery_location [27, 53]
        
        association :manager, factory: :manager_alice
        association :driver, factory: :driver_bob
        status      'assigned'
    end
end
