#from __future__ import print_function
import numpy as np
import tensorflow as tf

Xtrain = [1,2,3,4]
Ytrain = [0,-1,-2,-3]


"""

####### MODEL
W = tf.Variable([.3], dtype=tf.float32)
b = tf.Variable([-.3], dtype=tf.float32)
X = tf.placeholder(tf.float32)
model = X*W + b



####### COST
Y = tf.placeholder(tf.float32)
cost = tf.reduce_sum(tf.square(model-Y))



####### SESSION
sess = tf.Session()
init = tf.global_variables_initializer().run()

print("test: ",sess.run(cost, {X:Xtrain, Y:Ytrain}))



# ####### ADJUST MANUALLY
# fixW = tf.assign(W, [.1])
# fixb = tf.assign(b, [-.1])
# sess.run([fixW, fixb])


#print("test: ",sess.run(cost, {X:Xtrain, Y:Ytrain}))


####### ADJUST AUTO
train = tf.train.GradientDescentOptimizer(0.01).minimize(cost)

for i in range(1000):
	sess.run(train, {X:Xtrain, Y:Ytrain})


curr_W, curr_b, curr_loss = sess.run([W, b, cost], {X: Xtrain, Y: Ytrain})
print("W: %s b: %s loss: %s"%(curr_W, curr_b, curr_loss))

"""



####### ESTIMATOR
def model_fn(features, labels, mode):
	W1 = tf.get_variable("W1", [1], dtype=tf.float64)
	b1 = tf.get_variable("b1", [1], dtype=tf.float64)
	W2 = tf.get_variable("W2", [1], dtype=tf.float64)
	b2 = tf.get_variable("b2", [1], dtype=tf.float64)
	W3 = tf.get_variable("W3", [1], dtype=tf.float64)
	b3 = tf.get_variable("b3", [1], dtype=tf.float64)
	W4 = tf.get_variable("W4", [1], dtype=tf.float64)
	temp1 = W1*features['x'] + b1
	temp2 = W2*features['x'] + b2
	y = W3*temp1 + W4*temp2 + b3

	loss = tf.reduce_sum(tf.square(y - labels))

	global_step = tf.train.get_global_step()
	optimizer = tf.train.GradientDescentOptimizer(0.0001)
	train = tf.group(optimizer.minimize(loss), tf.assign_add(global_step,1))

	return tf.estimator.EstimatorSpec(mode=mode, predictions=y, loss=loss, train_op=train)

estimator = tf.estimator.Estimator(model_fn=model_fn)

x_train = np.array([1., 2., 3., 4.])
y_train = np.array([0., -1., -2., -3.])
x_eval = np.array([2., 5., 8., 1.])
y_eval = np.array([-1.01, -4.1, -7, 0.])
input_fn = tf.estimator.inputs.numpy_input_fn({"x": x_train}, y_train, batch_size=4, num_epochs=None, shuffle=True)
train_input_fn = tf.estimator.inputs.numpy_input_fn({"x": x_train}, y_train, batch_size=4, num_epochs=1000, shuffle=False)
eval_input_fn = tf.estimator.inputs.numpy_input_fn({"x": x_eval}, y_eval, batch_size=4, num_epochs=1000, shuffle=False)

estimator.train(input_fn = input_fn, steps=10000)
train_metrics = estimator.evaluate(input_fn=train_input_fn)
eval_metrics = estimator.evaluate(input_fn=eval_input_fn)
print("train metrics: %r"% train_metrics)
print("eval metrics: %r"% eval_metrics)