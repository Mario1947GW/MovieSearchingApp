FactoryBot.define do
  factory :user_list_item do
    association :user_list
    sequence(:item_id) { |n| n }
    item_type { 'movie' }
  end
end
