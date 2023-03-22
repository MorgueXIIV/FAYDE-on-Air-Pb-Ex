class ActorTranslation < ApplicationRecord
		belongs_to :actor, :foreign_key => 'actor_id'
end
