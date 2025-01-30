import sys
import os.path
import datetime
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score, accuracy_score, recall_score, precision_score
import tensorflow as tf
import numpy as np
from tqdm import tqdm
from tqdm import trange
import matplotlib as mpl
import matplotlib.pyplot as plt
print(flush=True)
if len(sys.argv)>1 and sys.argv[1]=="gpu":
	device_name = "/gpu:0"
	print('MOBS FULL STAGE ENCODER: DEVICE GPU', flush=True)
elif len(sys.argv)==1 or sys.argv[1]=="cpu":
	device_name = "/cpu:0"
	print('MOBS FULL STAGE ENCODER: DEVICE CPU', flush=True)
else:
	raise ValueError('didn\'t understand arguments calling scripts '+sys.argv[0])


class add_path():
    def __init__(self, path):
        self.path = path

    def __enter__(self):
        for i in range(len(self.path)):
            sys.path.insert(0, self.path[i])

    def __exit__(self, exc_type, exc_value, traceback):
        for i in range(len(self.path)):
            sys.path.remove(self.path[i])



### Data
print('loading data')
Results = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/_rawSpikesForRnn.npz'), allow_pickle=True)
SPT_train = Results['arr_0']
SPT_test = Results['arr_1']
GRP_train = Results['arr_2']
GRP_test = Results['arr_3']
SPK_train = Results['arr_4']
SPK_test = Results['arr_5']
POS_train = Results['arr_6']
POS_test = Results['arr_7']
SPD_train = Results['arr_8']
SPD_test = Results['arr_9']
loaded='data loaded'
print(loaded)










### Params
nGroups = np.max(GRP_train) + 1
dim_output = POS_train.shape[1]
nChannels = SPK_train[0].shape[0]
length = len(SPK_train)

nSteps = 10000
nFeatures = 128
lstmLayers = 3
lstmSize = 128
lstmDropout = 0.3

windowLength = 0.036 # in seconds, as all things should be
batch_size = 52
timeMajor = True

learningRates = [0.0003, 0.00003, 0.00001]
lossLearningRate = 0.00003
lossActivation = None











# Figure out what will be the maximum length of a spike sequence for our windowLength
maxLength = 0
n = 0
bin_stop = SPT_train[0]
while True:
	bin_stop = bin_stop + windowLength
	if bin_stop > SPT_train[-1]:
		maxLength = max(maxLength, len(SPT_train)-idx)
		break
	idx=n
	while SPT_train[n] < bin_stop:
		n += 1
	maxLength = max(maxLength, n-idx)



def selectGroup(spk,grp,n, training):
	spk = tf.cast(spk, tf.float32)
	goodIndex = tf.cast(tf.equal(grp,n), tf.int32)
	idx = tf.where(goodIndex)
	res = tf.gather(spk, idx)
	res = res[:,0,:,:]

	if training:
		idMatrix = tf.eye(batch_size*maxLength)
	else:
		idMatrix = tf.eye(int(spk.get_shape()[0]))
	completionTensor = tf.gather(idMatrix, idx)

	res = (res, tf.transpose(completionTensor[:,0,:], [1,0]))
	return res

def parse_data_batch(training, timeMajor, *vals):
	# print(vals[0]) # length, int64, shape=(batch_size)
	# print(vals[1]) # group, int64, shape=(batch_size, maxLength), padded with -1
	# print(vals[2]) # spike, float64, shape=(batch_size, maxLength,4,32), padded with 0
	# print(vals[3]) # position, float64, shape=(batch_size,2)

	if training and timeMajor:
		grp = tf.reshape(tf.transpose(vals[1], [1,0]),     [batch_size*maxLength])
		spk = tf.reshape(tf.transpose(vals[2], [1,0,2,3]), [batch_size*maxLength, 4, 32])
	else:
		grp = vals[1]
		spk = vals[2]

	res = sum((selectGroup(spk, grp, n, training) for n in range(nGroups)), tuple([]))

	return  (vals[3], vals[0]) + res


def sequenceGenerator(training, groups, times, spikes, positions):

	totalLength = times[-1] - times[0]
	nBins = int(totalLength // windowLength) - 1
	binStartTime = [times[0] + (i*windowLength) for i in range(nBins)]
	if training:
		np.random.shuffle(binStartTime)

	lengthSelection = []
	groupSelection = []
	spikeSelection = []
	positionSelection = []
	print('preparing data parser.')
	for bin_start in tqdm(binStartTime):
		selection = np.where(np.logical_and(
			times >= bin_start,
			times < bin_start + windowLength))
		lengthSelection.append(len(selection[0]))
		groupSelection.append(groups[selection])
		spikeSelection.append(spikes[selection])
		positionSelection.append(positions[selection])
	while True:
		for bin in range(len(binStartTime)):
			if lengthSelection[bin]==0:
				continue
			yield (
				lengthSelection[bin],
				np.pad(groupSelection[bin], (0, maxLength-lengthSelection[bin]), 'constant', constant_values=-1), 
				np.pad(spikeSelection[bin], ((0, maxLength-lengthSelection[bin]),(0,0),(0,0)), 'constant', constant_values=0), 
				np.mean(positionSelection[bin], axis=0))



def makeDataset(training=False, timeMajor=False):
	''' timeMajor is a bool to say if time dimension or batch dimension is first '''

	groupsPH = tf.placeholder(tf.int64, shape=[None])
	timePH   = tf.placeholder(tf.float64, shape=[None])
	spikesPH = tf.placeholder(tf.float64, shape=[None,4,32])
	posPH    = tf.placeholder(tf.float64, shape=[None,2])

	temp = tf.data.Dataset
	temp = temp.from_generator(sequenceGenerator, 
		output_types = (
			tf.int64,
			tf.int64, 
			tf.float64, 
			tf.float64),
		output_shapes = (
			tf.TensorShape([]),
			tf.TensorShape([maxLength]),
			tf.TensorShape([maxLength, 4, 32]),
			tf.TensorShape([2])),
		args = (training, groupsPH, timePH, spikesPH, posPH))
	
	if training:
		temp = temp.batch(batch_size, drop_remainder=True)
	temp = temp.map(lambda *args: parse_data_batch(training, timeMajor, *args))
	it   = temp.make_initializable_iterator()
	return it, it.get_next(), {'groups':groupsPH, 'timeStamps':timePH, 'spikes':spikesPH, 'positions':posPH}


def last_relevant(output, length, timeMajor=False):
	''' Used to select the right output of 
		tf.rnn.dynamic_rnn for sequences of variable sizes '''
	if timeMajor:
		output = tf.transpose(output, [1,0,2])
	batch_size = tf.shape(output)[0]
	max_length = tf.shape(output)[1]
	out_size = int(output.get_shape()[2])
	index = tf.range(0, batch_size) * max_length + tf.cast(length - 1, tf.int32)
	flat = tf.reshape(output, [-1, out_size])
	relevant = tf.gather(flat, index)
	return relevant







def layerLSTM(lstmSize, dropout=0.0):
	cell = tf.contrib.rnn.LSTMBlockCell(lstmSize)
	return tf.nn.rnn_cell.DropoutWrapper(cell, input_keep_prob=1.0, output_keep_prob=1.0, state_keep_prob=1-dropout)

class spikeNet:
	def __init__(self, nChannels=4, device="/cpu:0", nFeatures=128):
		self.nFeatures = nFeatures
		self.nChannels = nChannels
		self.device = device
		with tf.device(self.device):
			self.convLayer1 = tf.layers.Conv2D(8, [2,3], padding='SAME')
			self.convLayer2 = tf.layers.Conv2D(16, [2,3], padding='SAME')
			self.convLayer3 = tf.layers.Conv2D(32, [2,3], padding='SAME')

			self.maxPoolLayer1 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')
			self.maxPoolLayer2 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')
			self.maxPoolLayer3 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')

			self.dropoutLayer = tf.layers.Dropout(0.5)
			self.denseLayer1 = tf.layers.Dense(self.nFeatures, activation='relu')
			self.denseLayer2 = tf.layers.Dense(self.nFeatures, activation='relu')
			self.denseLayer3 = tf.layers.Dense(self.nFeatures, activation='relu')

	def __call__(self, input):
		return self.apply(input)

	def apply(self, input):
		with tf.device(self.device):
			x = tf.expand_dims(input, axis=3)
			x = self.convLayer1(x)
			x = self.maxPoolLayer1(x)
			x = self.convLayer2(x)
			x = self.maxPoolLayer2(x)
			x = self.convLayer3(x)
			x = self.maxPoolLayer3(x)

			x = tf.reshape(x, [-1, self.nChannels*4*32])
			x = self.denseLayer1(x)
			x = self.dropoutLayer(x)
			x = self.denseLayer2(x)
			x = self.denseLayer3(x)
		return x

	def variables(self):
		return self.convLayer1.variables + self.convLayer2.variables + self.convLayer3.variables + \
			self.maxPoolLayer1.variables + self.maxPoolLayer2.variables + self.maxPoolLayer3.variables + \
			self.denseLayer1.variables + self.denseLayer2.variables + self.denseLayer3.variables











### Inferring model
variables=[]
with tf.Graph().as_default():
	print()
	print()
	print('INFERRING')
	inferSpkNet = []
	dataIterator, testingTensors, dataPlaceholders = makeDataset(training=False, timeMajor=timeMajor)
	
	with tf.device("/cpu:0"):
		inferringFeedDict = []
		embeddings = []
		for group in range(nGroups):
			inferSpkNet.append(spikeNet(nChannels=nChannels, device="/cpu:0", nFeatures=nFeatures))

			out = inferSpkNet[group].apply(testingTensors[2*group+2])
			embeddings.append(tf.matmul(testingTensors[2*group+3], out))
			variables += inferSpkNet[group].variables()
		embeddings = tf.tuple(embeddings)
		fullEmbedding = tf.concat(embeddings, axis=1)
		
		with tf.variable_scope("cudnn_lstm"):
			lstm = tf.nn.rnn_cell.MultiRNNCell([tf.contrib.cudnn_rnn.CudnnCompatibleLSTMCell(lstmSize) for _ in range(lstmLayers)])
			outputs, finalState = tf.nn.dynamic_rnn(
				lstm, 
				tf.expand_dims(fullEmbedding, axis=1), 
				dtype=tf.float32, 
				time_major=timeMajor, 
				sequence_length=tf.expand_dims(testingTensors[1],0))
			variables += lstm.variables

		##########
		lstmWeights_i, lstmWeights_j, lstmWeights_f, lstmWeights_o = tf.split(lstm.variables[0], 4, axis=1)
		lstmBias_i,    lstmBias_j,    lstmBias_f,    lstmBias_o    = tf.split(lstm.variables[1], 4, axis=0)

		inputWeights_i, stateWeights_i = tf.split(lstmWeights_i, [nGroups*nFeatures, lstmSize], axis=0)
		inputWeights_j, stateWeights_j = tf.split(lstmWeights_j, [nGroups*nFeatures, lstmSize], axis=0)
		inputWeights_f, stateWeights_f = tf.split(lstmWeights_f, [nGroups*nFeatures, lstmSize], axis=0)
		inputWeights_o, stateWeights_o = tf.split(lstmWeights_o, [nGroups*nFeatures, lstmSize], axis=0)

		h_state = tf.zeros([1, lstmSize], tf.float32)
		c_state = tf.zeros([1, lstmSize], tf.float32)

		forgetHistory = []
		for n in range(maxLength):
			forgetGate = tf.sigmoid(tf.add(
				tf.add(tf.matmul(tf.expand_dims(tf.gather_nd(fullEmbedding, [n]),0), inputWeights_f), lstmBias_f),
				tf.add(tf.matmul(h_state, stateWeights_f), lstmBias_f)))
			inputGate = tf.sigmoid(tf.add(
				tf.add(tf.matmul(tf.expand_dims(tf.gather_nd(fullEmbedding, [n]),0), inputWeights_i), lstmBias_i),
				tf.add(tf.matmul(h_state, stateWeights_i), lstmBias_i)))
			outputGate = tf.sigmoid(tf.add(
				tf.add(tf.matmul(tf.expand_dims(tf.gather_nd(fullEmbedding, [n]),0), inputWeights_o), lstmBias_o),
				tf.add(tf.matmul(h_state, stateWeights_o), lstmBias_o)))
			new_c_state = tf.tanh(tf.add(
				tf.add(tf.matmul(tf.expand_dims(tf.gather_nd(fullEmbedding, [n]),0), inputWeights_j), lstmBias_j),
				tf.add(tf.matmul(h_state, stateWeights_j), lstmBias_j)))

			c_state = tf.add(
				tf.multiply(c_state, forgetGate),
				tf.multiply(new_c_state, inputGate))
			h_state = tf.multiply(tf.tanh(c_state), outputGate)

			forgetHistory.append(forgetGate)		
		forgetHistory = tf.reduce_mean(tf.concat(forgetHistory, axis=0), axis=1)
		#############


		output = last_relevant(outputs, testingTensors[1], timeMajor=timeMajor)
		denseOutput = tf.layers.Dense(dim_output, activation = None, name="pos")
		denseLoss1  = tf.layers.Dense(lstmSize, activation = tf.nn.relu, name="loss1")
		denseLoss2  = tf.layers.Dense(1, activation = lossActivation, name="loss2")

		position = tf.reshape(denseOutput(tf.reshape(output, [-1,lstmSize])), [2])
		loss     = tf.reshape(denseLoss2(denseLoss1(tf.reshape(output, [-1,lstmSize]))), [1])
		variables += denseOutput.variables
		variables += denseLoss1.variables
		variables += denseLoss2.variables
		
		subGraphToRestore = tf.train.Saver({v.op.name: v for v in variables})

		
	

	### Inferring
	with tf.Session() as sess:
		subGraphToRestore.restore(sess, os.path.expanduser('~/Documents/dataset/RatCatanese/_graphForRnn'))
		sess.run(dataIterator.initializer, 
			feed_dict={dataPlaceholders['groups']:GRP_test, 
			dataPlaceholders['timeStamps']:SPT_test, 
			dataPlaceholders['spikes']:SPK_test, 
			dataPlaceholders['positions']:POS_test / np.max(POS_train)})


		testOutput = []
		lengths = []
		forgetMeans = []
		for bin in trange(int((SPT_test[-1]-SPT_test[0])//windowLength)-1):
			inferredOutput = sess.run([position, loss, forgetHistory, testingTensors[1]])
			testOutput.append(np.concatenate([inferredOutput[0], inferredOutput[1]], axis=0))
			lengths.append(inferredOutput[3])
			forgetMeans.append(inferredOutput[2])


	

	
	testOutput = np.array(testOutput)

	pos = []
	spd = []
	n = 0
	bin_stop = SPT_test[0]
	while True:
		bin_stop = bin_stop + windowLength
		if bin_stop > SPT_test[-1]:
			break
		idx=n
		while SPT_test[n] < bin_stop:
			n += 1
		pos.append(np.mean(POS_test[idx:n,:], axis=0))
		spd.append(np.mean(SPD_test[idx:n,:]))
	pos.pop()
	spd.pop()
	pos = np.array(pos) / np.max(POS_train)
	spd = np.array(spd)
	
	# fileName = '~/Documents/dataset/RatCatanese/_resultsForRnn_temp'
	# np.savez(os.path.expanduser(fileName), pos, spd, testOutput, [])





temp = testOutput[:,2]
temp2 = temp.argsort()
thresh = temp[temp2[int(len(temp2)*.2)]]
selection = testOutput[:,2]<thresh
frames = np.where(selection)[0]
# Overview
fig, ax = plt.subplots(figsize=(15,9))
ax1 = plt.subplot2grid((2,1),(0,0))
ax1.plot(testOutput[:,0], label='guessed X')
# ax1.plot(np.where(selection)[0], testOutput[selection,0], label='guessed X selection')
ax1.plot(pos[:,0], label='true X', color='xkcd:dark pink')
line1 = ax1.axvline(0, color='k')
ax1.legend()
ax1.set_title('position X')

ax2 = plt.subplot2grid((2,1),(1,0), sharex=ax1)
ax2.plot(testOutput[:,1], label='guessed Y')
# ax2.plot(np.where(selection)[0], testOutput[selection,1], label='guessed Y selection')
ax2.plot(pos[:,1], label='true Y', color='xkcd:dark pink')
line2 = ax2.axvline(0, color='k')
ax2.legend()
ax2.set_title('position Y')

fig2 = plt.figure(figsize=(15,5))
forgetLine = plt.plot(forgetMeans[0][:lengths[0]])
plt.xlim([0,maxLength])

def onclick(event):
    print('%s click: button=%d, x=%d, y=%d, xdata=%f, ydata=%f' %
          ('double' if event.dblclick else 'single', event.button,
           event.x, event.y, event.xdata, event.ydata))
    line1.set_xdata([int(event.xdata), int(event.xdata)])
    line2.set_xdata([int(event.xdata), int(event.xdata)])
    forgetLine[0].set_data([n for n in range(lengths[int(event.xdata)])], forgetMeans[int(event.xdata)][:lengths[int(event.xdata)]])
    fig.canvas.draw() ; fig.canvas.flush_events()
    fig2.canvas.draw() ; fig2.canvas.flush_events()
cid = fig.canvas.mpl_connect('button_press_event', onclick)

fig.show()
fig2.show()