class Conversation < ActiveRecord::Base
	has_many :dialogues
	has_many :actors, :through =>  :dialogues
end
