#!/usr/bin/env python
"""
Auxiliar module for streaming images from a Localization Node.

The localization node can be accessed through TCP/IP.
"""
import cv2
import logging
import numpy as np
import socket
import time


def main():
    address = ("172.19.5.214", 36000)
    client = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
    client.connect(address)

    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    videowriter = cv2.VideoWriter('output.avi', fourcc, 6.0, (640, 480))

    for frame in range(10000):
        try:
            client.send("capture_frame\n")
            message = recv_data(client, 480*640*4)
        except socket.timeout:
            break
        except KeyboardInterrupt:
            break
        else:
            shape = (480, 640, 4)
            raw_array = np.fromstring(message, dtype=np.uint8).reshape(shape)
            image = raw_array[:, :, 0:3]

            #Swap Red and Blue components
            for i in range(0, 480):
                for j in range(0, 640):
                    B = image[i,j,0];
                    R = image[i,j,2];
                    image[i,j,0] = R;
                    image[i,j,2] = B;

            cv2.imshow('stream', image)
            cv2.waitKey(1)
            videowriter.write(image)

    client.send("quit\n")


def recv_data(sck, size):
    """Read the specified number of packages from the input socket."""
    recv_bytes = 0
    packages = []
    count = 0
    # Do not stop reading new packages until target 'size' is reached
    while recv_bytes < size:
        try:
            received_package = sck.recv(size)
        except socket.timeout:
            break
        recv_bytes += len(received_package)
        packages.append(received_package)
        count += 1
    # Concatenate all the packages in a unique variable
    data = ''.join(packages)
    return data

if __name__ == '__main__':
    main()
