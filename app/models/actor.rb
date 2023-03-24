class Actor < ActiveRecord::Base
	has_many :dialogues
	has_many :actorTranslations

	def self.find_by_name_part(name_part)
		where("name like ?", "%#{name_part}%").order(dialogues_count: :desc).first
	end

	def name_in(lang)
		actorTranslations.where("language=#{lang}").first
	end
end
