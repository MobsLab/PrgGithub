function result = normalise_deg1(signal)

nb_dim=ndims(signal);
result=signal;
tot=0;
for i = 1:size(signal,2)
    tot=tot+signal(i);
end

for j = 1:size(signal,2)
    result(j)=signal(j)/sqrt(snorm);
end

end