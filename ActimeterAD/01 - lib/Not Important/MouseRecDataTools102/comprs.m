function [outsig] = comprs(sig, rho)
%  This function will compress the input signal
%  SIG is the input signal that undergoes compression
%  RHO is the compression factor and take values between 0 & 1
%
%     [outsig, env] = comprs(sig, rho) 
%
%  The output vector OUTSIG is the compressed version of the
%  input signal and ENV is the envelope of the input signal
%
%  Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) February 2007


env = abs(hilbert(sig));%Create an envelope of the input signal
thrx = median(env); % Median of envelope determines threshold
outsig = sig;
indx = find(env > thrx); % Consider envelope values that exceeds threshold
outsig(indx) = ((env(indx)/thrx).^(rho-1)).*sig(indx); % Logarithmic compression is performed