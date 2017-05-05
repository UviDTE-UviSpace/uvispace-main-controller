import logging.config
import os

LOGGING = {
    'version': 1,
    'formatters': {
        'verbose': {
            'format': '%(asctime)s %(levelname)8s %(name)s '
                      '%(module)s:%(lineno)d %(message)s'
        },
        'simple': {
            'format': '%(levelname)8s %(module)s:%(lineno)d %(message)s'
        }
    },
    'handlers': {
        'file_controller': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': '/'.join([os.environ.get('LOG_PATH'), 'controller.log'])
        },
        'file_messenger': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': '/'.join([os.environ.get('LOG_PATH'), 'messenger.log'])
        },
        'file_sensor': {
            'level': 'DEBUG',
            'formatter': 'verbose',
            'class': 'logging.FileHandler',
            'filename': '/'.join([os.environ.get('LOG_PATH'), 'sensor.log'])
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
