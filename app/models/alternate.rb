class Alternate < ApplicationRecord
  belongs_to :dialogue, counter_cache: true
	has_one :actor, :through =>  :dialogue
	default_scope { includes(:dialogue, :actor) }

  def showShort
  	return "Replaced with \"#{alternateline}\" if #{conditionstring}"
  end

	scope :saidBy, ->(actorID) { where("actor_id = ?", actorID)}

	scope :searchAlts, ->(query) do
		quer1= query.pop
		sqlquer="alternateline LIKE ?", "%#{quer1}%"
		if query.empty?
			where(sqlquer)
		else
			searchAlts(query).where(sqlquer)
		end
	end

end
