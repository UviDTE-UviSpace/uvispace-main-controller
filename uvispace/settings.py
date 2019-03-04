import logging.config
import os
import time

# Definition of ports in Uvispace ZMQ sockets
class UviPort():
    # camera socket ports
    triangles = 32000
    bin_img = 33000
    gray_img = 34000
    rgb_img = 35000
    cam_config = 36000
    # main controller internal ports
    multi_img = 32000
    fps = 33000
    position_base = 35000
    speed_base = 35010
    trajectory_base = 35020
    battery_base = 35030
    
# Logging configuration
parent_path = os.path.dirname(__file__)
log_path = ("{}/log".format(parent_path))

LOGGING = {
    'version': 1,
    'formatters': {
        'verbose': {
            'format': '%(asctime)s %(levelname)8s %(name)s '
                      '%(module)s:%(lineno)d %(message)s'
        },
        'simple': {
            'format': '%(levelname)8s %(module)s:%(lineno)d %(message)s'
        },
        'thread_verbose': {
            'format': '%(asctime)s %(levelname)8s %(name)s '
                      '(%(threadName)-9s) %(module)s:%(lineno)d %(message)s'
        },
        'thread_simple': {
            'format': '%(levelname)8s (%(threadName)-9s) %(module)s:%(lineno)d '
                      '%(message)s'
        }
    },
    'handlers': {
        'file_navigator': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': '/'.join([log_path, 'navigator_{}.log'.format(
                    time.strftime("%Y%m%d_%H%M%S"))]),
            'delay': True
        },
        'file_messenger': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': '/'.join([log_path, 'messenger_{}.log'.format(
                    time.strftime("%Y%m%d_%H%M%S"))]),
            'delay': True
        },
        'file_sensor': {
            'level': 'DEBUG',
            'formatter': 'thread_verbose',
            'class': 'logging.FileHandler',
            'filename': os.path.join(log_path, 'sensor_{}.log'.format(
                    time.strftime("%Y%m%d_%H%M%S"))),
            'delay': True
        },
        'file_speedstudy': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': os.path.join(log_path, 'speedstudy_{}.log'.format(
                    time.strftime("%Y%m%d_%H%M%S"))),
            'delay': True
        },
        'console': {
            'level': 'INFO',
            'formatter': 'simple',
            'class': 'logging.StreamHandler'
        }
    },
    'loggers': {
        'navigator': {
            'handlers': ['file_navigator', 'console'],
            'level': 'DEBUG'
        },
        'messenger': {
            'handlers': ['file_messenger', 'console'],
            'level': 'DEBUG'
        },
        'sensor': {
            'handlers': ['file_sensor', 'console'],
            'level': 'DEBUG'
        },
        'speedstudy': {
            'handlers': ['file_speedstudy', 'console'],
            'level': 'DEBUG'
        }
    }
}

logging.config.dictConfig(LOGGING)
