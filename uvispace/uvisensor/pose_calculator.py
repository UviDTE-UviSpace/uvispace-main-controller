
import math

import configparser
import logging

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger('navigator')

class PoseCalculator():
    """
    This object relates the shapes that are seen by the localization nodes
    to actual poses in the UviSpace global coordinate system.
    It applies different techniques to avoid jumps in the location:
    - if a triangle is lost, it waits some time before asigning the ugv as lost,
      maintaining its pose. This avoids problems in the frontiers of cameras
    - it permits to apply Kalman filter to more accuretly estimate the pose of
      the UGV. This should correct vibrations in location due to random variations
      of triangles (that are very pixelated).
    """

    def __init__(self):

        configuration = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        configuration.read(conf_file)

        # load ugv configuration
        self.num_ugvs = int(configuration["UGVs"]["number_ugvs"])
        self.ugv_ids = list(map(int, configuration["UGVs"]["ugv_ids"].split(",")))
        self.active_ugvs = list(map(int, configuration["UGVs"]["active_ugvs"].split(",")))

        # create object to store UGVs information
        self.ugvs = []
        for i in range(self.num_ugvs):
        ugvs = {
            "active":False,
            "id" : ugv_ids[i],
            "updated_now" = False,
            "pose":{
                'x': 0.0,
                'y': 0.0,
                'theta':0.0
            }
        }

        # it counts the number of active UGVs (in the scene) in the system
        self.num_active_ugvs = 0
        # create the object to store shapes comming from loc nodes
        self.shapes = None
        # create variables to store and count triangles extracted from shapes
        self.triangles = None
        self.
        # create an object to store poses extracted from self.triangles
        self.poses = []

    def shapes_to_poses(self, shapes):
        """
        It converts the list of shapes received from localization nodes
        to a poses. Not all shapes are triangles. In the borders of the
        cameras polygons with four vertices are received. This function
        combines them to form a single triangle.
        Args:
            shapes (list): list of localization node shape lists. There are
            as many elements as localization nodes. Each element in this list
            is a list of shapes for a localization node. Each shape is a
            another list with the vertices of each point in the shape. And each
            point is another list with x and y coordinates of that point.
            Threfore it is a 4-level list.
            Just as example: shapes[3][2][1][0] is the x coordinate (0) from the
            second point (1) of the third shape (2) of the fourth localization
            node (4).
        Returns:
            The self.ugvs object (defined in __init__). It provides the pose
            and information that can be useful for the UviSensor.
        """

        # update shapes list
        self.shapes = triangles

        # convert shapes to triangles
        self.triangles = self.shapes

        # transform triangles to poses
        self.poses = []
        for i in range(len(self.triangles)):
            self.poses.append(self._triangle2pose(self.triangles[i]))

        # if the number of triangles changed it means that new ugvs have been
        # inserted into the system.
        if self.num_triangles != len(self.triangles):
            self._update_active_ugvs()
            self.num_triangles = len(self.triangles)

        # assign detected poses to the closest ugvs
        if self.num_triangles > 0:
            # for each ugv
            for j in range(len(self.num_ugvs)):
                # if ugv is active find closest pose (innactive ugvs pose
                # is unknown and has no sense to check them)
                if self.ugv[j]["active"]:
                    # calc distances between ugv j and all poses
                    distances = None
                    for i in range(len(self.poses)):
                        distances.append(self._distance(
                            self.poses[i], self.ugv[j]["pose"]
                        ))
                    # assign to ugv j pose with minimum distance
                    min_dist = np.argmin(distances)
                    if min_dist == 0.0:
                        self.ugv[j]["updated_now"] = False
                    else:
                        self.ugv[j]["updated_now"] = True
                        self.ugv[j]["pose"] = self.poses[np.argmin(min_dist)]
        return ugvs

    def _update_active_ugvs(self):
        """
        This function updates the active ugvs. Active ugvs are the ugvs in the
        scene and that can be controlled by the system. In some setups ugvs
        can be suddenly added into the system and the number of ugvs may change.
        ---
        Currently the active ugvs are constant and retrieved from the config
        file. In the future this function should read some identifiers in the
        vehicles and asign to each id the status of active if they are in the
        scene.
        """
        for i in range(self.num_ugvs):
            if self.active_ugvs[i]:
                self.ugvs[i]["active"] = True
            else:
                # deactivate
                self.ugvs[i]["active"] = False
                # reset its pose
                self.ugvs[i]["pose"]{
                    'x': self.poses[0],
                    'y': self.poses[0],
                    'theta': self.poses[0]
                }

    def _triangle2pose(self):
        pass

    def _distance(self, posea, poseb):
        """
        Calculate euclidian distance between 2 points A and B

        Args:
            posea (dict): pose with format {"x":0.0, "y":0.0, "theta":0.0}
            poseb (dict): pose with format {"x":0.0, "y":0.0, "theta":0.0}
        """
        return dist = math.hypot(poseb["x"] - posea["x"], poseb["y"] - posea["y"])
