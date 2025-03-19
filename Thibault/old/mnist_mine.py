from tensorflow.examples.tutorials.mnist import input_data
import tensorflow as tf

mnist = input_data.read_data_sets('MNIST_data', one_hot=True)

"""
sess = tf.InteractiveSession()

##### MODEL - LINEAR CLASSIFIER
NNinput = tf.placeholder(tf.float32, shape=[None, 784])  # The None thing means the batch can have any size
Labels = tf.placeholder(tf.float32, shape=[None, 10])
W = tf.Variable(tf.zeros([784,10]))
b = tf.Variable(tf.zeros([10]))

NNoutput = tf.matmul(NNinput,W) + b
cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=Labels, logits=NNoutput)) ### WE WANT TO MODIFY THAT LATER BY SOMETHING THAT MAKES SENSE




##### TRAINING
init = tf.global_variables_initializer().run()
train_step = tf.train.GradientDescentOptimizer(0.5).minimize(cross_entropy)
for step in range(1000):
	if step % 50 == 0:
		print("current step: ",step)
	batch = mnist.train.next_batch(100) ###### WE WANT TO DO THAT OURSELVES
	train_step.run({NNinput: batch[0], Labels: batch[1]})

##### EVALUATING
Good_guesses = tf.equal(tf.argmax(NNoutput,1), tf.argmax(Labels,1))
Efficiency = tf.reduce_mean(tf.cast(Good_guesses, tf.float32)) # we convert the booleans to floats, then take the mean

print("Overall efficiency: ",Efficiency.eval({NNinput: mnist.test.images, Labels: mnist.test.labels}))

"""


def weight_variable(shape):
	return tf.Variable(tf.truncated_normal(shape, stddev=0.1))
def bias_variable(shape):
	return tf.Variable(tf.constant(0.1, shape=shape))
def conv2d(x, W):
	return tf.nn.conv2d(x, W, strides=[1,1,1,1], padding='SAME')
def max_pool_2x2(x):
	return tf.nn.max_pool(x, ksize=[1,2,2,1], strides=[1,2,2,1], padding='SAME')


x = tf.placeholder(tf.float32, shape=[None, 784])
y = tf.placeholder(tf.float32, shape=[None, 10])


### First layer - Convolution
x_conv1 = tf.reshape(x, [-1,28,28,1])
W_conv1 = weight_variable([5,5,1,32])
b_conv1 = bias_variable([32])

h_conv1 = tf.nn.relu(conv2d(x_conv1, W_conv1) + b_conv1)
h_pool1 = max_pool_2x2(h_conv1)


### Second Layer - Convolution
W_conv2 = weight_variable([5,5,32,64])
b_conv2 = bias_variable([64])

h_conv2 = tf.nn.relu(conv2d(h_pool1, W_conv2) + b_conv2)
h_pool2 = max_pool_2x2(h_conv2)


### Third Layer - Fully connected
h_pool2_flat = tf.reshape(h_pool2, [-1,7*7*64])
W_fc1 = weight_variable([7*7*64,1024])
b_fc1 = bias_variable([1024])

h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)


### Dropout
keep_proba = tf.placeholder(tf.float32)
h_dropout = tf.nn.dropout(h_fc1, keep_proba)


### Fourth Layer - Fully Connected
W_fc2 = weight_variable([1024,10])
b_fc2 = bias_variable([10])

y_fc2 = tf.matmul(h_dropout, W_fc2) + b_fc2


### Evalution metrics
cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=y, logits=y_fc2))
train = tf.train.AdamOptimizer(0.0004).minimize(cross_entropy)
good_guesses = tf.equal(tf.argmax(y,1), tf.argmax(y_fc2,1))
efficiency = tf.reduce_mean(tf.cast(good_guesses, tf.float32))


with tf.Session() as sess:
	sess.run(tf.global_variables_initializer())
	for i in range(20000):
		batch = mnist.train.next_batch(50)
		if i%100 == 0:
			print('step : %d, effiency : %g' % (i,efficiency.eval({x: batch[0], y: batch[1], keep_proba: 1.})))
		train.run({x: batch[0], y: batch[1], keep_proba: 0.5})
	print('efficiency : ',efficiency.eval({x: mnist.test.images, y: mnist.test.labels, keep_proba: 1.}))