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

	default_scope { includes(:actor) }

  scope :isHub, -> {where("length(dialoguetext) = ?", 0)}
  scope :notHub, -> {where("length(dialoguetext) > ?", 1)}

  scope :saidBy, ->(actorID) { where(actor_id: actorID)}

	scope :smartSaidBy, ->(actorID) do
		case actorID.id
			when 379 #jean
				saidBy([379, 92])
			when 381 #judit
				saidBy([381, 93])
			when 90 # korty
				saidBy([90,36])
			when 110 #Liz
				saidBy([110,69])
			when 420 #perceptions
				saidBy([420, 421, 422, 423, 424])
		else
				saidBy(actorID)
		end
	end


  #single word/phrase search text
  # scope :searchText, ->(query) { where("dialoguetext LIKE ?", "%" + query + "%") }

  scope :searchTexts, ->(query) do
		queryc=query # make copy because of the damn pass by reference breaking the variable otherwise which is unexpected behaviour
    quer1= queryc.pop
    sqlquer="dialoguetext LIKE ?", "%#{quer1}%"
    if queryc.empty?
      where(sqlquer)
    else
      searchTexts(queryc).where(sqlquer)
    end
  end

  scope :searchVars, ->(query) do
    quer1= query.pop
    quer1 = "%#{quer1}%"
    sqlquer="dialogues.conditionstring LIKE ? OR userscript LIKE ?", quer1, quer1
    if query.empty?
      where sqlquer
    else
      searchVars(query).where sqlquer
    end
  end

  scope :searchTextsAct, ->(query, actor=nil) do
		if actor.blank? then
			searchTexts(query)
		else
			searchTexts(query).smartSaidBy(actor)
		end
  end

  def showShort(addParentNamesToHubs=false)
    if isHub?
      shortName= "HUB: "
        if not (actor.blank? or actor.name=="HUB") then
          shortName+="(#{actor.name}) "
        end
      shortName+=showDetails.join("/ ")
      if addParentNamesToHubs then
        shortName+=" {Hub From: #{getLeastHubParentName}}"
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
    if not (actor.blank? or actor.name=="HUB") then
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

	def showLineage
		lins=["Og","Fc","Jv"]
		return lins[lineage]
	end

  def showDetails(brief=false)
    lomgpossinfo=[conditionstring,userscript,sequence]
    if alternates_count > 0 and not brief then
      alternates.each{ |alt| lomgpossinfo.push(alt.showShort)}
    end
    lomgpossinfo=lomgpossinfo.reject{|info| info.blank? or info.length<2 }
		lomgpossinfo=lomgpossinfo-["Continue()"]

		if brief then
			lomgpossinfo= [ lomgpossinfo[0] ]
		end
		if ((not difficultypass.blank?) and (difficultypass >0)) then
			lomgpossinfo.unshift brief ? "Passive check. " : "passive check (requires approx. #{getDifficulty(difficultypass)} in #{actor.name})"
		elsif checks_count > 0 and brief
				lomgpossinfo.unshift "Active Check. "
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
    if isHub?
      parents=origin.pluck(:title,:dialoguetext)
      # This is a vastly stripped down one that only checks up 1 level...
			# but the previous version was running so many queries,
			# at least 1 level can be eager loaded.

			# prefer parents with dialogue:
      parents.each do |parent|
        if (parent[1].length>2)
          return parent[0]
        end
      end
			# resort to parents with titles
			parents.each do |parent|
				if (parent[0].length>2)
					return parent[0]
				end
			end
      return "a hub"
    else
      return "(not a hub)"
    end
  end

end
