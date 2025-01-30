function DetectLaserStim_Dat(fbasename,chanIx,varargin)

% This function detect pulses >0.2V in one or several of the recording channels. It generates a .stim file
% USAGE:
%     DetectPulseChannel(fbasename,chanIx,options)
% 
%   INPUT:
%     fbasename: file base name
%     chanIx: vector of channel number
%     
%     options are in the form 'optionname','value'
%     'datFiles': in the case different inputs were used on the same channel 
%     but during different recordings. For instance, two optic fibers were illuminated
%     in two different protocols using the same laser and monitoring channel.
%     then datFile takes a cell array of vectors indicating each group of recordings were
%     one given optic fiber was used.
%     If OF1 was illuminated during recordings 1 3 and 5, and OF2 during 4 and 6 (as defined in
%     the 'multiFileProcessing' field of the xml file), and channel 65 was used then call
%     DetectPulseChannel(fbasename,65,'datFiles',{[1 3 5],[4 6]})
%     
%   OUTPUT
%     a .stim file made of 5 columns:
%     1/ time of rising edge of the pulse (in number of samples of eeg)
%     2/ length of pulse (difference between falling edge and rising)
%     3/ voltage of pulse
%     4/ channel number
%     5/ group identity (as defined in 'datFiles')
%     
%     
% Adrien Peyrache 2011

datFiles = {};

% Parse options
for i = 1:2:length(varargin),
  if ~isa(varargin{i},'char'),
    error(['Parameter ' num2str(i+3) ' is not a property (type ''help LoadBinary'' for details).']);
  end
  switch(lower(varargin{i})),
    case 'datfiles',
      datFiles = varargin{i+1};
      if ~isa(datFiles,'cell')
        error('Incorrect value for property ''datFiles'' (type ''help LoadBinary'' for details).');
      end
  end
end

minLength = 1; %minimum length of pulses in msec.
minVoltage = 0.5; %minimum voltage of pulses.

xmlFname = [fbasename filesep fbasename '.xml'];

if ~exist(xmlFname,'file')
    error(['XML file ''' xmlFname ''' does not exist'])
end


xmldata = xml_load(xmlFname);
segnames = xmldata.multiFileProcessing.files;
nChannels = str2double(xmldata.acquisitionSystem.nChannels);

Fs = str2double(xmldata.acquisitionSystem.samplingRate);

%amplification = str2double(xmldata.acquisitionSystem.amplification)
amplification = 5/2^15/400*1e6/820;

minLength = round(minLength*Fs/1000);

chanIx = chanIx(:)';

nbProtocols = length(datFiles);
datSeg = [fbasename filesep 'DatSegments.txt'];
if ~exist(datSeg,'file')
      error(['DatSegments file ''' xmlFname ''' does not exist'])
end
datSegments = load(datSeg)*10000/1250;
if ~nbProtocols
    datFiles = {(1:length(datSegments))};
    nbProtocol=1;
end
datSegments = intervalSet([0;cumsum(datSegments(1:end-1))]',[cumsum(datSegments)-1]);    


stim = [];

for ii=chanIx
    fprintf('Detecting pulses in channel %d...\n',ii);
    fprintf('\tProtocol ')
    
    for grp=1:nbProtocols
        
        fprintf('%d ',grp);
        dFiles= datFiles{grp};
        data = tsd([],[]);
        for jj=1:length(dFiles)
            fId = num2str(dFiles(jj));
            if length(fId)==1
                fId = ['0' fId];
            end
            datname = [fbasename '-' fId];
            fname = [datname filesep datname '.dat'];
            d = LoadBinary(fname,'frequency',Fs,'nChannels',nChannels,'channels',ii);
            d = tsd(10000*(0:length(d)-1)'/double(Fs) + Start(subset(datSegments,dFiles(jj))),double(d)*amplification);
            keyboard
            %data = cat(data,d);
        end
        
        epdw = thresholdIntervals(abs(dataR),minVoltage,'Direction','Below');
        epdw = dropShortIntervals(epdw,4000);
        epdw = intervalSet(Start(epdw)+250,End(epdw)-250);
        epup = dropShortIntervals(subset(datSegments,datFiles{grp})-epdw,1);
        
        eplg = dropShortIntervals(epup,2000);
        epspe = intervalSet([],[]);
        
        for epix = 1:length(Start(eplg))
            datar = Data(Restrict(dataR,subset(eplg,epix)));
            d = diff(datar);
            if ~any(d>2*minVoltage)
                epspe = union(epspe,subset(eplg,epix));
            end
        end

        epPulse = epup - epspe;
        [risingIx fallingIx voltage] = Pulse_Detection(Restrict(dataR,epPulse),minVoltage);
        
        rg = Range(dataR,'s');
        
        figure(1),clf
        plot(rg,Data(dataR))
        hold on
        plot(risingIx/10000,voltage,'g+')
        plot(Start(epup,'s'),1,'r+')
        plot(End(epup,'s'),1,'k+')
        
        for speix = 1:length(Start(epspe))
           
            datar = Restrict(dataR,subset(epspe,speix));
            L = length(Data(datar));
            NFFT = 2^nextpow2(L);
            Y = fft(Data(datar),NFFT)/L;
            f = Fs/2*linspace(0,1,NFFT/2+1);
            Y = 2*abs(Y(1:NFFT/2+1));
            [pow,fix] = max(Y(f>0.5));
            
            fqcy = f(fix);
            disp([fqcy pow]);
            
            figure(2),clf
            plot(Range(datar,'s'),(Data(datar)))
            keyboard
            %pause
            
        end
        
        stimL = fallingIx-risingIx;
        risingIx(stimL<minLength) = [];
        voltage(stimL<minLength) = [];
        stimL(stimL<minLength) = [];
        stimTmp = [risingIx stimL voltage ii*ones(length(stimL),1) grp*ones(length(stimL),1)];
        stim = [stim;stimTmp];
    end
    fprintf('\n');
end
%stim = sort(stim,1);
dlmwrite([fbasename '.stim'],stim,'precision','%9d');

