function AllPeaks=FindPeaksForFrequency(LFP,Options,plo)

% LFP --> tsd with LFP on which to search of peaks and troughs
% Options.Fs=1250; % sampling rate of LFP
% Options.FilBand=[1 20];
% Options.std=[0.5 0.2]; % std limits for first and second round of peak
% finding
% Options.TimeLim=0.08; % in second, minimum distance between two minima or
% two maxima, 1./TimeLim gives max detecte freq

% function outputs times of peaks and troughs in seconds

LimLength= Options.TimeLim*Options.Fs;
NewPeak=[];
try plo; catch, plo=0; end

FilLFPP=FilterLFP(LFP,Options.FilBand,1024);
dat=Data(FilLFPP);
rmpath([GitHubLocation 'PrgGithub/chronux2/spectral_analysis/continuous'])
[YMax,XMax]=findpeaks(dat,'MinPeakHeight',std(dat)*Options.std(1),'MinPeakDistance',LimLength);
[YMin,XMin]=findpeaks(-dat,'MinPeakHeight',std(dat)*Options.std(1),'MinPeakDistance',LimLength);
addpath([GitHubLocation 'PrgGithub/chronux2/spectral_analysis/continuous'])

YMin=-YMin;
AllPeaks=sortrows([[XMin,-ones(length(XMin),1)];[XMax,ones(length(XMax),1)]],1);

CheckOrder=find(diff(AllPeaks(:,2))==0);
if plo,
    figure
    plot(Data(LFP)),hold on
    plot(dat)
    plot(XMin,YMin,'*')
    plot(XMax,YMax,'*')
end


while not(isempty(CheckOrder)) % while there are successions of peak/peak or trough/trough
    
    [val,ind]=min(sign(AllPeaks(CheckOrder(1),2))*dat(AllPeaks(CheckOrder(1),1):AllPeaks(CheckOrder(1)+1,1)));
    val=val*sign(AllPeaks(CheckOrder(1),2));
    if plo, xlim([AllPeaks(CheckOrder(1),1)-500,AllPeaks(CheckOrder(1),1)+500]);end
    if abs(val)>Options.std(2)*std(dat) & sign(val)==-sign(AllPeaks(CheckOrder(1),2))
        NewPeak(1,1)=AllPeaks(CheckOrder(1),1)+ind;
        NewPeak(1,2)=-sign(AllPeaks(CheckOrder(1),2));
        if plo,plot(AllPeaks(CheckOrder(1),1)+ind,val,'o');end
%         disp('add point')
    else
        if abs(dat(AllPeaks(CheckOrder(1),1)))<abs(dat(AllPeaks(CheckOrder(1)+1,1)))
            if plo,line([1 1]*AllPeaks(CheckOrder(1),1),ylim,'color','k');
%                 disp('remove previous point'),
            end
            AllPeaks(CheckOrder(1),:)=[];
        else
            if plo,line([1 1]*AllPeaks(CheckOrder(1)+1,1),ylim,'color','k');
                disp('remove following point'),
            end
            AllPeaks(CheckOrder(1)+1,:)=[];
        end
    end
    if not(isempty(NewPeak))
        AllPeaks=sortrows([AllPeaks;NewPeak],1);
    end
    if plo
        pause
    end
    CheckOrder=find(diff(AllPeaks(:,2))==0);
    NewPeak=[];
end

if plo
    figure
    plot(Range(LFP,'s'),Data(LFP)), hold on
    plot(Range(LFP,'s'),dat,'linewidth',3,'color',[0.3 0.3 0.3])
    plot(AllPeaks(:,1)/Options.Fs,dat(AllPeaks(:,1)),'r.','MarkerSize',25)
    xlim([0 10])
end
AllPeaks(:,1)=AllPeaks(:,1)/Options.Fs;

end
