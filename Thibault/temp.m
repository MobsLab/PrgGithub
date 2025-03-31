if exist('SleepScoring','var')
	sum=0;
	for i=1:size(IntanTTL.sleep_states,1)
		if IntanTTL.sleep_states(i,1:4)=='NREM'
			sum = sum+1;
		end
	end

	disp(['Percentage of stim during NREM: ', num2str(cast(sum,'double')*100/size(IntanTTL.sleep_states,1)), '%'])
end


test_hist = [];
for i=1:size(IntanTTL.ups_timestamps,2)
	for j=1:size(StimTTL.single_timestamps,2)
		if IntanTTL.ups_timestamps(i) > StimTTL.single_timestamps(j)
			continue;
		end

		if abs(IntanTTL.ups_timestamps(i) - StimTTL.single_timestamps(j))<500
			test_hist = [test_hist; abs(IntanTTL.ups_timestamps(i) - StimTTL.single_timestamps(j))];
		end
	end
end
histogram(test_hist);