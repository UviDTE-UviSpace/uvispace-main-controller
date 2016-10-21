"""
Invokes the main program when the module is run as a script.

This mode of operation is intended to manage in the same thread the 
reception of poses and golas from the topics '/robot_X/pose2d' and 
'/robot_X/goal' respectively, and sending of speed set points to the 
corresponding UGV.
"""
# Standard libraries
import glob
# ROS libraries
import rospy
# Local libraries
from robot import RobotController

def main():
    # Creates an instance of the RobotController class
    robot = RobotController()
    # Creates a ROS node
    rospy.init_node('robot{}_controller'.format(robot_id), anonymous=True)
    # Subscribes to 2 topics, corresponding to the pose and goal of the robot
    rospy.Subscriber('/robot_{}/pose2d'.format(robot.robot_id), Pose2D, 
                     robot.new_pose, queue_size=1)
    rospy.Subscriber('/robot_{}/goal'.format(robot.robot_id), Pose2D, 
                     robot.new_goal, queue_size=1)
    # Publishes the speeds to a ROS topic				     
    speed_pub = rospy.Publisher('/robot_{}/cmd_vel'.format(robot.robot_id),
                                Twist, queue_size=1)
    # Defines the function to be run when the node is shutdown
    rospy.on_shutdown(on_shutdown)
    rospy.spin()
					                       					     
def on_shutdown(self):
    robot.speeds.linear.x = 0
    robot.speeds.angular.z = 0,
    speed_pub.publish(robot.speeds)

if __name__ == "__main__":
    main()
    
    
