require 'rails_helper'

describe Limit do
  describe '#increment!' do
    it 'increments the number of hits' do
      limit = Limit.create(key: 'abc1234', hits: 5)

      expect { limit.increment! }
        .to change { limit.reload ; limit.hits }
        .from(5).to(6)
    end
  end
end
