class Event < ActiveRecord::Base
    has_and_belongs_to_many :divisions
    has_and_belongs_to_many :teams

    def name_and_date
        "#{self.name} #{self.date}"
    end
end
