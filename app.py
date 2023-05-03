#!/usr/bin/env python
"""
flask: a microservice message
"""
from flask import Flask, jsonify, make_response

APP = Flask(__name__)

# Reply
MESSAGE = {"message": "Automate all the things!", "timestamp": 1529729125}


@APP.route('/', methods=['GET'])
def message():
    '''Return static message'''
    return jsonify(MESSAGE)


@APP.errorhandler(404)
def not_found(error):
    '''Return error handling message, when page not found'''
    return make_response(jsonify({'error': str(error)}), 404)


if __name__ == '__main__':
    APP.run("0.0.0.0", port=8080, debug=True)
