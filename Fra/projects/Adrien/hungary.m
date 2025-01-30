[merde, dataset] = fileparts(pwd);
%  
%  for i=1:6
%  
%  	isZip = false;	
%  	eegfname = [dataset 'eeg' num2str(i) '.mat'];
%  	if exist([eegfname '.gz'])
%  	display(['unzipping file ' eegfname]);
%  	eval(['!gunzip ' eegfname '.gz']);
%  	iszip = true;
%  	end
%  	load(eegfname)
%  
%  	if isZip 
%  		display('rezzipping file');
%  		eval(['!gzip ' eegfname '.gz']);
%  	end
%  
%  	eval(['eeg' num2str(i) 'Data = Data(EEG' num2str(i) ');']);
%  	eval(['eeg' num2str(i) 'Range = Range(EEG' num2str(i) ');']);
%  
%  	save(['Hungary' dataset 'eeg' num2str(i)],['eeg' num2str(i) 'Data'],['eeg' num2str(i) 'Range'],'-v6')
%  	display('zipping eeg files')
%  	eval(['!gzip Hungary' dataset 'eeg' num2str(i) '.mat']);
%  
%  end

cd('../..')
A = getResource(A,'PosXS',['Rat20/' dataset]);
A = getResource(A,'PosYS',['Rat20/' dataset]);
cd(['Rat20/' dataset]);
XData = Data(XS{1});
XRange = Range(XS{1});

YData = Data(YS{1});
YRange = Range(YS{1});

save(['Hungary' dataset 'pos'],'XData','XRange','YData','YRange','-v6');
