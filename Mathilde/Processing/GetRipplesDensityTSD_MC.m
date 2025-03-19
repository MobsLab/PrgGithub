function [Ripples_tsd] = GetRipplesDensityTSD_MC(RipplesEpoch)


res=pwd;
nam='dHPC_rip';
eval(['tempchHPCrip=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chHPCrip=tempchHPCrip.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHPCrip),'.mat'');'])



% if exist('SWR.mat')
%     load('SWR', 'RipplesEpoch')
    [Y,X] = hist(Start(RipplesEpoch,'s'),[0:1:max(Range(LFP,'s'))]);
    Ripples_tsd = tsd(X*1E4,Y');
% else
%     load('Ripples.mat', 'RipplesEpoch');
%     [Y,X] = hist(Start(RipplesEpoch,'s'),[0:1:max(Range(LFP,'s'))]);
%     Ripples_tsd = tsd(X*1E4,Y');
% end