import json
from flask import Flask, jsonify, abort, make_response

APP = Flask(__name__)

# Reply
response =   {
    "message": "Automate all the things!",
    "timestamp": 1529729125
  }

@APP.route('/', methods=['GET'])
def home():
    '''Landing page'''
    return 'Welcome'

@APP.route('/message', methods=['GET'])
def get_message():
    '''Return static message'''
    return jsonify(response)

@APP.errorhandler(404)
def not_found(error):
    '''Return error handling message, when page not found'''    
    return make_response(jsonify({'error': str(error)}), 404)


if __name__ == '__main__':
    APP.run("0.0.0.0", port=8080, debug=True)