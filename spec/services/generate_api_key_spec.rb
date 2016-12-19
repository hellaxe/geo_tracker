require File.expand_path '../../spec_helper.rb', __FILE__

describe GenerateApiKey do
    context 'method #call' do
        before(:each) do
            @old_key = create(:bob_key)
            @user = @old_key.user
        end
        
        it 'creates new key' do
            GenerateApiKey.call(@user)

            expect(@old_key).to_not eq(@user.api_key)
        end

        it 'removes old key' do
            GenerateApiKey.call(@user)

            expect(@old_key.persisted?).to be false
        end
    end

    context 'method #remove_old_key' do
        before(:each) do
            @key = create(:alice_key)
            @user = @key.user
        end

        it 'private method' do
            expect do 
                GenerateApiKey.remove_old_key(@user)
            end.to raise_error(NoMethodError)
        end

    end

end