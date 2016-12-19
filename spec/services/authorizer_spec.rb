require File.expand_path '../../spec_helper.rb', __FILE__

describe Authorizer do
    context 'invalid key' do
        it 'raises NotAuthorizedError when no key present' do
            expect { Authorizer.call(nil) }.to raise_error(NotAuthorizedError)
        end

        it 'raises NotAuthorizedError when invalid key present' do
            invalid_key = 'qwer323123123dfcad'
            expect { Authorizer.call(invalid_key) }.to raise_error(NotAuthorizedError)
        end
    end

    context 'driver key' do
        before(:each) do
            @key_instance = create(:bob_key)
            @key = @key_instance.key
        end

        it 'authorizes driver' do
            expect { Authorizer.call(@key, :driver) }.to_not raise_error
            expect { Authorizer.call(@key, :driver, :manager) }.to_not raise_error
        end
        it 'raises NotAuthorizedError when auth for manager' do
            expect { Authorizer.call(@key, :manager) }.to raise_error(NotAuthorizedError) 
        end
    end

    context 'manager key' do
        before(:each) do
            @key_instance = create(:alice_key)
            @key = @key_instance.key
        end

        it 'authorizes manager' do
            expect { Authorizer.call(@key, :manager) }.to_not raise_error
            expect { Authorizer.call(@key, :driver, :manager) }.to_not raise_error
        end

        it 'raises NotAuthorizedError when auth for driver' do
            expect { Authorizer.call(@key, :driver) }.to raise_error(NotAuthorizedError) 
        end
    end

    context 'any key' do
        it 'authorizes key without role specification' do
            @key_instance = create(:alice_key)
            @key = @key_instance.key

            @key_instance = create(:john_key)
            @another_key = @key_instance.key


            expect { Authorizer.call(@key) }.to_not raise_error
            expect { Authorizer.call(@another_key) }.to_not raise_error
        end
    end
    
end