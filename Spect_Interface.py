import matplotlib.pyplot as plt
import numpy as np
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation
import seaborn
import serial
from time import perf_counter

from matplotlib import style
style.use('ggplot')

CHANNELS = 288
NUM_FRAMES = 100
MAX_INTENSITY = 1024
# x-axis: time (0:NUM_FRAMES)
# y-axis: wavelength (1:CHANNELS)
# z-axis: intensity (0:MAX_INTENSITY)


spect = serial.Serial('COM5', 115200, timeout=1)
snapshots = [[0]* CHANNELS] * CHANNELS

def live_plot(blit):
	x = np.linspace(0, CHANNELS, num = CHANNELS).astype(int)
	y = np.linspace(0, NUM_FRAMES, num = NUM_FRAMES).astype(int)
	X,Y = np.meshgrid(x,y, sparse=False)
	fig = plt.figure()
	ax1 = fig.add_subplot(111)
	
	#ax1.set_xscale(2, 'linear')
	img = ax1.imshow(X, vmin=0, vmax=1024, interpolation = "None", cmap="inferno")
	fig.canvas.draw()   # note that the first draw comes before setting data 
	
	if blit: axbackground = fig.canvas.copy_from_bbox(ax1.bbox)
	
	plt.show(block=False)
	
	while (True):
		start = perf_counter()
			
		datareadstart = perf_counter()
		spect.write(b'r')
		spect.write(10)
		data = (spect.readline().split())
		datareadend = perf_counter()
		print(datareadend - datareadstart)
		if(len(data) == 288):
			data = [float(n) for n in data]
			snapshots.insert(0, data)
			del snapshots[-1]
			img.set_data(snapshots)

		fig.canvas.restore_region(axbackground)
		ax1.draw_artist(img)
		fig.canvas.blit(ax1.bbox)
			
		#else: fig.canvas.draw()
		fig.canvas.flush_events()
		end = perf_counter()
		#print(1.0 / (end - start), " frames per second")


live_plot(True)