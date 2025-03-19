import os
import sys
import datetime
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# file = '~/Documents/dataset/RatCatanese/_resultsForRnn_2019-06-21_13:32.npz' # first really good 0.36 window
file = '~/Documents/dataset/RatCatanese/_resultsForRnn_2019-07-09_15:18.npz'
# file = '~/Documents/dataset/Mouse-797/_resultsForRnn_temp.npz'
# file = '~/Documents/dataset/RatCatanese/_resultsForRnn_temp.npz'


results = np.load(os.path.expanduser(file))
Y_test = results['arr_0']
speed = results['arr_1']
testOutput = results['arr_2']
# trainLosses = results['arr_3']
block=True
lossSelection = .2
maxPos = 253.92


# fig = plt.figure(figsize=(8,8))
# plt.plot(trainLosses[:,0]) 
# plt.plot(trainLosses[:,1]) 
# plt.show(block=block)


# # ERROR & STD
xError = np.abs(testOutput[:,0] - Y_test[:,0])
yError = np.abs(testOutput[:,1] - Y_test[:,1])
Error = np.array([np.sqrt(xError[n]**2 + yError[n]**2) for n in range(len(xError))])
# fig = plt.figure(figsize=(8,8))
# plt.scatter(Error, testOutput[:,2], s=5)
# # plt.plot(Error, testOutput[:,2], 'b.')
# ax = fig.axes[0]
# ax.set_ylabel('evaluated loss')
# ax.set_xlabel('decoding error')
# plt.show(block=block)


tri = np.argsort(speed)
fig, ax = plt.subplots(figsize=(9,15))

selectionHigh = np.where(np.logical_and(
    speed < speed[tri[2*len(tri)//6]],
    testOutput[:,2] > 0.03))
selectionLowRight = np.where(np.logical_and(
    speed < speed[tri[2*len(tri)//6]],
    np.logical_and(
        testOutput[:,2] < 0.03,
        Error > 0.35)))
selectionLowLeft = np.where(np.logical_and(
    speed < speed[tri[2*len(tri)//6]],
    np.logical_and(
        testOutput[:,2] < 0.03,
        Error < 0.35)))

ax1 = plt.subplot2grid((3,2),(0,0))
ax1.scatter(Error[selectionHigh], testOutput[selectionHigh,2], s=5, c='black')
ax1.scatter(Error[selectionLowLeft], testOutput[selectionLowLeft,2], s=5, c='xkcd:light gray')
ax1.scatter(Error[selectionLowRight], testOutput[selectionLowRight,2], s=5, c='xkcd:light gray')
ax1.set_ylabel('evaluated loss')
ax1.set_xlabel('decoding error')

ax2 = plt.subplot2grid((3,2),(1,0), sharex=ax1, sharey=ax1)
ax2.scatter(Error[selectionLowLeft], testOutput[selectionLowLeft,2], s=5, c='black')
ax2.scatter(Error[selectionHigh], testOutput[selectionHigh,2], s=5, c='xkcd:light gray')
ax2.scatter(Error[selectionLowRight], testOutput[selectionLowRight,2], s=5, c='xkcd:light gray')
ax2.set_ylabel('evaluated loss')
ax2.set_xlabel('decoding error')

ax5 = plt.subplot2grid((3,2),(2,0), sharex=ax1, sharey=ax1)
ax5.scatter(Error[selectionLowRight], testOutput[selectionLowRight,2], s=5, c='black')
ax5.scatter(Error[selectionHigh], testOutput[selectionHigh,2], s=5, c='xkcd:light gray')
ax5.scatter(Error[selectionLowLeft], testOutput[selectionLowLeft,2], s=5, c='xkcd:light gray')
ax5.set_ylabel('evaluated loss')
ax5.set_xlabel('decoding error')

# plt.tight_layout()
# plt.savefig(os.path.expanduser('~/Pictures/_tempFig.png'), bbox_inches='tight')
# plt.show()







# fig, ax = plt.subplots(figsize=(30,10))

ax3 = plt.subplot2grid((3,2),(0,1))
ax3.scatter(testOutput[selectionHigh,1]*maxPos, testOutput[selectionHigh,0]*maxPos, marker='P',color='green',label='guessed position')
ax3.scatter(Y_test[selectionHigh,1]*maxPos, Y_test[selectionHigh,0]*maxPos, marker='o',color='red',label='true position')
ax3.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
ax3.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
n = 135; nn=2*n
ax3.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
ax3.legend()

ax4 = plt.subplot2grid((3,2),(1,1))
ax4.scatter(testOutput[selectionLowLeft,1]*maxPos, testOutput[selectionLowLeft,0]*maxPos, marker='P',color='green',label='guessed position')
ax4.scatter(Y_test[selectionLowLeft,1]*maxPos, Y_test[selectionLowLeft,0]*maxPos, marker='o',color='red',label='true position')
ax4.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
ax4.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
n = 135; nn=2*n
ax4.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
ax4.legend()

ax6 = plt.subplot2grid((3,2),(2,1))
ax6.scatter(testOutput[selectionLowRight,1]*maxPos, testOutput[selectionLowRight,0]*maxPos, marker='P',color='green',label='guessed position')
ax6.scatter(Y_test[selectionLowRight,1]*maxPos, Y_test[selectionLowRight,0]*maxPos, marker='o',color='red',label='true position')
ax6.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
ax6.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
n = 135; nn=2*n
ax6.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
ax6.legend()




plt.suptitle('Points of lowest speed (33%) : \nbottom right of U shape points to reward locations', size=20)
# plt.tight_layout()
plt.savefig(os.path.expanduser('~/Pictures/_tempAmbivalentDecoding.png'), bbox_inches='tight')
plt.show()



# print('mean error is:', np.mean(Error)*maxPos)
# tri = np.argsort(testOutput[:,2])
# Selected_errors = np.array([ 
#         np.mean(Error[ tri[0:1*len(tri)//10] ]), 
#         np.mean(Error[ tri[1*len(tri)//10:2*len(tri)//10] ]),
#         np.mean(Error[ tri[2*len(tri)//10:3*len(tri)//10] ]),
#         np.mean(Error[ tri[3*len(tri)//10:4*len(tri)//10] ]),
#         np.mean(Error[ tri[4*len(tri)//10:5*len(tri)//10] ]),
#         np.mean(Error[ tri[5*len(tri)//10:6*len(tri)//10] ]),
#         np.mean(Error[ tri[6*len(tri)//10:7*len(tri)//10] ]),
#         np.mean(Error[ tri[7*len(tri)//10:8*len(tri)//10] ]),
#         np.mean(Error[ tri[8*len(tri)//10:9*len(tri)//10] ]),
#         np.mean(Error[ tri[9*len(tri)//10:len(tri)]       ]) ]) * maxPos
# print("----Selected errors----")
# print(Selected_errors)


# temp = testOutput[:,2]
# temp2 = temp.argsort()
# thresh = temp[temp2[int(len(temp2)*lossSelection)]]
# selection = testOutput[:,2]<thresh
# frames = np.where(selection)[0]


# # Overview
# fig, ax = plt.subplots(figsize=(15,9))
# ax1 = plt.subplot2grid((2,1),(0,0))
# # ax1.plot(testOutput[:,0], label='guessed X')
# ax1.plot(np.where(selection)[0], testOutput[selection,0], label='guessed X selection')
# ax1.plot(Y_test[:,0], label='true X', color='xkcd:dark pink')
# ax1.legend()
# ax1.set_title('position X')

# ax2 = plt.subplot2grid((2,1),(1,0), sharex=ax1)
# # ax2.plot(testOutput[:,1], label='guessed Y')
# ax2.plot(np.where(selection)[0], testOutput[selection,1], label='guessed Y selection')
# ax2.plot(Y_test[:,1], label='true Y', color='xkcd:dark pink')
# ax2.legend()
# ax2.set_title('position Y')

# plt.show(block=block)


# # Movie
# fig, ax = plt.subplots(figsize=(10,10))
# ax1 = plt.subplot2grid((1,1),(0,0))
# im2, = ax1.plot([Y_test[0,1]*maxPos],[Y_test[0,0]*maxPos],marker='o', markersize=15, color="red")
# im2b, = ax1.plot([testOutput[0,1]*maxPos],[testOutput[0,0]*maxPos],marker='P', markersize=15, color="green")

# im3 = ax1.plot([125,170,170,215,215,210,60,45,45,90,90], [35,70,110,210,225,250,250,225,210,110,35], color="red")
# im4 = ax1.plot([125,125,115,90,90,115,125], [100,215,225,220,185,100,100], color="red")
# n = 135; nn=2*n
# im4 = ax1.plot([nn-125,nn-125,nn-115,nn-90,nn-90,nn-115,nn-125], [100,215,225,220,185,100,100], color="red")
# ax1.set_title('Decoding using full stack decoder', size=25)
# ax1.get_xaxis().set_visible(False)
# ax1.get_yaxis().set_visible(False)

# def updatefig(frame, *args):
#     reduced_frame = frame % len(frames)
#     selected_frame = frames[reduced_frame]
#     im2.set_data([Y_test[selected_frame,1]*maxPos],[Y_test[selected_frame,0]*maxPos])
#     im2b.set_data([testOutput[selected_frame,1]*maxPos],[testOutput[selected_frame,0]*maxPos])
#     return im2,im2b

# save_len = len(frames)
# ani = animation.FuncAnimation(fig,updatefig,interval=250, save_count=save_len)
# fig.show()

