# Creating a Web server using Python and Flask
import time

class Timer:
    def __init__(self):
        self.start = time.time()
        self.end = None

    def timeTaken(self):
        return 1000 * (time.time() - self.start)

timers = {}


from flask import Flask

app = Flask('app')

@app.route('/timer/start/<timerid>')
def markStart(timerid):
    print("StartMarked recieved")
    timers[timerid] = Timer()
    return 'start marked'

@app.route('/timer/stop/<timerid>')
def markEnd(timerid):
    timeTaken = timers[timerid].timeTaken()
    print("EndMarked " + str(timeTaken))
    return str(timeTaken)

@app.route('/timer/reset')
def resetTimers():
    global timers
    timers = {}
    print("Removed all timers")
    return 'timers reset'

app.run(host = 'localhost', port = 1575)