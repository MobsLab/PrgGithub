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


def UnifySpikes(Data):
	print('processing data...')


	length = 0
	for group in range(Data['nGroups']):
		length += len(Data['spikes_time'][group])
	# length = 10000
	groups = [grp for grp in range(Data['nGroups'])]

	unifiedSpikes = [[np.zeros([0,4,32]) for _ in range(Data['nGroups'])] for _ in range(length)]
	positions = np.zeros([length, 2])

	for spk in tqdm(range(length)):

		# Determine from which group the next spike is going to be
		nextGroup = np.argmin([Data['spikes_time'][grp][0] for grp in range(len(Data['spikes_time']))])

		# Build the spike vector
		unifiedSpikes[spk][groups[nextGroup]] = Data['spikes_all'][nextGroup][0].reshape([1,4,32])
		positions[spk,:] = Data['positions'][np.argmin(np.abs(Data['spikes_time'][nextGroup][0] - Data['position_time']))]

		# Erase the spike from memory
		Data['spikes_time'][nextGroup] = Data['spikes_time'][nextGroup][1:]
		Data['spikes_all'][nextGroup]  = Data['spikes_all'][nextGroup][1:]
		if len(Data['spikes_time'][nextGroup])==0 or len(Data['spikes_all'][nextGroup])==0:
			Data['spikes_time'].pop(nextGroup)
			Data['spikes_all'].pop(nextGroup)
			groups.pop(nextGroup)

	return unifiedSpikes, positions

def idMatrixRows(size):
	IDMatrix = np.identity(size)
	for n in range(size):
		yield IDMatrix[n]

def makeBatch(x, y, batch_size, n_spikes_perBatch, timeMajor=False):
	''' timeMajor is a bool to say if time dimension or batch dimension is first '''

	if not timeMajor:
		raise ValueError('timeMajor False is not yet implemented')
	
	idx = np.arange(0, len(x)-n_spikes_perBatch-1)
	np.random.shuffle(idx)
	idx = idx[:batch_size]

	spikeInfo = []
	spikeInfo.append(y[idx, :])
	for group in range(len(x[0])):
		spikes = [x[idx[b]+spk][group] for spk in range(n_spikes_perBatch) for b in range(batch_size)]
		spikeInfo.append(np.concatenate(spikes, axis=0))

		nGroupSpikes = spikeInfo[1+2*group].shape[0]
		rows = idMatrixRows(nGroupSpikes)
		spikeInfo.append(np.array([np.zeros(nGroupSpikes) 
			if spikes[spk].shape[0]==0 else next(rows) 
			for spk in range(batch_size*n_spikes_perBatch)]))

	return spikeInfo

def layerLSTM(lstmSize, dropout=0.0):
	cell = tf.contrib.rnn.LSTMBlockCell(lstmSize)
	return tf.nn.rnn_cell.DropoutWrapper(cell, input_keep_prob=1.0, output_keep_prob=1.0, state_keep_prob=1-dropout)

class spikeNet:
	def __init__(self, nChannels):
		self.nFeatures = 128
		self.nChannels = nChannels
		self.convLayer1 = tf.layers.Conv2D(8, [2,3], padding='SAME')
		self.convLayer2 = tf.layers.Conv2D(16, [2,3], padding='SAME')
		self.convLayer3 = tf.layers.Conv2D(32, [2,3], padding='SAME')

		self.maxPoolLayer1 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')
		self.maxPoolLayer2 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')
		self.maxPoolLayer3 = tf.layers.MaxPooling2D([1,2], [1,2], padding='SAME')

		self.dropoutLayer = tf.layers.Dropout(0.5)
		self.denseLayer1 = tf.layers.Dense(self.nFeatures, activation='relu')
		self.denseLayer2 = tf.layers.Dense(self.nFeatures, activation='relu')
		self.denseLayer3 = tf.layers.Dense(self.nFeatures, activation='relu') # shape : [None, nFeatures]

	def apply(self, input):
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



### Data
# print('loading')
# Data = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/mobsEncoding_2019-05-22_13:07/_data.npy')).item()
# print('loaded')

# X_data, Y_data = UnifySpikes(Data)
# X_train, X_test, Y_train, Y_test = train_test_split(X_data, Y_data, test_size=0.1, shuffle=False, random_state=42)
# X_train, X_validation, Y_train, Y_validation = train_test_split(X_train, Y_train, test_size=0.1, shuffle=False, random_state=42)
# np.savez(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn'), X_train, X_validation, X_test, Y_train, Y_validation, Y_test)
# bbb
print('loading')
Results = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn.npz'), allow_pickle=True)
X_train = Results['arr_0']
X_validation = Results['arr_1']
X_test = Results['arr_2']
Y_train = Results['arr_3']
Y_validation = Results['arr_4']
Y_test = Results['arr_5']
print('loaded')


### Params
nGroups = len(X_train[0])
nSteps = 5000
lstmSize = 128
dim_output = Y_train[0].shape[0]
batch_size = 50
n_spikes_perBatch = 50
timeMajor = True


### Training model
y = tf.placeholder(tf.float32, [batch_size, dim_output])
spkParserNet = []
allFeatures = []

trainingFeedDict = [y]
for group in range(nGroups):
	nChannels = X_train[0][group].shape[1]
	spkParserNet.append(spikeNet(nChannels))

	## the None dimension is the number of spike on this tetrode in the batch (it is always less than batch_size*n_spikes_perBatch)
	trainingFeedDict.append( tf.placeholder(tf.float32, [None, nChannels, 32]) )
	x = spkParserNet[group].apply(trainingFeedDict[-1])
	trainingFeedDict.append( tf.placeholder(tf.float32, [batch_size*n_spikes_perBatch, None]) )

	x = tf.reshape(tf.matmul(trainingFeedDict[-1], x), [n_spikes_perBatch, batch_size, spkParserNet[group].nFeatures])
	allFeatures.append( x )

allFeatures = tf.concat(allFeatures, axis=2)

lstm = [layerLSTM(lstmSize, dropout=0.3), layerLSTM(lstmSize, dropout=0.3)]
lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
outputs, finalState = tf.nn.dynamic_rnn(lstm, allFeatures, dtype=tf.float32, time_major=timeMajor)
dense = tf.layers.Dense(dim_output, activation = None)
output = dense(outputs[-1])

cost = tf.losses.mean_squared_error(output, y)
optimizerHigh = tf.train.RMSPropOptimizer(0.003).minimize(cost)
optimizerLow  = tf.train.RMSPropOptimizer(0.0003).minimize(cost)


### Inferring model
inferringFeedDict = []
embeddings = []
for group in range(nGroups):
	nChannels = X_train[0][group].shape[1]
	inferringFeedDict.append( tf.placeholder(tf.float32, [None, nChannels, 32]) )
	out = spkParserNet[group].apply(inferringFeedDict[-1])
	embeddings.append(tf.reduce_sum(out, axis=0))
fullEmbedding = tf.concat(embeddings, axis=0)
initial_state = lstm.zero_state(1, dtype=tf.float32)
output, state = lstm(tf.expand_dims(fullEmbedding, axis=0), initial_state)
output = tf.reshape(dense(tf.reshape(output, [-1,lstmSize])), [2])
inferringFeedDict.append(initial_state)












### Training and testing
trainLosses = []
validationLosses = []
plt.ion()
fig = plt.figure(figsize=(8,8))
lossPlot,       = plt.plot(trainLosses)
validationPlot, = plt.plot(validationLosses)

with tf.Session() as sess:
	sess.run(tf.group(tf.global_variables_initializer(), tf.local_variables_initializer()))

	### training
	epoch_loss = 0
	loopSize = 10
	t = trange(nSteps, desc='Bar desc', leave=True)
	for i in t:
		feedBatch = makeBatch(X_train, Y_train, batch_size, n_spikes_perBatch, timeMajor=timeMajor)

		if i < nSteps /2:
			_, c = sess.run([optimizerHigh, cost], feed_dict={i:j for i,j in zip(trainingFeedDict, feedBatch)})
		else:
			_, c = sess.run([optimizerLow, cost], feed_dict={i:j for i,j in zip(trainingFeedDict, feedBatch)})
		epoch_loss += c
		
		if i%loopSize==0 and (i != 0):
			feedBatch = makeBatch(X_validation, Y_validation, batch_size, n_spikes_perBatch, timeMajor=timeMajor)
			validationLosses.append( cost.eval({i:j for i,j in zip(trainingFeedDict, feedBatch)}) )

			t.set_description("loss: %d" % (epoch_loss/loopSize))
			t.refresh()
			trainLosses.append(epoch_loss/loopSize)
			lossPlot      .set_data([range(len(trainLosses)),      trainLosses])
			validationPlot.set_data([range(len(validationLosses)), validationLosses])
			plt.xlim([0,len(trainLosses)])
			plt.ylim([0, np.max(trainLosses[:30])])
			fig.canvas.draw() ; fig.canvas.flush_events()
			epoch_loss=0
	print()

	
	### inferring
	testOutput = []
	currentState = sess.run([initial_state])
	for spk in trange(len(X_test)):
		input = list(X_test[spk]) ; input.append(currentState)
		temp, currentState = sess.run(
			[output, state], 
			feed_dict={i:j for i,j in zip(inferringFeedDict, input)})
		testOutput.append(temp)
	testOutput = np.array(testOutput)

	fig, ax = plt.subplots(figsize=(50,30))
	ax1 = plt.subplot2grid((2,1),(0,0))
	ax1.plot(Y_test[:,0], label='true X')
	ax1.plot(testOutput[:,0], label='guessed X')
	ax1.legend()
	ax1.set_title('position X')

	ax2 = plt.subplot2grid((2,1),(1,0), sharex=ax1)
	ax2.plot(Y_test[:,1], label='true Y')
	ax2.plot(testOutput[:,1], label='guessed Y')
	ax2.legend()
	ax2.set_title('position Y')

	plt.show()


np.savez(os.path.expanduser('~/Documents/dataset/RatCatanese/_resultsForRnn_')+datetime.datetime.now().strftime("%Y-%m-%d_%H:%M"), Y_test, testOutput, trainLosses, validationLosses)