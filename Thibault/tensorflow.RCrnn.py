import datetime
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score, accuracy_score, recall_score, precision_score
import tensorflow as tf
import numpy as np
import pandas as pd
from tqdm import tqdm
from tqdm import trange
import matplotlib as mpl
import matplotlib.pyplot as plt

# tf.enable_eager_execution()

def UnifyClusters(Data):
	print('processing data...')


	length = 0
	for group in range(Data['nGroups']):
		length += len(Data['spikes_time'][group])
	groups = [grp for grp in range(Data['nGroups'])]

	unifiedLabels = np.zeros([length, Data['nClusters']])
	positions = np.zeros([length, 2])

	for spk in tqdm(range(length)):

		# Determine from which group the next spike is going to be
		nextGroup = np.argmin([Data['spikes_time'][grp][0] for grp in range(len(Data['spikes_time']))])

		# Build the label vector
		cluidx = int(np.sum(Data['clustersPerGroup'][:groups[nextGroup]]))
		cluidx += np.argmax(Data['labels_all'][nextGroup][0])

		unifiedLabels[spk, cluidx] = 1
		positions[spk,:] = Data['positions'][np.argmin(np.abs(Data['spikes_time'][nextGroup][0] - Data['position_time']))]

		# Erase the spike from memory
		Data['spikes_time'][nextGroup] = Data['spikes_time'][nextGroup][1:]
		Data['labels_all'][nextGroup]  = Data['labels_all'][nextGroup][1:]
		if len(Data['spikes_time'][nextGroup])==0 or len(Data['labels_all'][nextGroup])==0:
			Data['spikes_time'].pop(nextGroup)
			Data['labels_all'].pop(nextGroup)
			groups.pop(nextGroup)

	return unifiedLabels, positions

def makeBatch(x, y, batch_size, n_spikes_perBatch, timeMajor=False):
	''' timeMajor is a bool to say if time dimension or batch dimension is first '''

	idx = np.arange(0, len(x)-n_spikes_perBatch-1)
	np.random.shuffle(idx)

	if timeMajor:
		xBatched = np.zeros([n_spikes_perBatch, batch_size, x.shape[1]])
	else:
		xBatched = np.zeros([batch_size, n_spikes_perBatch, x.shape[1]])
	yBatched = np.zeros([batch_size, y.shape[1]])

	for b in range(batch_size):
		yBatched[b, :] = y[idx[b], :]
		for spk in range(n_spikes_perBatch):
			if timeMajor:
				xBatched[spk, b, :] = x[idx[b]+spk, :]
			else:
				xBatched[b, spk, :] = x[idx[b]+spk, :]

	return xBatched, yBatched

def layerLSTM(n_units, dropout=0.0):
	cell = tf.contrib.rnn.LSTMBlockCell(n_units)
	return tf.nn.rnn_cell.DropoutWrapper(cell, input_keep_prob=1.0, output_keep_prob=1.0, state_keep_prob=1-dropout)



### Data
# print('loading')
# Data = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-05-02_13:56/_data.npy').item()
# print('loaded')

# X_data, Y_data = UnifyClusters(Data)
# X_train, X_test, Y_train, Y_test = train_test_split(X_data, Y_data, test_size=0.1, shuffle=False, random_state=42)
# np.savez('/home/mobshamilton/Documents/dataset/RatCatanese/_labelsForRnn', X_train, X_test, Y_train, Y_test)
# bbb
Results = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/_labelsForRnn.npz')
X_train = Results['arr_0']
X_test = Results['arr_1']
Y_train = Results['arr_2']
Y_test = Results['arr_3']

X_train, X_validation, Y_train, Y_validation = train_test_split(X_train, Y_train, test_size=0.1, shuffle=False, random_state=42)




### Params
nSteps = 20000
n_units = 128
n_lstmLayers = 1
dim_output = 2
n_features = 181
# n_features = Data['nClusters']
batch_size = 50
n_spikes_perBatch = 50
timeMajor = True


### Training model
x = tf.placeholder(tf.float32, [n_spikes_perBatch, None, n_features])
y = tf.placeholder(tf.float32, [None, dim_output])
dense = tf.layers.Dense(dim_output, activation = None)
lstm = [layerLSTM(n_units, dropout=0.3), layerLSTM(n_units)]
lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
outputs, finalState = tf.nn.dynamic_rnn(lstm, x, dtype=tf.float32, time_major=timeMajor)
output = dense(outputs[-1])

cost = tf.losses.mean_squared_error(output, y)
optimizerHigh = tf.train.RMSPropOptimizer(0.003).minimize(cost)
optimizerLow  = tf.train.RMSPropOptimizer(0.0003).minimize(cost)

### Inferring model
input = tf.placeholder(tf.float32, [n_features])
initial_state = lstm.zero_state(1, dtype=tf.float32)
output, state = lstm(tf.expand_dims(input, axis=0), initial_state)
output = tf.reshape(dense(tf.reshape(output, [-1,n_units])), [2])



### Training and testing
trainLosses = []
validationLosses = []
plt.ion()
fig = plt.figure(figsize=(10,10))
lossPlot,       = plt.plot(trainLosses)
validationPlot, = plt.plot(validationLosses)

with tf.Session() as sess:
	sess.run(tf.group(tf.global_variables_initializer(), tf.local_variables_initializer()))

	### training
	epoch_loss = 0
	loopSize = 10
	t = trange(nSteps, desc='Bar desc', leave=True)
	for i in t:
		batch_x, batch_y = makeBatch(X_train, Y_train, batch_size, n_spikes_perBatch, timeMajor=timeMajor)

		if i < nSteps /2:
			_, c = sess.run([optimizerHigh, cost], feed_dict={x:batch_x, y:batch_y})
		else:
			_, c = sess.run([optimizerLow, cost], feed_dict={x:batch_x, y:batch_y})
		epoch_loss += c

		if i%loopSize==0 and (i != 0):
			batch_val_x, batch_val_y = makeBatch(X_validation, Y_validation, batch_size, n_spikes_perBatch, timeMajor=timeMajor)
			validationLosses.append( cost.eval({x:batch_val_x, y:batch_val_y}) )

			t.set_description("loss: %d" % (epoch_loss/loopSize))
			t.refresh()
			trainLosses.append(epoch_loss/loopSize)
			lossPlot      .set_data([range(len(trainLosses)),      trainLosses])
			validationPlot.set_data([range(len(validationLosses)), validationLosses])
			plt.xlim([0,len(trainLosses)])
			plt.ylim([0, np.max(trainLosses[:30])])
			fig.canvas.draw() ; fig.canvas.flush_events()
			epoch_loss=0

	### inferring
	testOutput = []
	currentState = sess.run([initial_state])
	for spk in trange(len(X_test)):
		temp, currentState = sess.run([output, state], feed_dict={input:X_test[spk], initial_state:currentState})
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


np.savez('/home/mobshamilton/Documents/dataset/RatCatanese/_resultsForRnn_'+datetime.datetime.now().strftime("%Y-%m-%d_%H:%M"), Y_test, testOutput)