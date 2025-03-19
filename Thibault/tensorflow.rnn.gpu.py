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
	print('MOBS FULL ENCODER: DEVICE GPU', flush=True)
elif len(sys.argv)==1 or sys.argv[1]=="cpu":
	device_name = "/cpu:0"
	print('MOBS FULL ENCODER: DEVICE CPU', flush=True)
else:
	raise ValueError('didn\'t understand arguments calling scripts '+sys.argv[0])


def UnifySpikes(Data):
	print('processing data...', flush=True)


	length = 0
	for group in range(Data['nGroups']):
		length += len(Data['spikes_time'][group])
	groups = [grp for grp in range(Data['nGroups'])]

	unifiedSpikes = [[-1, np.zeros([4,32])] for _ in range(length)]
	spikeTime = np.zeros(length)
	positions = np.zeros([length, 2])

	for spk in tqdm(range(length)):

		# Determine from which group the next spike is going to be
		nextGroup = np.argmin([Data['spikes_time'][grp][0] for grp in range(len(Data['spikes_time']))])

		# Build the spike vector
		spikeTime[spk] = Data['spikes_time'][nextGroup][0]
		unifiedSpikes[spk][0] = groups[nextGroup]
		unifiedSpikes[spk][1] = Data['spikes_all'][nextGroup][0].reshape([4,32])
		positions[spk,:] = Data['positions'][np.argmin(np.abs(Data['spikes_time'][nextGroup][0] - Data['position_time']))]

		# Erase the spike from memory
		Data['spikes_time'][nextGroup] = Data['spikes_time'][nextGroup][1:]
		Data['spikes_all'][nextGroup]  = Data['spikes_all'][nextGroup][1:]
		if len(Data['spikes_time'][nextGroup])==0 or len(Data['spikes_all'][nextGroup])==0:
			Data['spikes_time'].pop(nextGroup)
			Data['spikes_all'].pop(nextGroup)
			groups.pop(nextGroup)

	unifiedSpikes = list(map(list, zip(*unifiedSpikes)))
	return spikeTime, unifiedSpikes[0], unifiedSpikes[1], positions



### Data
if not os.path.isfile(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn.npz')):
	print('loading raw data')
	Data = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/mobsEncoding_2019-05-06_15:10/_data.npy'), allow_pickle=True).item()
	print('raw data loaded')

	SPT_data, GRP_data, SPK_data, POS_data = UnifySpikes(Data)
	SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test = train_test_split(
		SPT_data, GRP_data, SPK_data, POS_data, test_size=0.1, shuffle=False, random_state=42)
	# GRP_train, GRP_validation, SPK_train, SPK_validation, POS_train, POS_validation = train_test_split(
	# 	GRP_train, SPK_train, POS_train, test_size=0.1, shuffle=False, random_state=42)
	np.savez(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn'), 
		SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test)
	del Data
else:
	try:
		print(loaded)
	except NameError:
		print('loading data')
		Results = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn.npz'), allow_pickle=True)
		SPT_train = Results['arr_0']
		SPT_test = Results['arr_1']
		GRP_train = Results['arr_2']
		GRP_test = Results['arr_3']
		SPK_train = Results['arr_4']
		SPK_test = Results['arr_5']
		POS_train = Results['arr_6']
		POS_test = Results['arr_7']
		loaded='data loaded'
		print(loaded)




### Params
nGroups = np.max(GRP_train) + 1
dim_output = POS_train.shape[1]
nChannels = SPK_train[0].shape[0]
length = len(SPK_train)

nSteps = 20000
nFeatures = 128
lstmLayers = 3
lstmSize = 128
lstmDropout = 0.3

windowLength = 0.036
batch_size = 52
n_spikes_perBatch = 75
timeMajor = True

learningRates = [0.003]







def idMatrixRows(size):
	IDMatrix = np.identity(size)
	for n in range(size):
		yield IDMatrix[n]


def makeBatchGenerator(x, y, timeMajor=False):
	''' timeMajor is a bool to say if time dimension or batch dimension is first '''

	if not timeMajor:
		raise ValueError('timeMajor False is not yet implemented')

	idx = np.arange(0, len(x)-n_spikes_perBatch-1)
	np.random.shuffle(idx)
	spikeInfo = [None]*(nGroups*2+1)

	for batch in range(len(idx)//batch_size):
		sel = idx[batch*batch_size:(batch+1)*batch_size]
		spikeInfo[0] = y[sel, :]
		spikes = [x[sel[b]+spk] for spk in range(n_spikes_perBatch) for b in range(batch_size)]
		for group in range(nGroups):
			spikeInfo[2*group+1] = np.concatenate([
				spikes[n][1].reshape([1,4,32]) if spikes[n][0]==group else np.zeros([0,4,32])
				for n in range(len(spikes))], axis=0)

			nGroupSpikes = spikeInfo[2*group+1].shape[0]
			rows = idMatrixRows(nGroupSpikes)
			spikeInfo[2*group+2] = [np.zeros(nGroupSpikes) if spikes[spk][0]!=group else next(rows)
				for spk in range(batch_size*n_spikes_perBatch)]

		yield tuple(spikeInfo)
	


def makeDatasetFromGenerator(x, y, timeMajor=False):
	''' timeMajor is a bool to say if time dimension or batch dimension is first '''

	if not timeMajor:
		raise ValueError('timeMajor False is not yet implemented')

	print('building dataset.')
	shapes = [tf.TensorShape([batch_size, y[0].shape[0]])]
	for group in range(nGroups):
		shapes.append(tf.TensorShape([None, nChannels, 32]))
		shapes.append(tf.TensorShape([batch_size*n_spikes_perBatch, None]))
	
	dataset = tf.data.Dataset.from_generator(
		lambda: makeBatchGenerator(x, y, timeMajor), 
		(tf.float32,)*(nGroups*2+1), tuple(shapes))
	return dataset.make_one_shot_iterator().get_next()


def selectGroup(spk,grp,n, training):
	spk = tf.cast(spk, tf.float32)
	goodIndex = tf.cast(tf.equal(grp,n), tf.int32)
	if training:
		idx = tf.where(goodIndex)
		res = tf.gather(spk, idx)
		res = res[:,0,:,:]

		idMatrix = tf.eye(batch_size*n_spikes_perBatch)
		completionTensor = tf.gather(idMatrix, idx)
		res = (res, tf.transpose(completionTensor[:,0,:], [1,0]))
	else:
		res, _ = tf.split(tf.expand_dims(spk,0), [goodIndex, 1-goodIndex], 0)
		res = (res,)
	return res

def parse_data_row(training, timeMajor, *vals):
	# print(vals[0]) # group, int64, shape=()
	# print(vals[1]) # spike, float64, shape=(4,32)
	# print(vals[2]) # position, float64, shape=(2)

	if training and timeMajor:
		grp = tf.reshape(tf.transpose(vals[0], [1,0]),     [batch_size*n_spikes_perBatch])
		spk = tf.reshape(tf.transpose(vals[1], [1,0,2,3]), [batch_size*n_spikes_perBatch, 4, 32])
		pos = tf.reshape(tf.transpose(vals[2], [1,0,2]),   [batch_size*n_spikes_perBatch, 2])
	else:
		grp = vals[0]
		spk = vals[1]
		pos = vals[2]

	if training:
		if timeMajor:
			pos = pos[:batch_size, :]
		else:
			pos = tf.gather(pos, [i*n_spikes_perBatch for i in range(batch_size)])

	res = sum((selectGroup(spk, grp, n, training) for n in range(nGroups)), tuple([]))
	# print(res)

	return  (pos,) + res

def makeDatasetDirect(training=False, timeMajor=False):
	''' timeMajor is a bool to say if time dimension or batch dimension is first '''

	spikesPH = tf.placeholder(tf.float64, shape=[None,4,32])
	groupsPH = tf.placeholder(tf.int64, shape=[None])
	posPH    = tf.placeholder(tf.float64, shape=[None,2])

	temp = tf.data.Dataset
	temp = temp.from_tensor_slices((groupsPH, spikesPH, posPH))
	if training:
		temp = temp.batch(n_spikes_perBatch, drop_remainder=True)
		temp = temp.shuffle(length)
		temp = temp.batch(batch_size, drop_remainder=True)
		temp = temp.repeat()
	temp = temp.map(lambda *args: parse_data_row(training, timeMajor, *args))
	it = temp.make_initializable_iterator()
	return it, it.get_next(), {'groups':groupsPH, 'spikes':spikesPH, 'positions':posPH}


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
			self.denseLayer3 = tf.layers.Dense(self.nFeatures, activation='relu') # shape : [None, nFeatures]

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

















### Training model
with tf.Graph().as_default():

	print()
	print('TRAINING')

	dataIterator, trainingTensors, dataPlaceholders = makeDatasetDirect(training=True, timeMajor=timeMajor)
	# trainingTensors = makeDatasetFromGenerator(X_train, Y_train, timeMajor=timeMajor)
	with tf.device(device_name):
		spkParserNet = []
		allFeatures = []

		for group in range(nGroups):
			spkParserNet.append(spikeNet(nChannels=nChannels, device=device_name, nFeatures=nFeatures))

			x = spkParserNet[group].apply(trainingTensors[2*group+1])
			x = tf.reshape(tf.matmul(trainingTensors[2*group+2], x), [n_spikes_perBatch, batch_size, spkParserNet[group].nFeatures])
			allFeatures.append( x )

		allFeatures = tf.tuple(allFeatures)
		allFeatures = tf.concat(allFeatures, axis=2)

		if device_name=="/gpu:0":
			lstm = tf.contrib.cudnn_rnn.CudnnLSTM(lstmLayers, lstmSize, dropout=lstmDropout)
			outputs, finalState = lstm(allFeatures, training=True)
		else:
			lstm = [layerLSTM(lstmSize, dropout=lstmDropout) for _ in range(lstmLayers)]
			lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
			outputs, finalState = tf.nn.dynamic_rnn(lstm, allFeatures, dtype=tf.float32, time_major=timeMajor)

		dense = tf.layers.Dense(dim_output, activation = None)
		output = dense(outputs[-1])

		cost = tf.losses.mean_squared_error(output, trainingTensors[0])
		optimizers = []
		for lr in range(len(learningRates)):
			optimizers.append( tf.train.RMSPropOptimizer(learningRates[lr]).minimize(cost) )
	saver = tf.train.Saver()




	### Training and testing
	trainLosses = []
	with tf.Session() as sess:
		sess.run(tf.group(tf.global_variables_initializer(), tf.local_variables_initializer()))
		sess.run(dataIterator.initializer, 
			feed_dict={dataPlaceholders['groups']:GRP_train, 
			dataPlaceholders['spikes']:SPK_train, 
			dataPlaceholders['positions']:POS_train})

		### training
		epoch_loss = 0
		loopSize = 50
		t = trange(nSteps, desc='Bar desc', leave=True)
		for i in t:

			for lr in range(len(learningRates)):
				if (i < (lr+1) * nSteps / len(learningRates)) and (i >= lr * nSteps / len(learningRates)):
					_, c = sess.run([optimizers[lr], cost])
					break
				if lr==len(learningRates)-1:
					print('not run:',i)
			epoch_loss += c
			
			if i%loopSize==0 and (i != 0):
				t.set_description("loss: %d" % (epoch_loss/loopSize))
				t.refresh()
				trainLosses.append(epoch_loss/loopSize)
				epoch_loss=0
		saver.save(sess, os.path.expanduser('~/Documents/dataset/RatCatanese/_graphForRnn'))












### Inferring model
variables=[]
with tf.Graph().as_default():
	print()
	print('INFERRING')
	inferSpkNet = []
	dataIterator, testingTensors, dataPlaceholders = makeDatasetDirect(training=False, timeMajor=timeMajor)
	with tf.device("/cpu:0"):
		inferringFeedDict = []
		embeddings = []
		for group in range(nGroups):
			inferSpkNet.append(spikeNet(nChannels=nChannels, device="/cpu:0", nFeatures=nFeatures))

			out = inferSpkNet[group].apply(testingTensors[group+1])
			embeddings.append(tf.reduce_sum(out, axis=0))
			variables += inferSpkNet[group].variables()
		embeddings = tf.tuple(embeddings)
		fullEmbedding = tf.concat(embeddings, axis=0)
		
		with tf.variable_scope("cudnn_lstm/rnn"):
			lstm = tf.nn.rnn_cell.MultiRNNCell([tf.contrib.cudnn_rnn.CudnnCompatibleLSTMCell(lstmSize) for _ in range(lstmLayers)])
			initial_state = tuple([tf.Variable(layer[0]), tf.Variable(layer[1])]
				for layer in lstm.zero_state(1, tf.float32))
			output, state = lstm(tf.expand_dims(fullEmbedding, axis=0), initial_state)
			variables += lstm.variables
		dense = tf.layers.Dense(dim_output, activation = None)
		output = tf.reshape(dense(tf.reshape(output, [-1,lstmSize])), [2])
		variables += dense.variables

		subGraphToRestore = tf.train.Saver({v.op.name: v for v in variables})
		
		updateStateOps = []
		for l in range(lstmLayers):
			updateStateOps.append( tf.assign(initial_state[l][0], state[l][0]) )
			updateStateOps.append( tf.assign(initial_state[l][1], state[l][1]) )
		with tf.control_dependencies(updateStateOps):
			position = tf.identity(output, name='position')





	### Inferring
	with tf.Session() as sess:
		sess.run(tf.initializers.variables([stateVar[i] for stateVar in initial_state for i in range(2)]))
		subGraphToRestore.restore(sess, os.path.expanduser('~/Documents/dataset/RatCatanese/_graphForRnn'))
		sess.run(dataIterator.initializer, 
			feed_dict={dataPlaceholders['groups']:GRP_test, 
			dataPlaceholders['spikes']:SPK_test, 
			dataPlaceholders['positions']:POS_test})

		testOutput = []
		for spk in trange(len(SPK_test)):
			res = sess.run(position)
			testOutput.append(res)
		testOutput = np.array(testOutput)

	fileName = '~/Documents/dataset/RatCatanese/_resultsForRnn_temp'
	# np.savez(os.path.expanduser(fileName), POS_test, testOutput, [])
	np.savez(os.path.expanduser(fileName), POS_test, testOutput, trainLosses)
