# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SiteController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'accounts').to route_to('accounts#index')
    end
  end
end