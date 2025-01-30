function DetectLaserStim(fbasename,chanIx,varargin)

% This function detect pulses >0.2V in one or several of the recording channels.
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
%     a fbasename_OptoStim.mat file containing three variables.
% 
%     - 'pulseStim' made of 5 columns:
%     1/ time of rising edge of the pulse (in 1/10 of msec.)
%     2/ length of pulse (difference between falling edge and rising)
%     3/ voltage of pulse
%     4/ channel number
%     5/ group identity (as defined in 'datFiles')
% 
%     - 'sineW', a structure for pure sinusoidal stimulations where
%     sineW.St is the beginning of the stimulation
%     sineW.En is the end
%     sineW.V is the voltage
%     sineW.Fqcy is the frequency
%     sineW.Protocol is the protocol
%     
%     - 'zapW', a structure for pure sinusoidal stimulations where
%     zapW.St is the beginning of the stimulation
%     zapW.En is the end
%     zapW.V is the voltage
%     zapW.FqcySt is the starting frequency
%     zapW.FqcyEn is the final frequency
%     zapW.Protocol is the protocol
%     
%     
% Adrien Peyrache 2012

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

eegFname = [fbasename '.eeg'];
xmlFname = [fbasename '.xml'];

if ~exist(xmlFname,'file')
    error(['XML file ''' xmlFname ''' does not exist'])
end


xmldata = xml_load(xmlFname);
segnames = xmldata.multiFileProcessing.files;
nChannels = str2double(xmldata.acquisitionSystem.nChannels);
lfpFS = str2double(xmldata.fieldPotentials.lfpSamplingRate);

%amplification = str2double(xmldata.acquisitionSystem.amplification)
amplification = 5/2^15/400*1e6/820;
minLength = round(minLength*10);

chanIx = chanIx(:)';

nbProtocols = length(datFiles);
if ~exist('DatSegments.txt','file')
      error(['DatSegments file ''' xmlFname ''' does not exist'])
end
datSegments = load('DatSegments.txt')*10000/lfpFS;
if ~nbProtocols
    datFiles = {(1:length(datSegments))};
    nbProtocol=1;
end
datSegments = intervalSet([0;cumsum(datSegments(1:end-1))]',[cumsum(datSegments)-1]);    

stim = [];
sineW = struct();
    sineW.Start = [];
    sineW.End = [];
    sineW.V = [];
    sineW.Fqcy = [];

zapW = struct();
    zapW.Start = [];
    zapW.End = [];
    zapW.V = [];
    zapW.FqcySt = [];
    zapW.FqcyEn = [];    

for ii=chanIx
    fprintf('Detecting pulses in channel %d...\n',ii);

    data = LoadBinary(eegFname,'frequency',lfpFS,'nChannels',nChannels,'channels',ii);
    data = tsd(10000*(0:length(data)-1)'/double(lfpFS),double(data)*amplification);
    fprintf('\tProtocol ')
    
    for grp=1:nbProtocols
        
        fprintf('%d ',grp);

        dataR = Restrict(data,subset(datSegments,datFiles{grp}));
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
        epPulse = dropShortIntervals(epPulse,20);
        [risingIx fallingIx voltage] = Pulse_Detection(Restrict(dataR,epPulse),minVoltage);
        
        rg = Range(dataR,'s');
        if 1
            figure(1),clf
            plot(rg,Data(dataR))
            hold on
            plot(risingIx/10000,voltage,'g+')
        end

        plot(Start(epup,'s'),1,'r+')
        plot(End(epup,'s'),1,'k+')
        stimL = fallingIx-risingIx;
        risingIx(stimL<minLength) = [];
        voltage(stimL<minLength) = [];
        stimL(stimL<minLength) = [];
        stimTmp = [1250*risingIx/10000 1250*stimL/10000 voltage ii*ones(length(stimL),1) grp*ones(length(stimL),1)];
        stim = [stim;stimTmp];
                
        for speix = 1:length(Start(epspe))
           
            epStim = subset(epspe,speix);
            datar = Restrict(dataR,epStim);
            d = Data(datar);
            rg = Range(datar);
            clear datar;
            
            ix=match(0, d, 0.05, 1);
            %Here, we need to get rid of low-pass filter within the
            %amplifier only for stim>1Hz or so
            
            if median(diff(rg(ix)))<3000 && length(d)>4*1024
                b = fir1(1024,1/625,'high');
                d = filtfilt(b,1,d);
                ix=match(0, d, 0.05, 1);
            elseif median(diff(rg(ix)))<1500
                b = fir1(256,3/625,'high');
                d = filtfilt(b,1,d);
                ix=match(0, d, 0.05, 1);
            end

            cycleW = median(diff(ix));
            mins = LocalMinima(d, cycleW, -minVoltage);
            maxs = LocalMinima(-d, cycleW, -minVoltage);
            
            if length(mins)>length(maxs)
                if mins(1)>maxs(1)
                    mins = mins(1:length(maxs));
                else
                     mins = mins(length(mins)-length(maxs)+1:end);
                end
            else
                if mins(1)>maxs(1)
                    maxs = maxs(1:length(mins));
                else
                    maxs = maxs(length(maxs)-length(mins)+1:end);
                end
            end
            pow = round(10*median(d(maxs)-d(mins)))/10;
            cycles = rg(mins)-rg(maxs);
            if std(cycles)<0.1*median(cycles)
                %type = 'Sine';
                fqcy = round(10*0.5*10000/median(cycles))/10;
                sineW.Start = [sineW.Start;Start(epStim,'s')*1250];
                sineW.End = [sineW.End;End(epStim,'s')*1250];
                sineW.V = [sineW.V;pow];
                sineW.Fqcy = [sineW.Fqcy;fqcy];
            else
                %type = 'Zap';
                fqcy = round(10*0.5*10000./[cycles(1) cycles(end)])/10;
                zapW.Start = [zapW.Start;Start(epStim,'s')*1250];
                zapW.End = [zapW.End;End(epStim,'s')*1250];
                zapW.V = [zapW.V;pow];
                zapW.FqcySt = [zapW.FqcySt;fqcy(1)];
                zapW.FqcyEn = [zapW.FqcyEn;fqcy(2)];
            end
            
            if 0
                figure(2),clf
                plot(rg,d)
                hold on
                plot(rg(mins),d(mins),'r*')
                plot(rg(maxs),d(maxs),'g*')
                title(['Pow: ' num2str(pow) '; Fqcy: ' num2str(fqcy)])
                pause
            end
            
        end
        
       
    end
    fprintf('\n');
end

pulseStim = stim;
save([fbasename '_optoStim.mat'],'pulseStim','sineW','zapW');

