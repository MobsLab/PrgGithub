
%%%% ------ INTAN FILTER ------ %%%%




function filteredData=highpassfilter(data, pre, post)

	fe = 20000;
	Te = 1/fe;
	fc = 500;
	wn = 2*pi*fc;
	wc = 2*tan(wn*Te/2)/Te;

	%%%% ORDER ONE
	% C = wc*Te/2;
	% b = [1/(C+1) -1/(C+1)]
	% a = [1.0 (C-1)/(C+1)]

	%%%% ORDER TWO
	% Q = 500;
	% C1 = 2/(Q*Te*wc);
	% C2 = 4/(Te*Te*wc*wc);
	% C0 = 1 + C2 + C1;
	% b = [C2/C0 -2*C2/C0 C2/C0];
	% a = [1.0 (2-2*C2)/C0 (1+C2-C1)/C0];

	%%%% ORDER TWO BAND PASS
	% fc = (300 + 6000)/2;
	% wn = 2*pi*fc;
	% wc = 2*tan(wn*Te/2)/Te;
	% Q = 0.5;
	% C1 = 2*Q/(Te*wc);
	% C2 = Te*Q*wc/2;
	% C0 = 1 + C1 + C2;
	% b = [1/C0 0.0 -1/C0];
	% a = [1.0 (2*C2-2*C1)/C0 (C0-2)/C0];

	%%%% CUSTOM FILERS
	filters = importdata('filters.mat');
	a = filters.bandpassNa;
	b = filters.bandpassNb;
	% a = filters.bandpass2a;
	% b = filters.bandpass2b;
	% a = filters.designa;
	% b = filters.designb;

	if a(1)==1
	else
		a = a/a(1);
		b = b/b(1);
	end

	nSample = size(data,2);
	afilterSize = size(a,2);
    bfilterSize = size(b,2);
	filteredData = zeros(size(data));

	for t = 1:nSample
		filteredData(t) = b(1) * data(t);
		for n = 2:bfilterSize
			if (t+1-n)>0
				filteredData(t) = filteredData(t) + b(n)*data(t+1-n)
			else
				filteredData(t) = filteredData(t) + b(n)*pre(end+t+1-n)
			end
		end
		for n = 2:afilterSize
			if (t+1-n)>0
				filteredData(t) = filteredData(t) + a(n)*filteredData(t+1-n);
			else
				filteredData(t) = filteredData(t) + a(n)*post(end+t+1-n);
			end
		end
	end
end

