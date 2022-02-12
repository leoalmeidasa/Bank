# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { build(:transaction) }

  describe "Associations" do
    it { should belong_to(:account) }
  end

  describe 'presence' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:transaction_type) }
  end
end