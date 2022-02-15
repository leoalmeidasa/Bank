# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { build(:account) }

  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe 'presence' do
    it { should validate_presence_of(:balance) }
    it { should validate_presence_of(:account_number) }
  end
end