import os
import logging.config


# Logging configuration
log_path = os.path.join(os.path.dirname(__file__), 'log')

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
        'file_controller': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': '/'.join([log_path, 'controller.log'])
        },
        'file_messenger': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': '/'.join([log_path, 'messenger.log'])
        },
        'file_sensor': {
            'level': 'DEBUG',
            'formatter': 'thread_verbose',
            'class': 'logging.FileHandler',
            'filename': os.path.join(log_path, 'sensor.log')
        },
        'console': {
            'level': 'DEBUG',
            'formatter': 'simple',
            'class': 'logging.StreamHandler'
        }
    },
    'loggers': {
        'controller': {
            'handlers': ['file_controller', 'console'],
            'level': 'DEBUG'
        },
        'messenger': {
            'handlers': ['file_messenger', 'console'],
            'level': 'DEBUG'
        },
        'sensor': {
            'handlers': ['file_sensor', 'console'],
            'level': 'DEBUG'
        }
    }
}

logging.config.dictConfig(LOGGING)

# Communication base ports
position_base_port = 35000
speed_base_port = 35010
goal_base_port = 35020
