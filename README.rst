========
UviSpace
========

:Author:
    Department of Electronic Technology,

    University of Vigo

:Version: 1.0.0

=====================
Project documentation
=====================

.. image:: https://readthedocs.org/projects/uvispace/badge/?version=latest
   :target: http://uvispace.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status

The oficial documentation about the UviSpace project is hosted at `this website
<http://uvispace.readthedocs.io/en/latest/>`_.

============
Installation
============

Install tkinter package for Python 3:

.. code-block:: bash

   $ sudo apt-get install python3-tk

Install virtualenvwrapper to create a Python 3.6 virtual environment. Follow
the tutorial in the uvispace-main-controller documentation page.

Inside the virtual environment install all the required packages with the
correct versions using the requirements.txt file:

.. code-block:: bash

   $ pip install -r requieremnts.txt

========
uvispace
========

Uvispace is though as a any other Python module. Just add the module root folder
(the repository folder) to the python search path and all modules inside it can
be imported (from inside a python session). Some modules (those with __main__.py)
are also executable as script using python -m command. In any case, before running any
uvispace software in a terminal session, the path of the repository must be added
to the python search path so they can be found and correctly linked:

.. code-block:: bash

   $ cd /<path_to_uvispace-main-controller>/
   $ source set_environment_lnx.sh # Linux
   $ set_environment_win.bat # Windows

The project contains four main packages, that coincide with the main folders of
the repository:

* uvirobot: vehicle communications.
* uvinavigator: vehicle controllers.
* uvisensor: vehicle localization.
* uvigui: graphical interface for visualization and calibration.

There is an extra tests folder that contains test files for some modules and
submodules.

Uvispace itself is executable. The following command launches all the main modules
(uvigui launching is optional) in different threads. It is a great way to get uvispace
running with a single click.

.. code-block:: bash

  $ python -m uvispace      # gui is not launched
  $ python -m uvispace -gui # gui is launched

Alternatively you can start each package one by one in a different console.
Uvispace as a whole (closed loop control of vehicles) does not start until uvirobot,
uvinavigator and uvisensor are running. Modules communicate
with each other through ZMQ sockets so the order you start each module does not
care. uvigui is optional.

New trajectories for the vehicles are added from uvinavigator
console (when launched independently) or from the uvispace console (when launched all
together with uvispace command). If uvigui is running, trajectories can be
also added from uvigui. This is done to be able to run uvispace without the need
of uvigui in, allowing UviSpace to run in embedded platforms without display.

You can also run each UviSpace package independently. They make useful stuff by themselves.
In example running uvirobot alone prints the battery level of the UGV in console
and permits to check if the communications with a robot are working. To do
so open a terminal and run the module as explained below.

=================
uvispace.uvirobot
=================

The uvirobot package contains all the modules required to communicate with the UGV.
via an XBee or Wifi (selected in the config file of the vihicle). This module
listens for motor set_points from navigator that are inmediately sent to the robot.
To use Zigbee you must connect a Zigbee module connected via USB to the machine
where the uvispace-main-controller is running. For Wi-Fi the machine must be
connected to the same network (through a wireless router or access point)
to the same network programed in the WiFi modules installed in the vehicles.

* To run it, open a new Terminal, place yourself in uvispace-main controller folder, set up the environment, and execute the module as a script with.

.. code-block:: bash

   $ python -m uvispace.uvirobot -r <robot_id>

The execution will listen for motor speed set points until it is killed. <robot_id> is the number of the robot.

=====================
uvispace.uvinavigator
=====================

The uvinavigator module listens for new positions of the robot (from uvisensor),
as well as for destination goals (typed by the user in the navigator console or
added via uvigui) and plans the following motor setpoint for robots motors,
that are sent to messenger.

* To run it, open a new Terminal, place yourself in uvispace-main controller folder, set up the environment, and execute the module as a script with.

.. code-block:: bash

   $ python -m uvispace.uvinavigator -r <robot_id>

==================
uvispace.uvisensor
==================

The uvisensor package connects via ethernet to external cameras, configures them and acquires images and UGV triangles points from them. Using the image generates a multi-image (generated by the images of all camera arranged in 2x2) that is used by uvigui. Using the points of the UGV triangles it calculates the position of the UGV, that is used by the navigator.

* To run it, open a new Terminal, place yourself in uvispace-main controller folder, set up the environment, and execute the module as a script with.

.. code-block:: bash

   $ python -m uvispace.uvisensor

===============
uvispace.uvigui
===============

The uvigui module reads the multi-image (composite from all cameras) and plots it, permits to send trajectories to the vehicles (through uvinavigator), reads battery level from vehicles and launches some interesting tools like: camera calibrator, fuzzy controller calibrator and the neural controller trainer.

* To run it, open a new Terminal, place yourself in uvispace-main controller folder, set up the environment, and execute the module as a script with.

.. code-block:: bash

   $ python -m uvispace.uvigui
