require File.expand_path '../../spec_helper.rb', __FILE__

describe ApiKey do
    it 'creates key with uniq token only' do
        key = create(:bob_key)

        another_key = ApiKey.new(key: key.key)

        expect(another_key.save).to eq(false)

        another_key.key += '123'
        expect(another_key.save).to eq(true)
    end
end