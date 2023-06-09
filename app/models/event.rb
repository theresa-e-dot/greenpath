class Event < ApplicationRecord
  belongs_to :habit
  validates :status, presence: true
  validates :due_date, presence: true

  # enum status: { upcoming: 0, overdue: 1, accomplished: 2 }

  def generate_recurring_events(event, end_date)
    schedule = IceCube::Schedule.new(event.due_date.to_date)
    case event.habit.implementation_cycle.downcase
    when "daily"
      schedule.add_recurrence_rule IceCube::Rule.daily
    when "weekly"
      schedule.add_recurrence_rule IceCube::Rule.weekly(1).day(event.habit.day_of_week.downcase.to_sym)
    when "monthly"
      schedule.add_recurrence_rule IceCube::Rule.monthly(1).day(event.habit.day_of_week.downcase.to_sym)
    end

    schedule.occurrences(end_date.to_date).each do |date|
      next if date <= Date.current

      recurring_event = event.dup
      recurring_event.due_date = date
      recurring_event.save
    end
  end
end
