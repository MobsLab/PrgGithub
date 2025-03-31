function [distance,scr]=interval_distance_KJ(train_i,train_j,cost,total_length)
%
% Inspired from spike train interval
% (Victor & Purpura 1996) for a single cost
%
% calculates distance between two trains of event in the spike interval metric
% by a continuum modification of the sellers algorithm

% end conditions: the first and last ISI are expanded as needed to minimize
% the total cost

% INPUT
%   train_i: vector spike times for first train
%   train_j: vector spike times for second train
%   cost: cost per unit time to move an event
%   total_length: the length of the entire interval

nb_train_i = length(train_i); % number of spike times in train 1
nb_train_j = length(train_j); % number of spike times in train 2

ni  = nb_train_i + 1; % number of intervals in train 1
nj  = nb_train_j + 1; % number of intervals in train 2
scr = zeros(ni+1,nj+1);

% define calculation for a cost of zero
if cost==0
	distance = abs(ni-nj);
	return
end
% INITIALIZE MARGINS WITH COST OF ADDING AN EVENT
scr(:,1) = (0:ni)';
scr(1,:) = (0:nj);

tli_diff = diff(train_i);
tlj_diff = diff(train_j);

for i = 1:ni
	if (i > 1) && (i < ni)
		di = tli_diff(i-1);  %di = tli(i)-tli(i-1);
	elseif (i == 1) && (i == ni)
		di = total_length;
	elseif (i == 1) && (i < ni)
		di = train_i(i);
    else  %(i > 1) && (i == ni)
		di = total_length-train_i(i-1);
    end

	iend = ((i == 1) || (i == ni));

	% unrolled loop for j = 1
	% ------------------------
	if (nj == 1)
		dj = total_length;
    else  %(j < nj)
		dj = train_j(1);
    end

	if iend
		dist = 0;
    else  %jend
		dist = max(0,dj-di);
    end

	scr(i+1,2)=min([scr(i,2)+1 scr(i+1,1)+1 scr(i,1)+cost*dist]);

	% main code
	% --------- 
	for j = 2:nj-1
		dj = tlj_diff(j-1);
 
		if iend
			dist = max(0,di-dj);
        else
			dist = abs(di-dj);
        end
		tmp = min(scr(i,j+1)+1,scr(i+1,j)+1);
		scr(i+1,j+1)=min(tmp,scr(i,j)+cost*dist);
    end

	% unrolled loop for j = nj
	% ------------------------ 
	if (nj == 1)
		dj = total_length;
    else  %(j > 1) && (j == nj)
		dj = total_length-train_j(nj-1);
    end

	if iend
		dist = 0;
    else  %jend
		dist = max(0,dj-di);
    end
	scr(i+1,nj+1)=min([scr(i,nj+1)+1 scr(i+1,nj)+1 scr(i,nj)+cost*dist]);

end

distance = scr(ni+1,nj+1);





