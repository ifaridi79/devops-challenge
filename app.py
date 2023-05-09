#!/usr/bin/env python
"""
flask: a microservice message
"""
from flask import Flask, jsonify, make_response
import calendar
import time

APP = Flask(__name__)

@APP.route('/', methods=['GET'])
def message():
    '''Return static message'''
    # gmt stores current gmtime
    gmt = time.gmtime()   
    # ts stores timestamp
    ts = calendar.timegm(gmt)
    print("timestamp:-", ts)
    return jsonify({"message": "Automate all the things!", "timestamp": ts})


@APP.errorhandler(404)
def not_found(error):
    '''Return error handling message, when page not found'''
    return make_response(jsonify({'error': str(error)}), 404)


if __name__ == '__main__':
    APP.run("0.0.0.0", port=8080, debug=True)
