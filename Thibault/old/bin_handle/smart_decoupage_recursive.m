function result = smart_decoupage_recursive(signal, spike_pos, bin_size)

if size(signal)<2*bin_size
	result = [];
else
	if spike_pos(1)<=bin_size
		is_spike=1;
		[spk_value,spk_center] = max(signal(1:2*bin_size));
		bin_signal=signal(spk_center:spk_center+2*bin_size-1);
		result=[is_spike bin_signal; smart_decoupage_recursive(signal(spk_center+bin_size:end), spike_pos(2:end)-spk_center-bin_size+1, bin_size)];
	else
		is_spike=0;
		bin_signal = signal(1:2*bin_size);
		result=[is_spike bin_signal; smart_decoupage_recursive(signal(bin_size+1:end), spike_pos(:)-bin_size, bin_size)];
	end

	
end