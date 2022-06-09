# Instead of testing private methods themselves,
# we should test the public interface of the class - meaning the public methods.

RSpec.describe RobotServant do

  describe '#clean_house' do

    it 'logs the house cleaning subtasks: dishes, laundry, and making dinner' do
      robot = build(:robot)

      robot.clean_house 

      expect(robot.completed_task_log).to eq([
        "Finished doing dishes",
        "Finished doing laundry",
        "Finished making dinner",
      ])
    end

  end

end

# All we care about with #clean_house is that the robot's completed_task_log
# looks correct after cleaning.
#
# We should not need to test the implementation of do_dishes, do_laundry, or make_dinner by calling
# them directly via :send.
#
# This is what people  mean by testing behavior, not implementation.
