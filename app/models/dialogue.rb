class Dialogue < ActiveRecord::Base
  belongs_to :conversation
  has_many :parents,  :foreign_key => 'origin_id',
                       :class_name => 'Dialogue_Link',
                       :dependent => :destroy
  has_many :origin,     :through => :parents
  has_many :children,   :foreign_key => 'destination_id',
                       :class_name => 'Dialogue_Link',
                       :dependent => :destroy
  has_many :destination, :through => :children
end
class DialogueLink < ActiveRecord::Base
  belongs_to :origin, :class_name => "Dialogue"
  belongs_to :destination, :class_name => "Dialogue"
end

