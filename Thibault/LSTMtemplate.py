import os
from tqdm import trange
import numpy as np
import tensorflow as tf
from sklearn.model_selection import train_test_split



#DEFINE INPUT WITH SHAPE [NPOINTS, NDIMSINPUT]
#DEFINE OUTPUT WITH SHAPE [NPOINTS, NDIMSOUTPUT]
INPUT  = np.random.rand(300000).reshape([100000, 3])         # for example, 1000 data points (breath, heart rate, speed)
OUTPUT = (INPUT[:,2] + INPUT[:,0] + 50).reshape([100000, 1]) # and 1000 data points (temperature)
# Hint : always better to normalize your data between -1 and 1 (or 0 and 1, etc.)


#PARAMS
path_to_save_graph = os.path.expanduser("~/Documents/")

batch_size = 50 # you learn a batch of sequences at the same time
sequence_size = 50 # even for infinite time series, you have to use finite sequences for training LSTMs
learningRate = 0.003
nEpochs = 5 # number of times we go through training set

numLSTMLayers = 2
lstmSize = 128
lstmDropout = 0.3

numDenseLayers = 2
denseSize = 64












n_dims_input = INPUT.shape[1]
n_dims_output = OUTPUT.shape[1]
x_train, x_test, y_train, y_test = train_test_split(INPUT, OUTPUT, test_size=0.1, shuffle=False) # cut data in training and testing epochs, with proportion test_size
def layerLSTM(lstmSize, dropout=0.0):
	cell = tf.contrib.rnn.LSTMBlockCell(lstmSize)
	return tf.nn.rnn_cell.DropoutWrapper(cell, input_keep_prob=1.0, output_keep_prob=1.0, state_keep_prob=1-dropout)


# training
print("TRAINING")
with tf.Graph().as_default():
	nItems = x_train.shape[0]
	dataset = tf.data.Dataset
	dataset = dataset.from_tensor_slices((x_train, y_train))
	dataset = dataset.batch(sequence_size).shuffle(nItems).batch(batch_size).repeat()
	it = dataset.make_one_shot_iterator()
	tensors = it.get_next()

	lstm = [layerLSTM(lstmSize, dropout=lstmDropout) for _ in range(numLSTMLayers)]
	lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
	outputs, finalState = tf.nn.dynamic_rnn(lstm, tf.cast(tensors[0], tf.float32), dtype=tf.float32, time_major=False)
	output = outputs[-1]

	for _ in range(numDenseLayers-1):
		layer = tf.layers.Dense(denseSize, activation = tf.nn.relu)
		output = layer(output)
	layer = tf.layers.Dense(n_dims_output, activation = None)
	output = layer(output)

	cost = tf.losses.mean_squared_error(output, tensors[1][:,-1,:])
	optimizer = tf.train.RMSPropOptimizer(learningRate).minimize(cost)
	saver = tf.train.Saver()

	with tf.Session() as sess:
		sess.run(tf.group(tf.global_variables_initializer(), tf.local_variables_initializer()))
		# sess.run(it.initializer)

		for n in range(nEpochs):
			print()
			print("epoch", n)
			t = trange(int(nItems/batch_size/sequence_size), desc='Bar desc', leave=True)
			for _ in t:
				_, c = sess.run([optimizer, cost])
				t.set_description("loss: %d" % c)
				t.refresh()

		saver.save(sess, path_to_save_graph + "temp")


# testing
print()
print("TESTING")
with tf.Graph().as_default():
	variables = []
	nItems = x_test.shape[0]
	dataset = tf.data.Dataset
	dataset = dataset.from_tensor_slices((x_test, y_test))
	it = dataset.make_initializable_iterator()
	tensors = it.get_next()

	with tf.variable_scope('rnn'):
		lstm = [layerLSTM(lstmSize) for _ in range(numLSTMLayers)]
		lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
		initial_state = tuple([tf.Variable(layer[0]), tf.Variable(layer[1])]
			for layer in lstm.zero_state(1, tf.float32))
		output, state = lstm(tf.expand_dims(tf.cast(tensors[0], tf.float32), axis=0), initial_state)
		variables += lstm.variables


	for _ in range(numDenseLayers-1):
		layer = tf.layers.Dense(denseSize, activation = tf.nn.relu)
		output = layer(output)
		variables += layer.variables
	layer = tf.layers.Dense(n_dims_output, activation = None)
	output = layer(output)
	variables += layer.variables

	subGraphToRestore = tf.train.Saver({v.op.name: v for v in variables})

	updateStateOps = []
	for l in range(numLSTMLayers):
		updateStateOps.append( tf.assign(initial_state[l][0], state[l][0]) )
		updateStateOps.append( tf.assign(initial_state[l][1], state[l][1]) )
	with tf.control_dependencies(updateStateOps):
		output = tf.identity(output)

	with tf.Session() as sess:
		sess.run(tf.initializers.variables([stateVar[i] for stateVar in initial_state for i in range(2)]))
		subGraphToRestore.restore(sess, path_to_save_graph + "temp")
		sess.run(it.initializer)

		res = []
		for _ in trange(nItems):
			res.append( sess.run([output, tensors[1]]) )
		res = np.array(res)


import matplotlib as mpl
import matplotlib.pyplot as plt
plt.plot(res[:,0])
plt.plot(res[:,1])
plt.show()