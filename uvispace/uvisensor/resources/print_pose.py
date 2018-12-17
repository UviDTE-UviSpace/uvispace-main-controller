#!/usr/bin/env python

import zmq
import os
import numpy as np
import csv

def main():

  NUM_REPS = 5000
  PIX_TO_MM_X = 1890.0/640.0
  PIX_TO_MM_Y = 1390.0/468.0

  # Open a subscribe socket to listen for position data
  triangle_subscriber = zmq.Context.instance().socket(zmq.SUB)
  triangle_subscriber.setsockopt_string(zmq.SUBSCRIBE, u"")
  triangle_subscriber.setsockopt(zmq.CONFLATE, True)
  triangle_subscriber.connect("tcp://172.19.5.214:32000")

  data = []
  data.append(["P1X_PIX","P1Y_PIX", #triangle point 1
               "P2X_PIX","P2Y_PIX",  #triangle point 2
               "P3X_PIX","P3Y_PIX",  #triangle point 3
               "X_PIX", #x
               "Y_PIX", #y
               "P1X_MM","P1Y_MM", #triangle point 1
               "P2X_MM","P2Y_MM",  #triangle point 2
               "P3X_MM","P3Y_MM",  #triangle point 3
               "X_MM", #x
               "Y_MM", #y
               "THETA"]) #theta

  no_triangle_counter = 0;
  for i in range(NUM_REPS):
      print(i)
      triangle = triangle_subscriber.recv_json()
      if (len(triangle)>0):
          #print(triangle)
          pose = get_pose(triangle, True)
          #print(pose)
          data.append([triangle[0][0][0],triangle[0][0][1], #triangle point 1
                       triangle[0][1][0],triangle[0][1][1], #triangle point 2
                       triangle[0][2][0],triangle[0][2][1], #triangle point 3
                       pose[0], #x
                       pose[1], #y
                       triangle[0][0][0]*PIX_TO_MM_X,triangle[0][0][1]*PIX_TO_MM_Y, #triangle point 1
                       triangle[0][1][0]*PIX_TO_MM_X,triangle[0][1][1]*PIX_TO_MM_Y, #triangle point 2
                       triangle[0][2][0]*PIX_TO_MM_X,triangle[0][2][1]*PIX_TO_MM_Y, #triangle point 3
                       pose[0]*PIX_TO_MM_X, #x
                       pose[1]*PIX_TO_MM_Y, #y
                       pose[2]]) #theta
      else:
            print("No triangle!")
            no_triangle_counter = no_triangle_counter + 1;

  print("Number of triangles that failed:", no_triangle_counter)

  #save data in file
  with open("output.csv", "wb") as f:
      writer = csv.writer(f)
      writer.writerows(data)

  #print standard deviations
  std_x_pix= np.std(np.array(data)[1:,6].astype(np.float))
  std_y_pix = np.std(np.array(data)[1:,7].astype(np.float))
  std_x_mm = np.std(np.array(data)[1:,14].astype(np.float))
  std_y_mm = np.std(np.array(data)[1:,15].astype(np.float))
  std_angle_degrees = (np.std(np.array(data)[1:,16].astype(np.float)))*180.0/np.pi;
  print("Standard deviations:")
  print("x_pix=", std_x_pix)
  print("y_pix", std_y_pix)
  print("x_mm", std_x_mm)
  print("y_mm", std_y_mm)
  print("angle_degrees", std_angle_degrees);

def get_pose(triangle_vertices, cartesian=False):
    """Return triangle's angle and base midpoint, given its vertices.

    The coordinates of 3 vertices defining the triangle are used,
    packed in a single 3x2 array. This method assumes that the
    triangle is isosceles and the 2 equal sides are bigger than
    the different one, called base.

    The following attributes are updated:

    * self.sides : array containing the lengths of the 3 sides.
    * self.base_index : array index of the minor side. This is also
      the index of the vertex between the 2 mayor sides, as vertices
      indexes are the indexes of their opposite sides.

    :return: [X,Y] coordinate of
     the midpoint of the triangle's base side and orientation angle
     of the triangle. It is the resulting angle between the
     horizontal axis and the segment that goes from the triangle's
     midpoint to the frontal vertex. It is expressed in radians, in
     the range [-pi, pi].
    :rtype: float32, float32, float32
    """

    vertices = []
    for i in range(3):
        vertices.append(np.asarray(triangle_vertices[0][i]))

    # Calculate the length of the sides i.e. the Euclidean distance
    sides = np.zeros([3])
    sides[0] = np.linalg.norm(vertices[2] - vertices[1])
    sides[1] = np.linalg.norm(vertices[0] - vertices[2])
    sides[2] = np.linalg.norm(vertices[1] - vertices[0])
    # If 2 sides are equal, the common vertex is the front one and
    # The base midpoint is calculated with the other 2.
    base_index = np.argmin(sides)
    midpoint = (vertices[base_index-1]
                     + vertices[base_index-2]) / 2
    # Calculus of the x and y distance between the midpoint and the vertex
    # opposite to the base side.
    if cartesian:
        x, y = vertices[base_index] - midpoint
    else:
        # The array 'y'(rows) counts downwards, contrary to cartesian system
        row, col = vertices[base_index] - midpoint
        x, y = col, -row
    angle = np.arctan2(y, x)
    return midpoint[0], midpoint[1], angle

if __name__ == '__main__':
    main()
