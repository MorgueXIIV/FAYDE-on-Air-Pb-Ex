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

  scope :isHub, -> {where("length(dialoguetext) = ?", 0)}
  scope :notHub, -> {where("length(dialoguetext) > ?", 1)}

  scope :saidBy, ->(actorID) { where("actor_id = ?", actorID) }
  # scope :saidByNamePart

  #single word/phrase search text
  scope :searchText, ->(query) { where("dialoguetext LIKE ?", "%" + query + "%") }

  scope :searchTexts, ->(query) do
    if query.length==1
      searchText(query.first)
    else
      quer1= query.pop
      searchTexts(query).where("dialoguetext LIKE ?", "%" + quer1 + "%")
    end
  end

  scope :searchTextsAct, ->(query, actor) do
    if query.length==1
      searchText(query.first).saidBy(actor)
    else
      quer1= query.pop
      searchTextsAct(query, actor).where("dialoguetext LIKE ?", "%" + quer1 + "%")
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
    return dialoguetext.length<1
  end

  def showDetails
    lomgpossinfo=[conditionstring,userscript,sequence]
    if alternates_count > 0
      alternates.all.each{ |alt| lomgpossinfo.push(alt.showShort)} 
    end
    lomgpossinfo=lomgpossinfo.reject{|info| info.nil? or info.length<2 }

    if difficultypass>0 then
      lomgpossinfo.unshift("passive check (estimate; requires #{difficultypass} in #{actor.name})")
    end
    return lomgpossinfo
  end

  def getLeastHubParentName
    grandparentslist=[]
    greatgrandparentslist=[]
    if isHub?
      parents=origin

      # This is not done recursively, because it's breadth-first not depth first, 
      # and I'm not ashamed to admit I only know how to do that recurseively 
      # by using, like, postfix notation in prolog or something?
      # I do not remember all my prolog classes from uni either tbh.
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
      # GIVE UP After 3
      return "(no useful parent)"
    else
      return "(this isn't a hub)"
    end
  end

end