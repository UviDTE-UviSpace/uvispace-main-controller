import socket
import pylab
from scipy import misc


def main():
    s = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
    address = ("172.19.5.213", 36000)
    s.connect(address)
    s.send("get_image\n")
    try:
        message = recv_data(s, 307200)
    except socket.timeout:
        print("timeout")
    else:
        shape = (480, 640)
        image = pylab.fromstring(message, dtype=pylab.uint8).reshape(shape)
        misc.imsave("image.png", image)


def recv_data(socket, size):
    recv_bytes = 0
    packages = []
    # Do not stop reading new packages until target 'size' is reached.
    while recv_bytes < size:
        try:
            received_package = socket.recv(size)
        except socket.timeout:
            break
        recv_bytes += len(received_package)
        packages.append(received_package)
    # Concatenate all the packages in a unique variable
    data = ''.join(packages)
    return data

if __name__ == '__main__':
    main()
