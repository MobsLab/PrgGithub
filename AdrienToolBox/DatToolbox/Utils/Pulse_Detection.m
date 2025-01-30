function [risingIx fallingIx voltage] = Pulse_Detection(data,minVoltPulse)

ep = thresholdIntervals(data,minVoltPulse);

risingIx = Start(ep);
fallingIx = End(ep);
voltage = Data(intervalMean(data,ep));
