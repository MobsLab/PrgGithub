%normalise_deg1
% normalise to the first degree a signal of any dimension.
% First degree meaning like a probability law, we want the sum of all probabilities to be one.

function result = normalise_deg1(signal)

nb_dim=ndims(signal);
result=signal;

tot=sum(signal);
for dim = 1:nb_dim-1
    tot=sum(tot);
end

if tot
	result=result/tot;
end