class Dialogue < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :actor, counter_cache: true
  has_many :alternates
  has_many :checks
  has_many :modifiers


  has_many :parents,  :foreign_key => 'destination_id',
                       :class_name => 'DialogueLink',
                       :dependent => :destroy
  has_many :origin,     :through => :parents
  has_many :children,   :foreign_key => 'origin_id',
                       :class_name => 'DialogueLink',
                       :dependent => :destroy
  has_many :destination, :through => :children

  # scope :blankHub, -> {where("dialoguetext = ?", 0)}
  # scope :notHub, -> {where("dialoguetext != ?", 0)}

  scope :saidBy, ->(actorID) { where("actor_id = ?", actorID) }
  scope :searchText, ->(query) { where("dialoguetext LIKE ?", "%" + query + "%") }

  scope :searchTexts, ->(query) do
    if query.length==1
      searchText(query.first)
    else
      quer1= query.pop
      searchTexter(query).where("dialoguetext LIKE ?", "%" + quer1 + "%")
    end
  end
  scope :searchTextsAct, ->(query, actor) do
    if query.length==1
      searchText(query.first).saidBy(actor)
    else
      quer1= query.pop
      searchTexter(query).where("dialoguetext LIKE ?", "%" + quer1 + "%")
    end
  end

  def showShort(addParentNamesToHubs=false)
    if isHub?
      shortName= "HUB: (#{actor.name})"
      shortName+=showDetails.join("/")
      if addParentNamesToHubs then
        shortName+="{Hub From: #{getLeastHubParentName}}" 
      else
        if shortName.length<12
          shortName+=title
        end
      end
      return shortName
    else
      return "#{actor.name}: #{dialoguetext}"
    end
  end

  def isHub?
    dialoguetext.length<2
  end

  def showDetails
    lomgpossinfo=[conditionstring,userscript,sequence]
    alternates.all.each{ |alt| lomgpossinfo.push(alt.showShort)} 
    lomgpossinfo=lomgpossinfo.reject{|info| info.nil? or info.length<2 }

    if difficultypass>0 then
      lomgpossinfo.unshift("passive check (estimate; requires #{difficultypass} in #{actor.name})")
    end

    # lomginfo=lomgpossinfo.join(": ")
    return lomgpossinfo
  end

  def getLeastHubParentName
    grandparentslist=[]
    greatgrandparentslist=[]
    if isHub?
      parents=origin
      parents.each do |parent|
        if not (parent.isHub?)
          return parent.title+"[1]"
        else
          grandparentslist+=parent.origin
        end
      end
      grandparentslist.each do |parent|
        if not parent.isHub?
          return parent.title+"[2]"
        else
          greatgrandparentslist+=parent.origin
        end
      end
      greatgrandparentslist.each do |parent|
        if not parent.isHub?
          return parent.title+"[3]"
        else
          greatgrandparentslist+=parent.origin
        end
      end
      # GIVE UP ?
      return "(no useful parent)"
    else
      return "(this isn't a hub)"
    end
  end

end