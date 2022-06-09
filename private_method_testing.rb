class Robot

  attr_reader :completed_task_log

  def initialized
    @completed_task_log = []
  end

  def clean_house
    do_dishes
    do_laundry
    do_dinner
  end

  private

  def do_dishes
    # ... do stuff for the dishes ...
    @completed_task_log << "Finished doing dishes"
  end

  def do_laundry
    # ... do stuff for the laundry ...
    @completed_task_log << "Finished the laundry"
  end

  def make_dinner
    # ... do stuff for the dinner ...
    @completed_task_log << "Finished making dinner"
  end

end


# Bad way to test the private methods: testing their implementation!

RSpec.describe Robot do

  describe '#do_dishes' do

    it 'logs that the dishes were done' do
      robot = build(:robot)

      robot.send(:do_dishes)

      expect(robot.completed_task_log).to include("Finished doing dishes")
    end

  end

  describe '#do_laundry' do

    it 'logs that laundry was done' do
      robot = build(:robot)

      robot.send(:do_laundry)

      expect(robot.completed_task_log).to include("Finished doing laundry")
    end

  end

  describe '#make_dinner' do

    it 'logs that dinner was made' do
      robot = build(:robot)

      robot.send(:make_dinner)

      expect(robot.completed_task_log).to include("Finished making dinner")
    end

  end

end
