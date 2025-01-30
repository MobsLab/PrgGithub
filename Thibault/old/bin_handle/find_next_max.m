function result = find_next_max(signal, bin_size)

[value,pos] = max(signal(1:bin_size));
if size(signal(pos:end),2)<=bin_size
	[value,test_pos] = max(signal(pos:end));
	result=test_pos+pos-1;
else
	[value,test_pos] = max(signal(pos:pos+bin_size));
	test_pos=test_pos+pos-1;
	if test_pos==pos
		result=pos;
	else
		result=pos+find_next_max(signal(pos+1:end),bin_size);
	end
end
