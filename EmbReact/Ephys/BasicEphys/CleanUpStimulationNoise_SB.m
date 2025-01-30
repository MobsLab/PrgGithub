clear all
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel),'.mat'])
load('behavResources_SB.mat')

EyeShock = intervalSet(Start(TTLInfo.StimEpoch)-0.5*1E4, Start(TTLInfo.StimEpoch)+0.5*1E4);

HPCStim = TTLInfo.VHC_Stim_Epoch - EyeShock;

[M_Rip,T] = PlotRipRaw(LFP,Start(HPCStim ,'s'),1200);

RippleTemplate = M_Rip(:,2);
RippleTemplate(1:1495) = [];
dat = Data(LFP)*0;
datLFP = Data(LFP);
st_time = Start(HPCStim ,'s');
for st = 1:length(st_time)
    
    RangeToSearch = [find(Range(LFP,'s')>(st_time(st)),1,'first')-500 : find(Range(LFP,'s')>(st_time(st)),1,'first')+500];
    
    % best alignement
    clear val
    for i = 1:1000
        val(i) = sum(RippleTemplate(1:50).*datLFP(RangeToSearch(i):RangeToSearch(i)+49));
    end
    [~,ind] = max(val);
    RangeToReplace = [RangeToSearch(ind) : RangeToSearch(ind)+length(RippleTemplate)-1];
    Snippet = datLFP(RangeToReplace);
    
    % linear fit
    RippleTemplate_temp = zeros(1,length(Snippet));
    P = polyfit(RippleTemplate(1:50),Snippet(1:50),3);
    RippleTemplate_temp(1:50) = P(1)*RippleTemplate(1:50).^3+P(2)*RippleTemplate(1:50).^2+P(3)*RippleTemplate(1:50)+P(4);
    P = polyfit(RippleTemplate(51:end),Snippet(51:end),1);
    RippleTemplate_temp(51:end) = P(1)*RippleTemplate(51:end)+P(2);
    
    
    dat([RangeToSearch(ind):RangeToSearch(ind)+length(RippleTemplate_temp)-1]) =   dat([RangeToSearch(ind):RangeToSearch(ind)+length(RippleTemplate_temp)-1])+RippleTemplate_temp';
    
    %     plot(RangeToReplace(1),1E4,'*')
end

datLFP = Data(LFP) - dat;
