%compute_bin_sizes - 
%	 evaluate the two first bins in an event space
%
%----INPUT----
% list_events			2D array containing all spike events recorded
% N_bins				array containing the number of bins along each dimension
%
%----OUTPUT----
% two_first_bins 		array with two bins in each dimension
%



function two_first_bins=compute_two_first_bins(list_events,N_bins)

	if size(list_events,1)~=size(N_bins,2)
		error('dimensions are not compatible');
	end

	N_dim = size(list_events,1);

	two_first_bins=[];
	for dim=1:N_dim
		bins=[min(list_events(dim,:)):(max(list_events(dim,:))-min(list_events(dim,:)))/N_bins(dim):max(list_events(dim,:))];
		two_first_bins=[two_first_bins;bins(1) bins(2)];
	end

