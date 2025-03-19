function [sp_WAKE_pre,sp_WAKE_post,sp_SWS_pre,sp_SWS_post,sp_REM_pre,sp_REM_post,frq] = CRH_GetAverageSpectrum_SingleMouse_MC(Wake,SWSEpoch,REMEpoch,Spectro)

%define period pre and post injection
durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
epoch_pre = intervalSet(0,durtotal/2);
epoch_post = intervalSet(durtotal/2,durtotal);

%get spectro
spectre = tsd(Spectro.Spectro{2}*1E4,Spectro.Spectro{1});
frq = Spectro.Spectro{3};

%compute average spectrum
sp_WAKE_pre=nanmean(10*(Data(Restrict(spectre,and(epoch_pre,Wake)))),1);
sp_WAKE_post=nanmean(10*(Data(Restrict(spectre,and(epoch_post,Wake)))),1);

sp_SWS_pre=nanmean(10*(Data(Restrict(spectre,and(epoch_pre,SWSEpoch)))),1);
sp_SWS_post=nanmean(10*(Data(Restrict(spectre,and(epoch_post,SWSEpoch)))),1);

sp_REM_pre=nanmean(10*(Data(Restrict(spectre,and(epoch_pre,REMEpoch)))),1);
sp_REM_post=nanmean(10*(Data(Restrict(spectre,and(epoch_post,REMEpoch)))),1);