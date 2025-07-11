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

if sys.argv == ['']:
	sys.argv = ['__main__'] + externalParameters

if len(sys.argv)>1 and sys.argv[1]=="gpu":
	device_name = "/gpu:0"
	print('MOBS FULL FLOW ENCODER: DEVICE GPU', flush=True)
elif len(sys.argv)==1 or sys.argv[1]=="cpu":
	device_name = "/cpu:0"
	print('MOBS FULL FLOW ENCODER: DEVICE CPU', flush=True)
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

class xmlPath():
	def __init__(self, path):
		self.xml = path
		findFolder = lambda path: path if path[-1]=='/' or len(path)==0 else findFolder(path[:-1]) 
		self.folder = findFolder(self.xml)
		self.dat = path[:-3] + 'dat'

python_sys_path = ['/MOBSencoder',os.path.expanduser('~/Dropbox/Kteam/PrgMatlab/Thibault')]
with add_path(python_sys_path):
    rawDataParser = __import__("rawDataParser")
    datasetMaker  = __import__("datasetMaker")




projectPath = xmlPath(os.path.expanduser(sys.argv[2]))



### Data
if not os.path.isfile(projectPath.folder+'_rawSpikesForRnn.npz'):
	
	spikeDetector = rawDataParser.SpikeDetector(projectPath)

	allGroups = []
	allSpTime = []
	allSpikes = []
	allSpkPos = []
	allSpkSpd = []

	for spikes in spikeDetector.getSpikes():
		if len(spikes['time'])==0:
			continue
		for grp,time,spk,pos,spd in sorted(zip(spikes['group'],spikes['time'],spikes['spike'],spikes['position'],spikes['speed']), key=lambda x:x[1]):
			allGroups.append(grp)
			allSpTime.append(time)
			allSpikes.append(spk)
			allSpkPos.append(pos)
			allSpkSpd.append(spd)
		
	GRP_data = np.array(allGroups)
	SPT_data = np.array(allSpTime)
	SPK_data = np.array(allSpikes)
	POS_data = np.array(allSpkPos)
	SPD_data = np.array(allSpkSpd)
	print('data parsed.')


	SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test, SPD_train, SPD_test = train_test_split(
		SPT_data, GRP_data, SPK_data, POS_data, SPD_data, test_size=0.1, shuffle=False, random_state=42)
	np.savez(projectPath.folder + '_rawSpikesForRnn', 
		SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test, SPD_train, SPD_test)
else:
	try:
		print(loaded)
	except NameError:
		print('loading data')
		Results = np.load(projectPath.folder + '_rawSpikesForRnn.npz', allow_pickle=True)
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
class Params:
	def __init__(self):
		self.nGroups = np.max(GRP_train) + 1
		self.dim_output = POS_train.shape[1]
		self.nChannels = SPK_train[0].shape[0]
		self.length = len(SPK_train)

		self.nSteps = 10000
		self.nFeatures = 128
		self.lstmLayers = 3
		self.lstmSize = 128
		self.lstmDropout = 0.3

		self.windowLength = 0.036 # in seconds, as all things should be
		self.batch_size = 52
		self.timeMajor = True

		self.learningRates = [0.0003, 0.00003, 0.00001]
		self.lossLearningRate = 0.00003
		self.lossActivation = None


		# Figure out what will be the maximum length of a spike sequence for our windowLength
		self.maxLength = max(self.getMaxLength(SPT_train), self.getMaxLength(SPT_test))

	def getMaxLength(self, data):
		maxLength = 0
		n = 0
		bin_stop = data[0]
		while True:
			bin_stop = bin_stop + self.windowLength
			if bin_stop > data[-1]:
				maxLength = max(maxLength, len(data)-idx)
				break
			idx=n
			while data[n] < bin_stop:
				n += 1
			maxLength = max(maxLength, n-idx)
		return maxLength

params = Params()











def last_relevant(output, length, timeMajor=False):
	''' Used to select the right output of 
		tf.rnn.dynamic_rnn for sequences of variable sizes '''
	if timeMajor:
		output = tf.transpose(output, [1,0,2])
	batch_size = tf.shape(output)[0]
	max_length = tf.shape(output)[1]
	out_size = int(output.get_shape()[2])
	index = tf.range(0, batch_size) * max_length + tf.cast(length - 1, tf.int32)
	index = tf.nn.relu(index)
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









			








### Training model
with tf.Graph().as_default():

	print()
	print('TRAINING')

	dataIterator, trainingTensors, dataPlaceholders = datasetMaker.makeDataset(params, training=True)
	with tf.device(device_name):
		spkParserNet = []
		allFeatures = []

		# CNN plus dense on every group indepedently
		for group in range(params.nGroups):
			spkParserNet.append(spikeNet(nChannels=params.nChannels, device=device_name, nFeatures=params.nFeatures))

			x = spkParserNet[group].apply(trainingTensors[2*group+2])
			x = tf.reshape(tf.matmul(trainingTensors[2*group+3], x), [-1, params.batch_size, spkParserNet[group].nFeatures])
			allFeatures.append( x )

		allFeatures = tf.tuple(allFeatures)
		allFeatures = tf.concat(allFeatures, axis=2)

		# LSTM on the concatenated outputs of previous graphs
		if device_name=="/gpu:0":
			lstm = tf.contrib.cudnn_rnn.CudnnLSTM(params.lstmLayers, params.lstmSize, dropout=params.lstmDropout)
			outputs, finalState = lstm(allFeatures, training=True)
		else:
			lstm = [layerLSTM(params.lstmSize, dropout=params.lstmDropout) for _ in range(params.lstmLayers)]
			lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
			outputs, finalState = tf.nn.dynamic_rnn(
				lstm, 
				allFeatures, 
				dtype=tf.float32, 
				time_major=params.timeMajor, 
				sequence_length=trainingTensors[1])

	# dense to extract regression on output and loss
	denseOutput = tf.layers.Dense(params.dim_output, activation = None, name="pos")
	denseLoss1  = tf.layers.Dense(params.lstmSize, activation = tf.nn.relu, name="loss1")
	denseLoss2  = tf.layers.Dense(1, activation = params.lossActivation, name="loss2")

	output = last_relevant(outputs, trainingTensors[1], timeMajor=params.timeMajor)
	outputLoss = denseLoss2(denseLoss1(output))[:,0]
	outputPos = denseOutput(output)

	lossPos =  tf.losses.mean_squared_error(outputPos, trainingTensors[0], reduction=tf.losses.Reduction.NONE)
	lossPos =  tf.reduce_mean(lossPos, axis=1)
	lossLoss = tf.losses.mean_squared_error(outputLoss, lossPos)
	lossPos  = tf.reduce_mean(lossPos)

	optimizers = []
	for lr in range(len(params.learningRates)):
		optimizers.append( tf.group(
			tf.train.RMSPropOptimizer(params.learningRates[lr]).minimize(lossPos),
			tf.train.RMSPropOptimizer(params.lossLearningRate).minimize(lossLoss)) )
	saver = tf.train.Saver()



	### Training and testing
	trainLosses = []
	with tf.Session() as sess:

		# initialize variables and input framework
		sess.run(tf.group(tf.global_variables_initializer(), tf.local_variables_initializer()))
		sess.run(dataIterator.initializer, 
			feed_dict={dataPlaceholders['groups']:GRP_train, 
			dataPlaceholders['timeStamps']:SPT_train, 
			dataPlaceholders['spikes']:SPK_train, 
			dataPlaceholders['positions']:POS_train / np.max(POS_train)})

		### training
		epoch_loss = 0
		epoch_loss2 = 0
		loopSize = 50
		t = trange(params.nSteps, desc='Bar desc', leave=True)
		for i in t:

			for lr in range(len(params.learningRates)):
				if (i < (lr+1) * params.nSteps / len(params.learningRates)) and (i >= lr * params.nSteps / len(params.learningRates)):
					_, c, c2 = sess.run([optimizers[lr], lossPos, lossLoss])
					break
				if lr==len(params.learningRates)-1:
					print('not run:',i)
			t.set_description("loss: %f" % c)
			t.refresh()
			epoch_loss += c
			epoch_loss2 += c2
			
			if i%loopSize==0 and (i != 0):
				trainLosses.append(np.array([epoch_loss/loopSize, epoch_loss2/loopSize]))
				epoch_loss=0
				epoch_loss2=0

		saver.save(sess, projectPath.folder + '_graphForRnn')












### Inferring model
variables=[]
with tf.Graph().as_default():
	print()
	print()
	print('INFERRING')
	inferSpkNet = []
	dataIterator, testingTensors, dataPlaceholders = datasetMaker.makeDataset(params, training=False)
	
	with tf.device("/cpu:0"):
		inferringFeedDict = []
		embeddings = []

		# CNN and dense for each group
		for group in range(params.nGroups):
			inferSpkNet.append(spikeNet(nChannels=params.nChannels, device="/cpu:0", nFeatures=params.nFeatures))

			out = inferSpkNet[group].apply(testingTensors[2*group+2])
			embeddings.append(tf.matmul(testingTensors[2*group+3], out))
			variables += inferSpkNet[group].variables()
		embeddings = tf.tuple(embeddings)
		fullEmbedding = tf.concat(embeddings, axis=1)
		
		# LSTM on concatenated outputs
		with tf.variable_scope("cudnn_lstm"):
			lstm = tf.nn.rnn_cell.MultiRNNCell(
				[tf.contrib.cudnn_rnn.CudnnCompatibleLSTMCell(params.lstmSize) for _ in range(params.lstmLayers)])
			outputs, finalState = tf.nn.dynamic_rnn(
				lstm, 
				tf.expand_dims(fullEmbedding, axis=1), 
				dtype=tf.float32, 
				time_major=params.timeMajor, 
				sequence_length=tf.expand_dims(testingTensors[1],0))
			variables += lstm.variables
		
		output = last_relevant(outputs, testingTensors[1], timeMajor=params.timeMajor)
		denseOutput = tf.layers.Dense(params.dim_output, activation = None, name="pos")
		denseLoss1  = tf.layers.Dense(params.lstmSize, activation = tf.nn.relu, name="loss1")
		denseLoss2  = tf.layers.Dense(1, activation = params.lossActivation, name="loss2")

		position = tf.reshape(denseOutput(tf.reshape(output, [-1,params.lstmSize])), [2])
		loss     = tf.reshape(denseLoss2(denseLoss1(tf.reshape(output, [-1,params.lstmSize]))), [1])
		variables += denseOutput.variables
		variables += denseLoss1.variables
		variables += denseLoss2.variables
		
		subGraphToRestore = tf.train.Saver({v.op.name: v for v in variables})

		


	### Inferring
	with tf.Session() as sess:

		# Restoring variables and initialize input framework
		subGraphToRestore.restore(sess, projectPath.folder + '_graphForRnn')
		sess.run(dataIterator.initializer, 
			feed_dict={dataPlaceholders['groups']:GRP_test, 
			dataPlaceholders['timeStamps']:SPT_test, 
			dataPlaceholders['spikes']:SPK_test, 
			dataPlaceholders['positions']:POS_test / np.max(POS_train)})

		# inferring
		testOutput = []
		for bin in trange(int((SPT_test[-1]-SPT_test[0])//params.windowLength)-1):
			testOutput.append(np.concatenate(sess.run([position, loss]), axis=0))
	
	testOutput = np.array(testOutput)

	pos = []
	spd = []
	n = 0
	bin_stop = SPT_test[0]
	while True:
		bin_stop = bin_stop + params.windowLength
		if bin_stop > SPT_test[-1]:
			break
		idx=n
		while SPT_test[n] < bin_stop:
			n += 1
		if idx==n:
			pos.append(pos[-1])
			spd.append(spd[-1])
		else:
			pos.append(np.mean(POS_test[idx:n,:], axis=0))
			spd.append(np.mean(SPD_test[idx:n,:]))
	pos.pop()
	spd.pop()
	pos = np.array(pos) / np.max(POS_train)
	spd = np.array(spd)
	

	fileName = projectPath.folder + '_resultsForRnn_temp'
	np.savez(os.path.expanduser(fileName), pos=pos, spd=spd, testOutput=testOutput, trainLosses=trainLosses)
