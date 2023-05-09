'''A module for testing'''
import unittest
import calendar;
import time;
from app import APP


class Tests(unittest.TestCase):
    '''Basic tests for the application'''
    def setUp(self):
        '''Create a test client for the app'''
        self.app = APP.test_client()

    def test_message(self):
        '''test_message: a request for / shall return 200 OK'''
        res = self.app.get('/')
        assert res.status == '200 OK'

    def test_404(self):
        '''test_404: a request for null shall return 404 NOT FOUND'''
        res = self.app.get('/null')
        assert res.status == '404 NOT FOUND'

    def test_json(self):
        '''test_json: a request for the message shall return the defined static JSON'''
        # gmt stores current gmtime
        gmt = time.gmtime()   
        # ts stores timestamp
        ts = calendar.timegm(gmt)
        res = self.app.get('/')
        print(ts)
        assert res.json == {"message": "Automate all the things!", "timestamp": ts}


if __name__ == "__main__":
    unittest.main()
