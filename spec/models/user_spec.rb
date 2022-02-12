# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'presence' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
end