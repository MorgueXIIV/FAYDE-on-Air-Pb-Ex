class Dialogue < ActiveRecord::Base
  belongs_to :conversation, counter_cache: true
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

  scope :saidBy, ->(actorID) { where("actor_id = ?", actorID)}

	scope :saidByBranch, -> (actorID, altActorID){where("actor_id in (?,?)", actorID, altActorID) }

	scope :smartSaidBy, ->(actorID) do
		if actorID.id==8
				saidByBranch(105, 8)
		elsif actorID.id==9
				saidByBranch(106, 9)
		else
				saidBy(actorID)
		end
	end


  #single word/phrase search text
  # scope :searchText, ->(query) { where("dialoguetext LIKE ?", "%" + query + "%") }

  scope :searchTexts, ->(query) do
    quer1= query.pop
    # sqlquer=("dialoguetext LIKE ?", "%" + quer1 + "%")
    if query.empty?
      where("dialoguetext LIKE ?", "%" + quer1 + "%")
    else
      searchTexts(query).where("dialoguetext LIKE ?", "%" + quer1 + "%")
    end
  end

  scope :searchVars, ->(query) do
    quer1= query.pop
    querwild = "%#{quer1}%"
    # sqlquer=("conditionstring LIKE ? OR userscript LIKE ?", querwild, querwild)
    if query.empty?
      where("conditionstring LIKE ? OR userscript LIKE ?", querwild, querwild)
    else
      searchVars(query).where("conditionstring LIKE ? OR userscript LIKE ?", querwild, querwild)
    end
  end

  scope :searchTextsAct, ->(query, actor) do
      searchTexts(query).smartSaidBy(actor)
  end



  def showShort(addParentNamesToHubs=false)
    if isHub?
      shortName= "HUB: "
        if not actor.blank?
          shortName+="(#{actor.name}) "
        end
      shortName+=showDetails.join("/ ")
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

  def showActor
    if not actor.blank? then
      if isHub?
        return  "HUB: (#{actor.name}) "
      else
        return "#{actor.name}"
      end
    else
      return "HUB: "
    end
  end


  def showDialogue(addParentNamesToHubs=false, addDetailsToHubs=true)
    if isHub?
      shortName=""
      if addDetailsToHubs then shortName+=showDetails.join("/ ") end
      if addParentNamesToHubs then
        shortName+="{Hub From: #{getLeastHubParentName}}"
      else
        if shortName.length<12
          shortName+=title
        end
      end
      return shortName
    else
      return "#{dialoguetext}"
    end
  end


  def isHub?
    return dialoguetext.length<3
  end

  def showDetails
    lomgpossinfo=[conditionstring,userscript,sequence]
    if alternates_count > 0
      alternates.all.each{ |alt| lomgpossinfo.push(alt.showShort)}
    end
    lomgpossinfo=lomgpossinfo.reject{|info| info.nil? or info.length<2 }

    if ((difficultypass.blank? == false) and (difficultypass >0)) then
      realDifficulty=getDifficulty(difficultypass)
      lomgpossinfo.unshift("passive check (requires aprox. #{realDifficulty} in #{actor.name})")
    end
    return lomgpossinfo
  end

  def getDifficulty(difficultypassed)
    return difficultypassed>7 ? ((difficultypassed-7)*2)-1 : difficultypassed*2
  end

  def showCheck
    if checks_count>0
      checkArr = [ checks.first.showShort ]
      return checkArr
    else
      return []
    end
  end

  def showModifiers
    if checks_count>0
      checkArr = modifiers.all
      checkArr = checkArr.map { |e| e.showShort }
    else
      return []
    end
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
