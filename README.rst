========
UviSpace
========

:Author:
    Javier López Randulfe,

    University of Vigo

:Version: 0.1.0 

The project contains two main packages:

* uvirobot

* uvisensor

========
uvirobot
========

The uvirobot package contains all the modules required to control an UGV i.e.: Connect to it via an XBee module, receive position and goal parameters, calculate the path to the goal, stablish speed set points, transform the speed value to a valid input to the Arduino board on the UGV and send the values to it.

Before executing any of its modules, roscore has to be run on a Terminal (Ctrl + Alt + T):

.. code-block:: bash

   $ source /<rosdistro_path>/setup.bash
   $ roscore

**NOTE:** roscore is a program that belongs to the ROS package. For more info on how to install and use it, visit their webpage (http://www.ros.org/)




messenger
---------

The *messenger* module stablish a connection with the board. It has been tested with XBee modules, connected to the PC through a serial port. Once the connection is established, the program will wait for speed set points and will send them to the UGV.
   
* To run it, open a new Terminal and execute the script using the Python interpreter. The execution will spin until it is killed. It will hear to speed set points published to the topic *'/robot_X/cmd_vel'*:

.. code-block:: bash

   $ cd /<path_to_UviSpace>/uvispace/
   $ python  -m uvirobot/messenger.py -r <robot_id>

* Alternatively, execute the *messenger.py* module on an *IPython* session:

.. code-block:: python

   In [1]: cd /<path_to_UviSpace>/uvispace/
          /<path_to_UviSpace>/uvispace
   In [2]: run  -m uvirobot.messenger -- -r <robot_id>


* On another Terminal, publish speed set points (Not necessary if move_robot.py is going to be executed): 

.. code-block:: bash

    $ rostopic pub robot_1/cmd_vel geometry_msgs/Twist '{linear: {x: 1, y: 0, z: 0}, angular: {z: 0.0} }'


move_robot
----------

The *move_robot* module listens to the publishing of new positions (poses) of the robot, as well as to destination goals typed by the user.

* To run it, open a new Terminal and execute the script using the Python interpreter. The execution will spin until it is killed. 

.. code-block:: bash

   $ cd /<path_to_UviSpace>/uvispace/
   $ python  -m uvirobot/move_robot.py -r <robot_id>

* Alternatively, execute the module on an *IPython* session:

.. code-block:: python

   In [1]: cd /<path_to_UviSpace>/uvispace/
          /<path_to_UviSpace>/uvispace
   In [2]: run  -m uvirobot.move_robot -- -r <robot_id>


* On another Terminal, publish UGV positions (Not necessary if ispace_sensor package is going to be executed): 

.. code-block:: bash

    $ rostopic pub /robot_1/pose2d geometry_msgs/Pose2D "{x: 0.0, y: 0.0, theta: 0.0}"

* On another Terminal, publish a destination goal

.. code-block:: bash

    $ rostopic pub /robot_1/goal geometry_msgs/Pose2D "{x: 1.0, y: 0.0}"


=========
uvisensor
=========

The uvisensor package connects via ethernet to external cameras, configures them and acquires images of the iSpace scene. Finally, it calculates the position of the UGVs and publishes them to a rostopic.

ispace_sensor
-------------

* To run it, open a new Terminal and execute the script using the ROS utilities. The execution will spin until it is killed. 

.. code-block:: bash

    $ source /<path-to-catkin-ws>/devel/setup.bash
    $ roslaunch ispace_robot robots.launch --screen






