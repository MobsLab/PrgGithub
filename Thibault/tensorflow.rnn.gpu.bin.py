import sys
import os.path
import datetime
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score, accuracy_score, recall_score, precision_score
import tensorflow as tf
import numpy as np
from tqdm import tqdm
from tqdm import trange
from datetime import datetime
import matplotlib as mpl
import matplotlib.pyplot as plt
print(flush=True)
if len(sys.argv)>1 and sys.argv[1]=="gpu":
	device_name = "/gpu:0"
	print('MOBS FULL FLOW ENCODER: DEVICE GPU', flush=True)
elif len(sys.argv)==1 or sys.argv[1]=="cpu":
	device_name = "/cpu:0"
	print('MOBS FULL FLOW ENCODER: DEVICE CPU', flush=True)
else:
	raise ValueError('didn\'t understand arguments calling scripts '+sys.argv[0])

def swap(array, x, y):
	array[[x, y]] = array[[y,x]]

def shuffle_spike_time(Data, maxDisplacement=0.05):
	'''maxDisplacement in seconds'''
	for group in range(Data['nGroups']):
		while len(Data['spikes_all'][group]) > len(Data['spikes_time'][group]):
			Data['spikes_all'][group] = Data['spikes_all'][group][:-1]

		for spk in range(len(Data['spikes_time'][group])):
			Data['spikes_time'][group][spk] += 2*maxDisplacement*np.random.random() - maxDisplacement

		for spk in range(1, len(Data['spikes_time'][group])):
			idx = spk

			while Data['spikes_time'][group][idx] < Data['spikes_time'][group][idx-1]:
				swap(Data['spikes_time'][group], idx, idx-1)
				swap(Data['spikes_all'][group], idx, idx-1)
				idx -= 1
				if idx <= 0:
					break




def UnifySpikes(Data):
	print('processing data...', flush=True)


	length = 0
	for group in range(Data['nGroups']):
		length += len(Data['spikes_time'][group])
	groups = [grp for grp in range(Data['nGroups'])]

	unifiedSpikes = [[-1, np.zeros([4,32])] for _ in range(length)]
	spikeTime = np.zeros(length)
	positions = np.zeros([length, 2])
	speeds    = np.zeros([length, 1])


	for spk in tqdm(range(length)):

		# Determine from which group the next spike is going to be
		nextGroup = np.argmin([Data['spikes_time'][grp][0] for grp in range(len(Data['spikes_time']))])

		# Build the spike vector
		spikeTime[spk] = Data['spikes_time'][nextGroup][0]
		unifiedSpikes[spk][0] = groups[nextGroup]
		unifiedSpikes[spk][1] = Data['spikes_all'][nextGroup][0].reshape([4,32])
		positions[spk,:] = Data['positions'][np.argmin(np.abs(Data['spikes_time'][nextGroup][0] - Data['position_time']))]
		speeds[spk,:]    = Data['speed'][np.argmin(np.abs(Data['spikes_time'][nextGroup][0] - Data['position_time']))]

		# Erase the spike from memory
		Data['spikes_time'][nextGroup] = Data['spikes_time'][nextGroup][1:]
		Data['spikes_all'][nextGroup]  = Data['spikes_all'][nextGroup][1:]
		if len(Data['spikes_time'][nextGroup])==0 or len(Data['spikes_all'][nextGroup])==0:
			Data['spikes_time'].pop(nextGroup)
			Data['spikes_all'].pop(nextGroup)
			groups.pop(nextGroup)

	unifiedSpikes = list(map(list, zip(*unifiedSpikes)))
	return spikeTime, unifiedSpikes[0], unifiedSpikes[1], positions, speeds



### Data
# if not os.path.isfile(os.path.expanduser('~/Documents/dataset/Mouse-797/_spikesForRnn.npz')):
if not os.path.isfile(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn.npz')):
	print('loading raw data')
	# Data = np.load(os.path.expanduser('~/Documents/dataset/Mouse-797/mobsEncoding_2019-02-06_17:02/_data.npy'), allow_pickle=True).item()
	Data = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/mobsEncoding_2019-05-06_15:10/_data.npy'), allow_pickle=True).item()
	print('raw data loaded')

	# print('shuffling spike time')
	# shuffle_spike_time(Data, 1.1)
	# print('spike time shuffled')


	SPT_data, GRP_data, SPK_data, POS_data, SPD_data = UnifySpikes(Data)
	SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test, SPD_train, SPD_test = train_test_split(
		SPT_data, GRP_data, SPK_data, POS_data, SPD_data, test_size=0.1, shuffle=False, random_state=42)
	# np.savez(os.path.expanduser('~/Documents/dataset/Mouse-797/_spikesForRnn'), 
	np.savez(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn'), 
		SPT_train, SPT_test, GRP_train, GRP_test, SPK_train, SPK_test, POS_train, POS_test, SPD_train, SPD_test)
	del Data
else:
	try:
		print(loaded)
	except NameError:
		print('loading data')
		# Results = np.load(os.path.expanduser('~/Documents/dataset/Mouse-797/_spikesForRnn.npz'), allow_pickle=True)
		Results = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/_spikesForRnn.npz'), allow_pickle=True)
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









			








# ### Training model
# with tf.Graph().as_default():

# 	print()
# 	print('TRAINING')

# 	dataIterator, trainingTensors, dataPlaceholders = makeDataset(training=True, timeMajor=timeMajor)
# 	with tf.device(device_name):
# 		spkParserNet = []
# 		allFeatures = []

# 		for group in range(nGroups):
# 			spkParserNet.append(spikeNet(nChannels=nChannels, device=device_name, nFeatures=nFeatures))

# 			x = spkParserNet[group].apply(trainingTensors[2*group+2])
# 			x = tf.reshape(tf.matmul(trainingTensors[2*group+3], x), [-1, batch_size, spkParserNet[group].nFeatures])
# 			allFeatures.append( x )

# 		allFeatures = tf.tuple(allFeatures)
# 		allFeatures = tf.concat(allFeatures, axis=2)

# 		if device_name=="/gpu:0":
# 			lstm = tf.contrib.cudnn_rnn.CudnnLSTM(lstmLayers, lstmSize, dropout=lstmDropout)
# 			outputs, finalState = lstm(allFeatures, training=True)
# 		else:
# 			lstm = [layerLSTM(lstmSize, dropout=lstmDropout) for _ in range(lstmLayers)]
# 			lstm = tf.nn.rnn_cell.MultiRNNCell(lstm)
# 			outputs, finalState = tf.nn.dynamic_rnn(
# 				lstm, 
# 				allFeatures, 
# 				dtype=tf.float32, 
# 				time_major=timeMajor, 
# 				sequence_length=trainingTensors[1])


# 		denseOutput = tf.layers.Dense(dim_output, activation = None, name="pos")
# 		denseLoss1  = tf.layers.Dense(lstmSize, activation = tf.nn.relu, name="loss1")
# 		denseLoss2  = tf.layers.Dense(1, activation = lossActivation, name="loss2")

# 		output = last_relevant(outputs, trainingTensors[1], timeMajor=timeMajor)
# 		outputLoss = denseLoss2(denseLoss1(output))[:,0]
# 		outputPos = denseOutput(output)

# 		lossPos =  tf.losses.mean_squared_error(outputPos, trainingTensors[0], reduction=tf.losses.Reduction.NONE)
# 		lossPos =  tf.reduce_mean(lossPos, axis=1)
# 		lossLoss = tf.losses.mean_squared_error(outputLoss, lossPos)
# 		lossPos  = tf.reduce_mean(lossPos)

# 		optimizers = []
# 		for lr in range(len(learningRates)):
# 			# optimizers.append( tf.group(
# 			# 	tf.train.RMSPropOptimizer(learningRates[lr]).minimize(lossPos),
# 			# 	tf.train.RMSPropOptimizer(lossLearningRate).minimize(lossLoss)) )
# 			optimizers.append(tf.train.RMSPropOptimizer(learningRates[lr]).minimize(lossPos + lossLoss))
# 	saver = tf.train.Saver()



# 	### Training and testing
# 	trainLosses = []
# 	with tf.Session() as sess:
# 		sess.run(tf.group(tf.global_variables_initializer(), tf.local_variables_initializer()))
# 		sess.run(dataIterator.initializer, 
# 			feed_dict={dataPlaceholders['groups']:GRP_train, 
# 			dataPlaceholders['timeStamps']:SPT_train, 
# 			dataPlaceholders['spikes']:SPK_train, 
# 			dataPlaceholders['positions']:POS_train / np.max(POS_train)})

# 		### training
# 		epoch_loss = 0
# 		epoch_loss2 = 0
# 		loopSize = 50
# 		t = trange(nSteps, desc='Bar desc', leave=True)
# 		for i in t:

# 			for lr in range(len(learningRates)):
# 				if (i < (lr+1) * nSteps / len(learningRates)) and (i >= lr * nSteps / len(learningRates)):
# 					_, c, c2 = sess.run([optimizers[lr], lossPos, lossLoss])
# 					break
# 				if lr==len(learningRates)-1:
# 					print('not run:',i)
# 			t.set_description("loss: %f" % c)
# 			t.refresh()
# 			epoch_loss += c
# 			epoch_loss2 += c2
			
# 			if i%loopSize==0 and (i != 0):
# 				trainLosses.append(np.array([epoch_loss/loopSize, epoch_loss2/loopSize]))
# 				epoch_loss=0
# 				epoch_loss2=0

# 		# saver.save(sess, os.path.expanduser('~/Documents/dataset/Mouse-797/_graphForRnn'))
# 		saver.save(sess, os.path.expanduser('~/Documents/dataset/RatCatanese/_graphForRnn'))












# ### Inferring model
# variables=[]
# # Data = np.load('/home/mobshamilton/Documents/dataset/RatCatanese/mobsEncoding_2019-09-30_shuffledSpikes/_data.npy').item()
# with tf.Graph().as_default():
# 	print()
# 	print()
# 	print('INFERRING')
# 	inferSpkNet = []
# 	dataIterator, testingTensors, dataPlaceholders = makeDataset(training=False, timeMajor=timeMajor)

# 	with tf.device("/cpu:0"):
# 		inferringFeedDict = []
# 		embeddings = []
# 		for group in range(nGroups):
# 			inferSpkNet.append(spikeNet(nChannels=nChannels, device="/cpu:0", nFeatures=nFeatures))

# 			out = inferSpkNet[group].apply(testingTensors[2*group+2])
# 			embeddings.append(tf.matmul(testingTensors[2*group+3], out))
# 			variables += inferSpkNet[group].variables()
# 		embeddings = tf.tuple(embeddings)
# 		fullEmbedding = tf.concat(embeddings, axis=1)
		
# 		with tf.variable_scope("cudnn_lstm"):
# 			lstm = tf.nn.rnn_cell.MultiRNNCell([tf.contrib.cudnn_rnn.CudnnCompatibleLSTMCell(lstmSize) for _ in range(lstmLayers)])
# 			outputs, finalState = tf.nn.dynamic_rnn(
# 				lstm, 
# 				tf.expand_dims(fullEmbedding, axis=1), 
# 				dtype=tf.float32, 
# 				time_major=timeMajor, 
# 				sequence_length=tf.expand_dims(testingTensors[1],0))
# 			variables += lstm.variables
		
# 		output = last_relevant(outputs, testingTensors[1], timeMajor=timeMajor)
# 		denseOutput = tf.layers.Dense(dim_output, activation = None, name="pos")
# 		denseLoss1  = tf.layers.Dense(lstmSize, activation = tf.nn.relu, name="loss1")
# 		denseLoss2  = tf.layers.Dense(1, activation = lossActivation, name="loss2")

# 		position = tf.reshape(denseOutput(tf.reshape(output, [-1,lstmSize])), [2])
# 		loss     = tf.reshape(denseLoss2(denseLoss1(tf.reshape(output, [-1,lstmSize]))), [1])
# 		variables += denseOutput.variables
# 		variables += denseLoss1.variables
# 		variables += denseLoss2.variables
		
# 		subGraphToRestore = tf.train.Saver({v.op.name: v for v in variables})

		


# 	### Inferring
# 	times = [datetime.now()]
# 	with tf.Session() as sess:
# 		# subGraphToRestore.restore(sess, os.path.expanduser('~/Documents/dataset/Mouse-797/_graphForRnn'))
# 		subGraphToRestore.restore(sess, os.path.expanduser('~/Documents/dataset/RatCatanese/_graphForRnn'))
# 		sess.run(dataIterator.initializer, 
# 			feed_dict={dataPlaceholders['groups']:GRP_test, 
# 			dataPlaceholders['timeStamps']:SPT_test, 
# 			dataPlaceholders['spikes']:SPK_test, 
# 			dataPlaceholders['positions']:POS_test / np.max(POS_train)})


# 		testOutput = []
# 		for bin in trange(int((SPT_test[-1]-SPT_test[0])//windowLength)-1):
# 			testOutput.append(np.concatenate(sess.run([position, loss]), axis=0))
# 			times.append(datetime.now())
	
# 	testOutput = np.array(testOutput)

# 	pos = []
# 	spd = []
# 	n = 0
# 	bin_stop = SPT_test[0]
# 	while True:
# 		bin_stop = bin_stop + windowLength
# 		if bin_stop > SPT_test[-1]:
# 			break
# 		idx=n
# 		while SPT_test[n] < bin_stop:
# 			n += 1
# 		pos.append(np.mean(POS_test[idx:n,:], axis=0))
# 		spd.append(np.mean(SPD_test[idx:n,:]))
# 	pos.pop()
# 	spd.pop()
# 	pos = np.array(pos) / np.max(POS_train)
# 	spd = np.array(spd)
	
# 	def timedelta_to_ms(timedelta):
# 	    ms = 0
# 	    ms = ms + 3600*24*1000*timedelta.days
# 	    ms = ms + 1000*timedelta.seconds
# 	    ms = ms + timedelta.microseconds/1000
# 	    return ms
# 	# fileName = '~/Documents/dataset/Mouse-797/_resultsForRnn_temp'
# 	fileName = '~/Documents/dataset/RatCatanese/_resultsForRnn_temp'
# 	# np.savez(os.path.expanduser(fileName), pos, spd, testOutput, [])
# 	np.savez(os.path.expanduser(fileName), pos=pos, spd=spd, testOutput=testOutput, trainLosses=[], times=np.array([timedelta_to_ms(times[n+1] - times[n]) for n in range(len(times)-1)]))
# 	# np.savez(os.path.expanduser(fileName), pos=pos, spd=spd, testOutput=testOutput, trainLosses=trainLosses, times=np.array([timedelta_to_ms(times[n+1] - times[n]) for n in range(len(times)-1)]))










###Inferring data
start_time = 1180 + 90*(3300-1180)//100
stop_time = 3300
bin_time = 0.036
feedDictData = []
truePositions = [] ; truePositions.append([0.,0.])
trueSpeeds = [] ; trueSpeeds.append([0.])
Data = np.load(os.path.expanduser('~/Documents/dataset/RatCatanese/mobsEncoding_2019-05-06_15:10/_data.npy'), allow_pickle=True).item()
n_tetrodes = Data['nGroups']

### Cut the data up
nBins = int(np.floor((stop_time - start_time)/bin_time))
print('Preparing data.')
for bin in range(nBins):
	bin_start_time = start_time + bin*bin_time
	bin_stop_time = bin_start_time + bin_time

	length = 0
	spikes = []
	spikeTimes = []
	feedDictDataBin = []

	for tetrode in range(n_tetrodes):
		# spikes = Data['spikes_all'][tetrode][np.where(np.logical_and(
		# 					Data['spikes_time'][tetrode][:] >= bin_start_time,
		# 					Data['spikes_time'][tetrode][:] < bin_stop_time))[0]]
		spikes.append(Data['spikes_all'][tetrode][np.where(np.logical_and(
							Data['spikes_time'][tetrode][:,0] >= bin_start_time,
							Data['spikes_time'][tetrode][:,0] < bin_stop_time))])
		spikeTimes.append(Data['spikes_time'][tetrode][np.where(np.logical_and(
							Data['spikes_time'][tetrode][:,0] >= bin_start_time,
							Data['spikes_time'][tetrode][:,0] < bin_stop_time))])
		# labels = Data['labels_all'][tetrode][np.where(np.logical_and(
		# 					Data['spikes_time'][tetrode][:,0] >= bin_start_time,
		# 					Data['spikes_time'][tetrode][:,0] < bin_stop_time))]

		length += len(spikes[tetrode])

	order = []
	for tetrode in range(n_tetrodes):
		temp = np.zeros(shape=[161,len(spikes[tetrode])])
		for spike in range(len(spikes[tetrode])):
			idx = spike;
			time = spikeTimes[tetrode][spike]
			for tetrode2 in range(n_tetrodes):
				if tetrode==tetrode2:
					continue
				for spike2 in range(len(spikes[tetrode2])):
					if spikeTimes[tetrode2][spike2]<time:
						idx += 1
			temp[idx, spike] = 1
		order.append(temp)


	feedDictDataBin.append(length)
	for tetrode in range(n_tetrodes):
		feedDictDataBin.append(spikes[tetrode])
		feedDictDataBin.append(order[tetrode])

	feedDictData.append(feedDictDataBin)

	position_idx = np.argmin(np.abs(bin_stop_time-Data['position_time']))
	position_bin = Data['positions'][position_idx,:]
	speed_bin = Data['speed'][position_idx,:]
	truePositions.append( truePositions[-1] if np.isnan(position_bin).any() else position_bin )
	trueSpeeds.append( trueSpeeds[-1] if np.isnan(speed_bin).any() else speed_bin )

	if bin%10==0:
		sys.stdout.write('[%-30s] step : %d/%d' % ('='*(bin*30//nBins),bin,nBins))
		sys.stdout.write('\r')
		sys.stdout.flush()

truePositions.pop(0)
trueSpeeds.pop(0)
print("Data is prepared. We're sending it through the tensorflow graph.")


### Inferring model
variables=[]
with tf.Graph().as_default():
	print()
	print()
	print('INFERRING')
	inferSpkNet = []
	# dataIterator, testingTensors, dataPlaceholders = makeDataset(training=False, timeMajor=timeMajor)
	# for temp in testingTensors:
	# 	print(temp)
	# bbb

	testingTensors = [tf.placeholder(tf.int32, shape=[])]
	for group in range(nGroups):	
		testingTensors.append(tf.placeholder(tf.float32, shape=[None, 4, 32]))
		testingTensors.append(tf.placeholder(tf.float32, shape=[161, None]))
	
	with tf.device("/cpu:0"):
		inferringFeedDict = []
		embeddings = []
		for group in range(nGroups):
			inferSpkNet.append(spikeNet(nChannels=nChannels, device="/cpu:0", nFeatures=nFeatures))

			out = inferSpkNet[group].apply(testingTensors[2*group+1])
			embeddings.append(tf.matmul(testingTensors[2*group+2], out))
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
				sequence_length=tf.expand_dims(testingTensors[0],0))
			variables += lstm.variables
		
		output = last_relevant(outputs, testingTensors[0], timeMajor=timeMajor)
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
	times = [datetime.now()]
	with tf.Session() as sess:
		# subGraphToRestore.restore(sess, os.path.expanduser('~/Documents/dataset/Mouse-797/_graphForRnn'))
		subGraphToRestore.restore(sess, os.path.expanduser('~/Documents/dataset/RatCatanese/_graphForRnn'))


		testOutput = []
		for bin in trange(nBins):
			testOutput.append(np.concatenate(sess.run([position, loss], {i:j for i,j in zip(testingTensors, feedDictData[bin])}), axis=0))
			times.append(datetime.now())
	
	testOutput = np.array(testOutput)

	# pos = []
	# spd = []
	# n = 0
	# bin_stop = SPT_test[0]
	# while True:
	# 	bin_stop = bin_stop + windowLength
	# 	if bin_stop > SPT_test[-1]:
	# 		break
	# 	idx=n
	# 	while SPT_test[n] < bin_stop:
	# 		n += 1
	# 	pos.append(np.mean(POS_test[idx:n,:], axis=0))
	# 	spd.append(np.mean(SPD_test[idx:n,:]))
	# pos.pop()
	# spd.pop()
	# pos = np.array(pos) / np.max(POS_train)
	# spd = np.array(spd)
	
	def timedelta_to_ms(timedelta):
	    ms = 0
	    ms = ms + 3600*24*1000*timedelta.days
	    ms = ms + 1000*timedelta.seconds
	    ms = ms + timedelta.microseconds/1000
	    return ms
	# fileName = '~/Documents/dataset/Mouse-797/_resultsForRnn_temp'
	fileName = '~/Documents/dataset/RatCatanese/_resultsForRnn_2019-11-19_aligned'
	# np.savez(os.path.expanduser(fileName), pos, spd, testOutput, [])
	np.savez(os.path.expanduser(fileName), pos=truePositions, spd=trueSpeeds, testOutput=testOutput, trainLosses=[], times=np.array([timedelta_to_ms(times[n+1] - times[n]) for n in range(len(times)-1)]))
	# np.savez(os.path.expanduser(fileName), pos=pos, spd=spd, testOutput=testOutput, trainLosses=trainLosses, times=np.array([timedelta_to_ms(times[n+1] - times[n]) for n in range(len(times)-1)]))
