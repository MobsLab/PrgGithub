function coordinates=get_feature_coordinates(event,two_first_bins)
	if size(event,1)~=size(two_first_bins,1)
		error('Dimension mismatch');
	end
	coordinates=floor((event-two_first_bins(:,1))./(two_first_bins(:,2)-two_first_bins(:,1)))+1;