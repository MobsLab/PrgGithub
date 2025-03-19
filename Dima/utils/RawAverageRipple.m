%PlotRipRaw
%
% [M,T] = PlotRipRaw(LFP, events, durations, cleaning, PlotFigure)
%
%
%%INPUT
% events : in seconds
% durations in ms
%
%%OUTPUT
% M :   time, mean, std, stdError
% T :   matrix
%
%


function [M,T] = PlotRipRaw(LFP, events, durations, cleaning, PlotFigure)


%% Inititiation
if exist('durations','var')
    if isdvector(durations,'#1')
        durations = [-durations durations];
    elseif isdvector(durations,'#2','>0')
        durations(1) = -durations(1);
    end
else
    durations = [-50 50]; %50ms
end
durations = durations/1000; %convert in s

if ~exist('cleaning','var')
    cleaning=0;
end
if ~exist('PlotFigure','var')
    PlotFigure=1;
end

%params
samplingRate = round(1/median(diff(Range(LFP,'s'))));
nBins = floor(samplingRate*diff(durations)/2)*2+1;

%events
if size(events,2)>2
    events_tmp = events(:,2);
else
    events_tmp = events;
end

%signals
rg = Range(LFP)/1e4;
LFP_signal = [rg-rg(1) Data(LFP)];


%% Sync
[r,i] = Sync(LFP_signal,events_tmp,'durations',durations);
T = SyncMap(r,i,'durations',durations,'nbins',nBins,'smooth',0);


%% cleaning
if cleaning
    [h,~] = hist(diff(T),100);
    mh=max(h);
    %id=find(mh>mean(mh)+20*std(mh));
    id=find(mh>2*size(T,1)/3);
    % id=find(sum(T)==0);
    idx=find(diff(id)==1);
    id([idx idx+1])=[];
    
    
    if ~isempty(id)
        disp(['Attention problem ! ',num2str(length(id)),' bin(s) at zero'])
        if id(1)>1&id(end)<size(T,2)
            T(:,id)=(T(:,id-1)+T(:,id+1))/2; %!!!! line modified by GL on the 1/05/2015 : new line above :
        elseif id(end)==size(T,2)
            T(:,id(end))=T(:,id(end)-1);
            T(:,id(1:end-1))=(T(:,id(1:end-1)-1)+T(:,id(1:end-1)+1))/2;
        elseif id(1)==1
            T(:,id(1))=T(:,id(1)-1);
            T(:,id(2:end))=(T(:,id(2:end)-1)+T(:,id(2:end)+1))/2;
        end
    end
    %keyboard
end


%% result

%nbin
if size(T,2)>nBins
    nBins=nBins+1;
elseif size(T,2)<nBins
    nBins=nBins-1;
end

%result
try
    M=[((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];
catch
    M=[];
    disp('error')
end


%% Plot
try
    if PlotFigure
        
        figure('Color',[1 1 1])
        
        subplot(1,2,1), hold on
        plot(((1:nBins)'-ceil(nBins/2))/nBins*diff(durations),mean(T),'r','linewidth',2);
        title(['Ripples (raw data) n=' num2str(size(events,1))])
        xlim(durations)
        
    end
end

end

