%%%% Spectrum of a digital filter

function filterspectrum()


	fe = 20000;
	Te = 1/fe;
	fc = 300;
	wn = 2*pi*fc;
	wc = 2*tan(wn*Te/2)/Te;
	for i=1:4
		%%%% ORDER ONE
		if i==1
			C = wc*Te/2;
			b2 = 0;
			a2 = 0;
			a1 = (C-1)/(C+1);
			b1 = (-1)/(C+1);
			b0 = 1/(C+1);
		end

		%%%% ORDER TWO
		if i==2
			Q=100;
			C1 = 2/(Q*Te*wc);
			C2 = 4/(Te*Te*wc*wc);
			C0 = 1 + C2 + C1;
			b0 = C2/C0;
			b1 = (-2*C2)/C0;
			b2 = C2/C0;
			a1 = (2-2*C2)/C0;
			a2 = (1+C2-C1)/C0;
		end

		if i==3
			fc = (900 + 6000)/2;
			wn = 2*pi*fc;
			wc = 2*tan(wn*Te/2)/Te;
			Q = 0.5;
			C1 = 2*Q/(Te*wc);
			C2 = Te*Q*wc/2;
			C0 = 1 + C1 + C2;
			b0 = 1/C0;
			b1 = 0;
			b2 = -1/C0;
			a1 = (2*C2 - 2*C1)/C0;
			a2 = (C1 + C2 - 1)/C0;
		end

		if i==4
			sampleFreq = 20000;
			b = 10;
			notchFreq = 60;
			d = exp(-pi * b / sampleFreq);

		    a1 = -(1.0 + d * d) * cos(2.0 * pi * notchFreq / sampleFreq);
		    a2 = d * d;
		    b0 = (1 + d * d) / 2.0;
		    b1 = a1;
		    b2 = b0;
    	end

		freq = 1:20000;
		z = exp(1*pi*freq*Te);
		H = z;
		for n=1:20000
			H(n) = (b0 + b1/z(n) + b2/(z(n)*z(n)))/(1 + a1/z(n) + a2/(z(n)*z(n)));
		end

		semilogx(freq,H, 'DisplayName', strcat('order ',num2str(i)));hold on;
	end
	legend;
	ylabel('response of the filter');
	xlabel('frequency in hertz');