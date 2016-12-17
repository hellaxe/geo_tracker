require File.expand_path '../../spec_helper.rb', __FILE__

describe User do
    it 'works' do
        u = User.create(username: 'hell')
        expect(User.count).to eq(1)
    end
end