UviSpace
--------

Two main packages:

* uvirobot

* uvisensors

uvirobot
--------

messenger
=========

* Run roscore

* execute messenger module (run -m uvirobot.messenger -- -r <robot_id>).
the execution will spin until it is killed. It will hear to speed set
points published to the topic '/robot_X/cmd_vel'.

* Publish speed setpoints: rostopic pub robot_1/cmd_vel geometry_msgs/Twist '{linear: {x: 1, y: 0, z: 0}, angular: {z: 0.0} }'


