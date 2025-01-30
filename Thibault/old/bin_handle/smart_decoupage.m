function result = smart_decoupage(signal, spike_pos, bin_size)

result=[];
k=1;
cursor=1;
while size(signal(cursor:end),2)>2*bin_size
	pos = find_next_max(signal(cursor:end),bin_size);
	pos=pos+cursor-1;
	if (size(signal(pos:end),2)>=bin_size) && (pos>bin_size)
		if (spike_pos(k)<=pos) && (spike_pos(k)>=pos-bin_size)
			is_spike=1;
			k=k+1;
		else
			is_spike=0;
		end
		result = [result; is_spike signal(pos-bin_size:pos+bin_size-1)];
		cursor = pos+bin_size;
	elseif (pos<=bin_size)
		cursor = bin_size+1;
	else
		cursor = size(signal,2)-1
	end
end
