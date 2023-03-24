class ConversationController < ApplicationController

	def trace
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
			render :controller => 'conversation', :action => "error"
		else
				convosLinksReq= DialogueLink
				idsList=params[:dialogueid].split("-").map{ |e| e.to_i }
				@conversationDescribe = []
				convoIDs= (((idsList.map{ |e| e / 10000 }).uniq))
				convosLinks=[]

				findLinks = Proc.new { |id|
									min=id*10000
									max=(id+1)*10000
									convosLinksReq = (DialogueLink.where("origin_id between ? and ? or destination_id between ? and ?", min, max, min, max))
									convosLinks += convosLinksReq.pluck(:origin_id, :destination_id)
								}

				@conversationDescribe=( Conversation.where(id: convoIDs) )
				convoIDs.each { | convoID | convosLinks += findLinks.call convoID }

				pickBLinks = Proc.new { |id| (convosLinks.select { |l| (l[1].to_i == id) }).map { |e| e[0].to_i }}
				pickFLinks = Proc.new { |id| (convosLinks.select { |l| (l[0].to_i == id) }).map { |e| e[1].to_i }}
				checkConvoDrift= Proc.new { |newIDs|
									checkForOutliers = (newIDs.map{ |e| e / 10000 }.uniq) - convoIDs
										if not checkForOutliers.blank? then
											convoIDs += checkForOutliers
											checkForOutliers.each{ |e| findLinks.call e }
										end}

			begin # (error catching)
				idsFullList = Array.new
				idsCritList = Array.new
				# forwOptions = pickBLinks.call idsList.first
				#initialise the forward options so we have the history of the first link
				forwOptions = []
				@brokenChainIDs=[]

					# thisID=idsList.shift

					idsList.each_with_index do | thisID, i |
						idsFullList.push thisID

						# check for citical path:
						# in the first loop foptions will be empty so first one will always
						# be critical,
						# in subsequent runs, the forward options are from the previous
						# list item, so they represent BACK options for this ID.
						if forwOptions.length != 1 then
							idsCritList.push thisID
						end

						forwOptions = pickFLinks.call(thisID)

						#if the next id is already selected in the URL, go to that id and continue
						if forwOptions.include?(idsList[i+1]) then
							next
						end

						#if the next option is deterministic, go to that option,
						# add to full list, and continue checking options til they're not
						while forwOptions.length==1
							thisID = forwOptions[0]
							idsFullList.push thisID
							forwOptions = pickFLinks.call(thisID)
						end

						#if the next id is already selected in the URL, go to that id and continue
						if idsList[i+1].blank? then break end
						if forwOptions.include?(idsList[i+1]) then
							next
						#if you can't resolve the next ID, create message and stop loop
						else
							@brokenChainIDs=idsList[i .. idsList.length]
							break
						end

					end


				#
				# while not idsList.empty? do
				# 	if forwOptions.length > 1 then idsCritList.push thisID end
				# 	forwOptions=pickFLinks.call(thisID)
				#
				# 		while forwOptions.length == 1 do
				# 			idsFullList.push forwOptions[0]
				# 			if forwOptions[0]==idsList[0]
				# 				idsList.pop
				# 			end
				# 			forwOptions = pickFLinks.call(forwOptions[0])
				# 			checkConvoDrift.call(forwOptions)
				# 		end
				# 	end
				# end

				backOptions = pickBLinks.call(idsFullList[0])
				while backOptions.length == 1 do
					thisID=backOptions[0]
					idsFullList.unshift thisID
					# todo: try removing this for performance
					checkConvoDrift.call(backOptions)
					# add to crit list if the forward options are multiple.
					forwOptions = pickFLinks.call(thisID)
					if forwOptions.length>1 then
						idsCritList.unshift idsFullList[1]
					end
					backOptions = pickBLinks.call thisID
				end

				# forwOptions = convosLinks.select { |l| (l[0].to_i==idsList.last) }.map { |e| e[1].to_i }
				# while forwOptions.length == 1 do
				# 	idsList.push forwOptions[0]
				# 	forwOptions = convosLinks.select { |l| (l[0].to_i==idsList.last) }.map { |e| e[1].to_i }
				# 	checkForOutliers = (forwOptions.map{ |e| e / 10000 }.uniq) - convoIDs
				# 	if not checkForOutliers.blank? then
				# 		convoIDs += checkForOutliers
				# 		checkForOutliers.each{ |e| findLinks.call e }
				# 	end
				# end

				idsRetrieving = (idsFullList+forwOptions)
				dialoguesUsing = Dialogue.includes(:actor, :alternates, :checks).where(id: idsRetrieving)
				dialoguesUsing = dialoguesUsing + Dialogue.includes(:actor, :alternates, :checks, :origin).where(id: backOptions)

				@builtConvo = idsFullList.map { |e| dialoguesUsing.find{|f| f.id==e }}
				#
				# @forwOptions = forwOptions.map { |e| dialoguesUsing.find{|f| f.id==e}}
				# @backOptions = backOptions.map { |e| dialoguesUsing.find{|f| f.id==e}} #Dialogue.includes(:actor, :alternates).find_by_id(backOptions)
				@forwOptions = @builtConvo.last.destination.includes(:actor).all
				@backOptions = @builtConvo.first.origin.includes(:actor, :origin).all

				@idsList = idsCritList.join("-")
				@idsLongList = idsFullList.join("-")
			rescue ActiveRecord::RecordNotFound
			end
		end
	end

	def error
		@pageTitle = "Error"
	end


	def traceOldLong
		@pageTitle = "Conversation"
		if params[:dialogueid].blank? then
			render :controller => 'conversation', :action => "error"
		else
				convosLinksReq= DialogueLink
				idsList=params[:dialogueid].split("-").map{ |e| e.to_i }
				@conversationDescribe = []
				convoIDs= (((idsList.map{ |e| e / 10000 }).uniq))
				convosLinks=[]

				findLinks = Proc.new { |id|
									min=id*10000
									max=(id+1)*10000
									convosLinksReq = (DialogueLink.where("origin_id between ? and ? or destination_id between ? and ?", min, max, min, max))
									convosLinks += convosLinksReq.pluck(:origin_id, :destination_id)
								}
								pickBLinks = Proc.new { |id| (convosLinks.select { |l| (l[1].to_i == id) }).map { |e| e[0].to_i }}
								pickFLinks = Proc.new { |id| (convosLinks.select { |l| (l[0].to_i == id) }).map { |e| e[1].to_i }}
								checkConvoDrift= Proc.new { |newIDs|
													checkForOutliers = (newIDs.map{ |e| e / 10000 }.uniq) - convoIDs
														if not checkForOutliers.blank? then
															convoIDs += checkForOutliers
															checkForOutliers.each{ |e| findLinks.call e }
														end}
				@conversationDescribe=( Conversation.where(id: convoIDs) )
				convoIDs.each { | convoID | convosLinks += findLinks.call convoID }

			begin # (error catching)

				backOptions = pickBLinks.call(idsList[0])
				while backOptions.length == 1 do
					idsList.unshift backOptions[0]
					backOptions = pickBLinks.call idsList[0]
					checkConvoDrift.call(backOptions)
				end

				forwOptions = convosLinks.select { |l| (l[0].to_i==idsList.last) }.map { |e| e[1].to_i }
				while forwOptions.length == 1 do
					idsList.push forwOptions[0]
					forwOptions = convosLinks.select { |l| (l[0].to_i==idsList.last) }.map { |e| e[1].to_i }
					checkForOutliers = (forwOptions.map{ |e| e / 10000 }.uniq) - convoIDs
					if not checkForOutliers.blank? then
						convoIDs += checkForOutliers
						checkForOutliers.each{ |e| findLinks.call e }
					end
				end

				idsRetrieving = (idsList+forwOptions)
				dialoguesUsing = Dialogue.includes(:actor, :alternates, :checks).where(id: idsRetrieving)
				dialoguesUsing = dialoguesUsing + Dialogue.includes(:actor, :alternates, :checks, :origin).where(id: backOptions)

				@builtConvo = idsList.map { |e| dialoguesUsing.find{|f| f.id==e }}
				#
				# @forwOptions = forwOptions.map { |e| dialoguesUsing.find{|f| f.id==e}}
				# @backOptions = backOptions.map { |e| dialoguesUsing.find{|f| f.id==e}} #Dialogue.includes(:actor, :alternates).find_by_id(backOptions)
				@forwOptions = @builtConvo.last.destination.includes(:actor).all
				@backOptions = @builtConvo.first.origin.includes(:actor, :origin).all

				@idsList= idsList.join("-")
				@idsLongList = "-"
				@idsShortList = "-"
			rescue ActiveRecord::RecordNotFound
			end
		end
		render "trace"
	end

	def error
		@pageTitle = "Error"
	end

	def oldredirect
		if params[:dialogueid].blank? then
		else
			@pageTitle="Redirecting..."

			idsList=params[:dialogueid].split("-")

			idsList.map! { |e| (TfcTransform.find_by_id(e))}
			idsList.reject! { |e| e.nil? }
			if idsList.length>0 then
				idsList.map! { |e| (e.dialogue_id)}
				redirect_to :controller => 'conversation', :action => "trace", :dialogueid => idsList.join("-")
			else
				redirect_to :controller => 'conversation', :action => "trace", :dialogueid => params[:dialogueid]
			end
		end
	end

	def orbindex
		@pageTitle="ORB MODE"
		@allorbs=Conversation.where("title LIKE ?", "%orb%").pluck(:dialogues_count,:title,:id,:description) #.order(:dialogues_count, :desc)
	end
end
