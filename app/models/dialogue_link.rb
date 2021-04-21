class DialogueLink < ActiveRecord::Base
  belongs_to :origin, :class_name => "Dialogue"
  belongs_to :destination, :class_name => "Dialogue"
end