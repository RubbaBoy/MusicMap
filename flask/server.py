import threading

from flask import Flask
from flask_restful import Resource, Api
from api.mm_api import *
from api.util import *
from threading import Thread
from time import sleep
import datetime

app = Flask(__name__) #create Flask instance

api = Api(app) #api router

api.add_resource(Login, '/login')
api.add_resource(Friends, '/friends')
api.add_resource(Playing, '/playing')
api.add_resource(Songs, '/songs')
api.add_resource(Location, '/location')
api.add_resource(FriendRequest, '/friends/requests')
api.add_resource(FriendDeny, '/friends/deny')
api.add_resource(FriendAccept, '/friends/accept')
api.add_resource(LocationsFollowed, '/locations/followed')
api.add_resource(LocationsFollow, '/locations/follow')
api.add_resource(LocationsUnfollow, '/locations/unfollow')

@app.after_request
def apply_caching(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

# def song_checker():
#     threading.Thread(target=exe).start()
#
# def exe():
    # while(True):
    #     resp = exec_get_all("SElECT username,playTimeStamp from (LocationHistory JOIN Users on LocationHistory.username=Users.username) WHERE playTimeStamp < now() - interval '5 minutes'")
    #     for user in resp:
    #         exec_commit("UPDATE Users SET currentSongName=NULL, currentSongGenre=NULL, currentSongArtist=NULL,"
    #                     "currentSongId=NULL,currentLat=NULL,currentLong=NULL WHERE username=%s", [user[0]])
    #         exec_commit("DELETE FROM LocationHistory WHERE username=%s AND playTimeStamp=%s", [user[0], user[1]])
    #         print(user[0] + " has been reset")
    #
    #     sleep(300)

if __name__ == '__main__':
    print("Starting flask")
    print("Starting Database")
    exec_sql_file('deploy.sql')
    # song_checker()
    app.run(debug=True,host='0.0.0.0') #starts Flask

