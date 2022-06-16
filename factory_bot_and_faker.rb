# FactoryBot is commonly used to set up models for your test suite.
# Faker is commonly used to fill in test values for various things like URLs, numbers, strings,
# addresses, etc.
#
# This is example code lifted from my meal planning app:

# spec/factories/partnership.rb
FactoryBot.define do

  factory :partnership do
    website { Faker::Internet.url }
    referral_code { "#{SecureRandom.hex(6)}" }
  end

end

# spec/factories/cookbook.rb
FactorBot.define do 

  factory :cookbook do
    name { "#{Faker::Name.name}'s cookbook" }
    author { Faker::Name.name }
    purchase_url { Faker::Internet.url }
    partnership
  end

end

# app/models/partnership.rb
class Partnership < ApplicationRecord
  belongs_to :user, optional: true

  validates_presence_of :website, :referral_code
  validates_uniqueness_of :referral_code

  has_many :referred_users, class_name: 'User', foreign_key: :referred_by_id
  has_many :recipes

  def referred_premium_pass_users
    subscriptions.count
  end

  def subscriptions
    referred_users.select { |u| u.subscription.present? }.map(&:subscription)
  end

  def link_stripe_account(account_id)
    update!(connected_stripe_account_id: account_id)
    set_connected_account_to_monthly_payout_schedule
  end

  private

  def set_connected_account_to_monthly_payout_schedule
    Stripe::Account.update(
      connected_stripe_account_id,
      {
        settings: {
          payouts: { schedule: { interval: 'monthly', monthly_anchor: '1' } }
        }
      }
    )
  end
end

# spec/models/partnership_spec.rb
RSpec.describe Partnership, type: :model do
  it 'has a valid factory' do
    expect(build(:partnership)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { expect(build(:partnership)).to validate_presence_of(:website) }
    it { expect(build(:partnership)).to validate_presence_of(:referral_code) }
    it { expect(build(:partnership)).to validate_uniqueness_of(:referral_code) }
  end

  describe 'ActiveRecord associations' do
    it { expect(build(:partnership)).to belong_to(:user).optional }
    it do
      expect(build(:partnership)).to have_many(:referred_users).class_name(
        'User'
      ).with_foreign_key(:referred_by_id)
    end
    it { expect(build(:partnership)).to have_many(:recipes) }
  end

  describe 'public instance methods' do
    describe '#referred_premium_pass_users' do
      it 'returns the count of referred users who subscribe to premium pass' do
        partnership = create(:partnership)
        user_one = create(:user, referred_by: partnership)
        create(:subscription, user: user_one)
        user_two = create(:user, referred_by: partnership)
        create(:subscription, user: user_two)

        result = partnership.referred_premium_pass_users

        expect(result).to eq(2)
      end
    end

    describe '#subscriptions' do
      it 'returns a list of subscriptions' do
        partnership = create(:partnership)
        user_one = create(:user, referred_by: partnership)
        sub_one = create(:subscription, user: user_one)
        user_two = create(:user, referred_by: partnership)
        sub_two = create(:subscription, user: user_two)

        result = partnership.subscriptions

        expect(result).to eq([sub_one, sub_two])
      end
    end
  end
end


