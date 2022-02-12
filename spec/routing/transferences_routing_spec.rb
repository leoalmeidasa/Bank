# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferenceController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'transactions').to route_to('transactions#index')
    end
  end
end