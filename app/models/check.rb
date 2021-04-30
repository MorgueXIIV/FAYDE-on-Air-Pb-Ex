class Check < ApplicationRecord
  belongs_to :dialogue, counter_cache: true
end
