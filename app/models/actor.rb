class Actor < ActiveRecord::Base
	has_many :dialogues

	def self.find_by_name_part(name_part)
		where("name like ?", "%#{name_part}%").order(dialogues_count: :desc).first
	end
end
