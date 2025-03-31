function plotSleepScoring(sleepScoring, color)

	if ~exist('color','var')
		color='k';
	end

	data = zeros(size(sleepScoring,1),1);
	for scoring=1:size(data,1)

		if ismember(sleepScoring(scoring),'NREM')
			data(scoring) = 1;

		elseif ismember(sleepScoring(scoring),'REM')
			data(scoring) = 2;

		elseif ismember(sleepScoring(scoring),'Wake')
			data(scoring) = 3;

		elseif ismember(sleepScoring(scoring),'Undefined')
			% data(scoring) = 4;
			data(scoring) = data(scoring-1);

		else
			disp(strcat('Problem occured at score ',num2str(scoring)));

		end
	end

	plot(data, color);
	ylim([0 4]);
	set(gca,'YTick',[1 2 3]);
	set(gca,'YTickLabel',{'SWS', 'REM', 'Wake'});

end