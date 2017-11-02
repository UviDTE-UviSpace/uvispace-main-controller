Tutorials and manuals
=====================

..  toctree::
    :maxdepth: 2

    Tutorials               <tutorials>


Python virtual environments
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to ease the management of the project dependencies, it is recommended
to make use of Python virtual environments. Virtual environments are used to
provide isolation between projects, keeping all the required libraries in a
directory available only to the virtual environment, and thus avoid polluting
the global sites-packages directory.

There is a utility called **virtualenvwrapper** that simplifies the management
of virtual environments, and we will use this utility to obtain a clean virtual
environment for our project.

To install this utility, run the following command (root permissions may be
necessary):

.. code-block:: bash

    $ pip install virtualenvwrapper

Once the installation has finished, open up the *.bashrc* file and add the
following lines:

.. code-block:: bash

    export WORKON_HOME=$HOME/.virtualenvs      # Virtual environments folder
    source /usr/local/bin/virtualenvwrapper.sh # Enable virtualenvwrapper commands

To create a new virtual environment, run the following command:

.. code-block:: bash

    $ mkvirtualenv uvispace # Syntax: mkvirtualenv (name for the virtual environment)
    (uvispace) $            # Prompt gets updated to reflect the virtual environment is active

In case the virtual environment is already created, it is only necessary to
activate it with the following command:

.. code-block:: bash

    $ workon uvispace # Syntax: workon (name for the virtual environment)
    (uvispace) $      # Prompt gets updated to reflect the virtual environment is active

If we want to stop using a virtual environment, run the following command:

.. code-block:: bash

    (uvispace) $ deactivate
    $                        # Prompt gets updated to reflect the virtual environment is no longer active

By default, *mkvirtualenv* uses the system default *Python* interpreter. If a
specific version of python is required, it can be specified with the -p
parameter:

.. code-block:: bash

    $ mkvirtualenv -p python2 (name)    # Python2 virtual environment
    $ mkvirtualenv -p python3.4 (name)  # Python3.4 virtual environment

When entering a new virtual environment, there will be no access to the
software libraries previously installed on the system, as the purpose of this
tool is to have an isolated environment. To add a new library to the virtual
environment, you only have to install it using *pip* (remember to previously
activate the environment), and the same rule works for other pip commands like
uninstall or freeze:

.. code-block:: bash

    (uvispace) $ pip install <library-name>

Finally, certain projects, like *uvispace*, have predefined libraries and
versions and they are specified under a *requirements.txt* file (The name does
not have to be necessary the same). In this case, these libraries can be
automatically installed on the virtual environment using the following command:

.. code-block:: bash

    (uvispace) $ pip install -r requirements.txt

Other useful commands are the following:

.. code-block:: bash

    $ lsvirtualenv        # List all available virtual environments
    $ rmvirtualenv (name) # Deletes a virtual environment

A more extensive reference on the *virtualenvwrapper* utility can be found on
its `documentation <https://virtualenvwrapper.readthedocs.io>`_.
