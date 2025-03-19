% gfp
GFP{1} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse498/20170309-EXT-24-laser13';
GFP{2} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse499/20170309-EXT-24-laser13'

GFP{3} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse504/20170316-EXT-24-laser13';
GFP{4} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse505/20170316-EXT-24-laser13';
GFP{5} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse506/20170316-EXT-24-laser13';

GFP{6} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse537/20170727-EXT24-laser13';

%% why no 24??
GFP{7} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse610/20171006-EXT-48';


% chR2
CHR2{1} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170309-EXT-24-laser13/FEAR-Mouse-496-09032017';
CHR2{2} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse497/20170309-EXT-24-laser13/FEAR-Mouse-497-09032017';

CHR2{3} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170727-EXT24-laser13';
CHR2{4} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse542/20170727-EXT24-laser13';
CHR2{5} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse543/20170727-EXT24-laser13';
% this mouse didn't freeze more than 50% of time on first CS+
%CHR2{6} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse612/20171005-EXT-24';%     %%%%%%%%%%%%%
CHR2{6} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171005-EXT-24';
CHR2{7} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse614/20171005-EXT-24';%     %%%%%%%%%%%%%


for k = 1:7
    cd(GFP{k})
    clear MovAcctsd FreezeAccEpoch
    load('behavResources.mat')
    % CSminus
    [M,T] = PlotRipRaw(MovAcctsd,TTL(find(TTL(:,2)==4),1),1000,0,0);
    CSMinus_GFP(k,:) = M(:,2);
    %CSPlus bef laser
    AllCSplus = TTL(find(TTL(:,2)==3),1);
    [M,T] = PlotRipRaw(MovAcctsd,AllCSplus(1:27*2),1000,0,0);
    CSPLusNoLaser_GFP(k,:) = M(:,2);
    %CSPlus after laser
    [M,T] = PlotRipRaw(MovAcctsd,AllCSplus(27*2+1:end),1000,0,0);
    CSPLusWiLaser_GFP(k,:) = M(:,2);
    %CSPlus after laser - freezing only
    CSOfInt = ts(AllCSplus(27*2+1:27*4)*1E4);
    CSOfInt = Restrict(CSOfInt,FreezeAccEpoch);
    [M,T] = PlotRipRaw(MovAcctsd,Range(CSOfInt,'s'),1000,0,0);
    try,CSPLusWiLaserFz_GFP(k,:) = M(:,2);
    catch
        CSPLusWiLaserFz_GFP(k,:) = nan(101,1);
    end
    
    cd(CHR2{k})
    clear MovAcctsd FreezeAccEpoch
    load('behavResources.mat')
    % CSminus
    [M,T] = PlotRipRaw(MovAcctsd,TTL(find(TTL(:,2)==4),1),1000,0,0);
    CSMinus_CHR2(k,:) = M(:,2);
    %CSPlus bef laser
    AllCSplus = TTL(find(TTL(:,2)==3),1);
    [M,T] = PlotRipRaw(MovAcctsd,AllCSplus(1:27*2),1000,0,0);
    CSPLusNoLaser_CHR2(k,:) = M(:,2);
    %CSPlus after laser
    [M,T] = PlotRipRaw(MovAcctsd,AllCSplus(27*2+1:end),1000,0,0);
    CSPLusWiLaser_CHR2(k,:) = M(:,2);
    %CSPlus after laser - freezing only
    CSOfInt = ts(AllCSplus(27*2+1:27*4)*1E4);
    CSOfInt = Restrict(CSOfInt,FreezeAccEpoch);
    [M,T] = PlotRipRaw(MovAcctsd,Range(CSOfInt,'s'),1000,0,0);
    try,CSPLusWiLaserFz_CHR2(k,:) = M(:,2);
    catch
        CSPLusWiLaserFz_CHR2(k,:) = nan(101,1);
    end
end


figure
subplot(141)
[hl,hp]=boundedline(M(:,1),nanmean(CSMinus_GFP),stdError(CSMinus_GFP),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(CSMinus_CHR2),stdError(CSMinus_CHR2),'alpha','b','transparency',0.2);
title('CSMinus')
xlabel('time to beep')
ylim([0 18*1E7])
subplot(142)
[hl,hp]=boundedline(M(:,1),nanmean(CSPLusNoLaser_GFP),stdError(CSPLusNoLaser_GFP),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(CSPLusNoLaser_CHR2),stdError(CSPLusNoLaser_CHR2),'alpha','b','transparency',0.2);
title('CSPLusNoLaser')
xlabel('time to beep')
ylim([0 18*1E7])
subplot(143)
[hl,hp]=boundedline(M(:,1),nanmean(CSPLusWiLaser_GFP),stdError(CSPLusWiLaser_GFP),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(CSPLusWiLaser_CHR2),stdError(CSPLusWiLaser_CHR2),'alpha','b','transparency',0.2);
title('CSPLusWiLaser')
xlabel('time to beep')
ylim([0 18*1E7])
subplot(144)
[hl,hp]=boundedline(M(:,1),nanmean(CSPLusWiLaserFz_GFP),stdError(CSPLusWiLaserFz_GFP),'alpha','g','transparency',0.2);
hold on
[hl,hp]=boundedline(M(:,1),nanmean(CSPLusWiLaserFz_CHR2),stdError(CSPLusWiLaserFz_CHR2),'alpha','b','transparency',0.2);
title('CSPLusWiLaser - only Fz')
xlabel('time to beep')
ylim([0 18*1E7])