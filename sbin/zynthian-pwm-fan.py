#!/usr/bin/python3

import os
import signal
from time import sleep
import RPi.GPIO as GPIO

# Configuration Items
fan_pin = 13
fan_freq = 100
fan_startup = 30.
fan_min = 30.
poll_sec = 1 

# Linear interpolation from 2 points upper_temp, lower_temp, upper_speed, lower_speed
temp_1 = 70.
temp_2 = 30. 
speed_1 = 100.
speed_2 = 1.
smooth_beta = 0.025

# Setup linear interpolation constants
scale_m = (speed_2 - speed_1) / (temp_2 - temp_1)
scale_b = speed_1 - (scale_m * temp_1)
#fn(speed_x) = (scale_m * temp_x) + scale_b
#fn(temp_x) =  (speed_x - scale_b) / scale_m


# Catch some signals, and set a time to quit var
class SignalMonitor:
	now = False

	def __init__(self):
		signal.signal(signal.SIGINT, self.time_to_quit)
		signal.signal(signal.SIGTERM, self.time_to_quit)

	def time_to_quit(self, signum, frame):
		self.now = True


# Get the raspberry pi cpu temperature
def measure_temp():
	temp = os.popen("vcgencmd measure_temp").readline()   # returns temp=50.0'C
	raw_tmp = temp.replace("temp=", "")                   # strip off temp=
	flt_tmp = float(raw_tmp.replace("'C", ""))            # strip off `C and convert to float
	int_tmp = int(flt_tmp)                                # convert to int since all temps are whole degrees only
	return int_tmp


# Not below, used to set a lower bound for the fan.
def not_below(bound, x):
	retval = x
	if x < bound:
		retval = bound
	return retval


GPIO.setmode(GPIO.BOARD)
# Disable warnings about already in use
GPIO.setwarnings(False)
# Setup GPIO Pins
GPIO.setup(fan_pin, GPIO.OUT)
pwm_fan = GPIO.PWM(fan_pin, fan_freq)

try:
	if __name__ == '__main__':
		print("Fan PWM GPIO Pin", fan_pin, "Frequency", fan_freq, "Hz")
		smooth_speed = fan_startup

		TimeToQuit = SignalMonitor()
		while not TimeToQuit.now:
			temp_x = measure_temp()
			speed_x = (scale_m * temp_x) + scale_b
			smooth_speed = not_below(fan_min, smooth_speed - (smooth_beta * (smooth_speed - speed_x)))
			#print "Temp is ", temp_x, "Speed is ", smooth_speed, "raw ",speed_x
			pwm_fan.start(smooth_speed)
			sleep(poll_sec)

except Exception as e:
	print(f"Exception: {e}")

finally:
	pwm_fan.stop()
	GPIO.cleanup()

