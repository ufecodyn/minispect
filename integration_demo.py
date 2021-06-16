import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np
import math
import serial
import sys

CHANNELS = 288


# Connects to the first available device on COM ports, cycling starting from 0. Will generally connect to your arduino if you only have one connected. 
def connect(portnum):
    if(portnum < 30):
        try:
            spect = serial.Serial('COM' + str(portnum), 115200, timeout=1)
            print("Connected on port COM" + str(portnum))
            return spect
        except:
            return connect(portnum + 1)
    else:
        print("Could not connect to spectrometer!")
        return None

spect = connect(0)

# Fetch data by sending the integration time to the 
def update(integrationCycles):
    # print("Integration Time: 13.5us + (", integrationCycles, "* 0.5625 us) = ", integrationCycles * 0.5625 + 13.5, "us")
    spect.write(b'r' + str(integrationCycles).encode())
    data = spect.readline().split()
    convertedToInt = []
    for d in data:
        convertedToInt.append(int(d.decode("utf-8")))

    #print(convertedToInt)
    return convertedToInt

def init():
    line.set_data(x, np.zeros(CHANNELS))
    return line,

fig, ax = plt.subplots()
data = np.zeros(CHANNELS)
x = np.arange(0, CHANNELS, step=1)
#x = np.linspace(340, 850, num=CHANNELS)
line, = ax.plot(x, data)

def animate(intTime):
    line.set_data(x, update(intTime))
    return line,

def plot(intTime):
    # plt.plot(update(intTime))
    ani = animation.FuncAnimation(
        fig, 
        animate,
        init_func = init,
        interval = 2, 
        blit = True,
        save_count = 50
    )
    plt.show()

def auto_integration_time(start):
    print("\tIntegration Time:", start)
    upper = 875
    lower = 825
    data = update(int(start))
    if (len(data) == 0):
        return auto_integration_time(start)
    else:
        try:
            m = max(data)
            print('\t\tMax:', m)
            if(m <= upper and m >= lower): 
                return start
            elif(m > upper):
                return auto_integration_time(int(start * 0.6))
            elif(m < lower):
                return auto_integration_time(int(start + 1))
        except:
            return start


def auto_integration_time_improved(time, target):
    span = 10
    samples = 3

    print("\tIntegration Time:", time)
    m = 0
    data = update(int(time))


    if(len(data) == 0):
        return auto_integration_time_improved(time, target)
    else:
        m = m + max(data)
        for i in range(samples - 1):
            data = update(int(time))
            m = m + max(data)
            
        m = m / samples
        print('\t\tMax Avg:', m)

        k = m / float(math.log(time))
        diff = m - target
        if(abs(diff) < span):
            return time
        else:
            return auto_integration_time_improved(time - (k / diff), target)



if __name__ == "__main__":
    state = 'z'
    intTime = 10
    while(state != 'x'):
        print("Current Integration Time:", intTime)
        print("Select an Option:")
        print("\t(a) Auto-Set Integration Time")
        print("\t(b) Take 10 samples at current int time")
        print("\t(c) Take 10 samples at specific int time (ms)")
        print("\t(d) Single Plot")
        print("\t(e) Live Plot")
        print("\t(x) Exit")
        state = input()
        if(state == 'a'):
            intTime = auto_integration_time_improved(intTime, 850)
            print("Integration Time set to", intTime)
        elif(state == 'b'):
            for i in range (0, 10):
                print(update(intTime))
        elif(state == 'c'):
            print("Please enter your integration time")
            custInt = 0
            custInt = int(input())
            for i in range (0, 10):
                print(update(custInt))
        elif(state == 'd'):
            sets = []
            for i in range (0, 10):
                sets.append(update(intTime))
            sum = sets[0]
            for i in range (1, len(sets)):
                sum = np.array(sum) + np.array(sets[i])
            sum = np.array(sum) / 10

            plt.plot(sum)
            plt.show()
            
        elif(state == 'e'):
            plot(intTime)

