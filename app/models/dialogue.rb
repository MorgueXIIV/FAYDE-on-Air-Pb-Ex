class Dialogue < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :actor
  has_many :parents,  :foreign_key => 'destination_id',
                       :class_name => 'DialogueLink',
                       :dependent => :destroy
  has_many :origin,     :through => :parents
  has_many :children,   :foreign_key => 'origin_id',
                       :class_name => 'DialogueLink',
                       :dependent => :destroy
  has_many :destination, :through => :children

  def searchText(query)
    return Dialogue.where("dialoguetext LIKE ?", "%" + query + "%")
  end

  def showShort
    return "#{actor.name}: #{dialoguetext}"
  end

end