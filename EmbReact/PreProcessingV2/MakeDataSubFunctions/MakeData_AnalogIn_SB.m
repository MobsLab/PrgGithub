%% Alternative
LFP_temp=GetWideBandData(chanAnlg);
LFP_temp=LFP_temp(1:16:end,:);
AnlgTSD=tsd(LFP_temp(:,1)*1e4,LFP_temp(:,2));
save('AnalogInfo.mat','AnlgTSD')