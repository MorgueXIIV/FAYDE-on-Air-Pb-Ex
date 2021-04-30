class DialogueLink < ActiveRecord::Base
  belongs_to :origin, :class_name => "Dialogue", counter_cache: :origins_count
  belongs_to :destination, :class_name => "Dialogue", counter_cache: :destinations_count
end