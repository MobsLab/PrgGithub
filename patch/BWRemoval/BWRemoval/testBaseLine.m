%
% Test program for removing baseline wander from ECG signals using
% different techniques.
%
% Dependencies: The baseline wander toolbox of the Open Source ECG Toolbox
%
% Open Source ECG Toolbox, version 1.0, November 2006
% Released under the GNU General Public License
% Copyright (C) 2006  Reza Sameni
% Sharif University of Technology, Tehran, Iran -- LIS-INPG, Grenoble, France
% reza.sameni@gmail.com

% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2 of the License, or (at your
% option) any later version.
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details. You should have received a copy of the
% GNU General Public License along with this program; if not, write to the
% Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
% MA  02110-1301, USA.

% clc
% clear all
close all;

% load('SampleECG1.mat');
%load('SampleECG2.mat'); data = data(1:15000,6)';

fs = 1000;
t = [0:length(data)-1]/fs;

b0 = BaseLine1(data,fs*.3,'md');
b1 = BaseLine2(data,fs*.3,fs*.6,'md');
b2 = BaseLine2(data,fs*.3,fs*.6,'mn');
b3 = BaseLineKF(data,.3/fs);
b4 = LPFilter(data,.7/fs);
b5 = BPFilter(data,0,.7/fs);

figure;
plot(t,data','b');
hold on
plot(t,b0','r');
plot(t,b1','g');
plot(t,b2','m');
plot(t,b3','c');
plot(t,b4','k');
plot(t,b5','y');
grid;
xlabel('time (sec.)');
legend('original ECG','single-median','double-median','double-mean','KF','lowpass-IIR','FFT filter');