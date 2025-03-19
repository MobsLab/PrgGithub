function CheckMyUnit_SB(Number,Epoch)

% Example
% [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
% CheckMyUnit(TT{1})

load('SpikeData')
UnitNum = find(~cellfun(@isempty,strfind(cellnames,['TT' num2str(Number(1)) 'c' num2str(Number(2))])));
rg=Range((S{UnitNum}));
OverallFR = length(rg)./max(Range(S{UnitNum},'s'));

% Look at waveform
load(['Waveforms/WaveformsTT' num2str(Number(1)) 'c' num2str(Number(2)) '.mat'])
for elec = 1:size(W,2)
    Wftsd{elec} = tsd(rg,squeeze(W(:,elec,:)));
end

% Restrict
rg=Range(Restrict(S{UnitNum},Epoch));
for elec = 1:size(W,2)
    Wftsd{elec} = Restrict(Wftsd{elec},Epoch);
end
EpochFR = length(rg)./sum(Stop(Epoch,'s')-Start(Epoch,'s'));

% Don't plot all the waveforms
if length(Wftsd{1})<500
    pas=2;
elseif length(Wftsd{1})<5000
    pas=10;
else
    pas=100;
end

figure
% figure('Position',[2112 -11 853 952]);
for elec = 1:size(W,2)
    subplot(size(W,2),2,(elec-1)*2+1)
    dat = Data(Wftsd{elec});
    dat = dat(1:pas:end,:);
    plot(dat','color',[0.6 0.6 0.6]), hold on
    plot(nanmean(dat),'color','k','linewidth',2)
end

% textbox_str = {['NeuronNumber ' cellnames{UnitNum}],...
%     ['LRatio: ' num2str(Quality.LRatio(UnitNum))],...
%     ['IsoDistance: ' num2str(Quality.IsoDistance(UnitNum))],...
%     ['SubjectiveQuality: ' num2str(Quality.MyMark(UnitNum))],...
%     ['EpochFR: ' num2str(EpochFR) 'Hz'],...
%     ['OverallFR: ' num2str(OverallFR) 'Hz'],...
%     };
% 
% 
% annotation(gcf,'textbox',...
%     [0.55 0.8 0.3 0.15],...
%     'String',textbox_str,...
%     'LineWidth',1,...
%     'HorizontalAlignment','center',...
%     'VerticalAlignment','middle',...
%     'FontWeight','bold',...
%     'FitBoxToText','off');

subplot(5,2,[4,6])
[C,B]=CrossCorr(rg,rg,1,50);C(B==0)=0;
bar(B,C,'FaceColor','k','EdgeColor','k')
xlabel('time (ms)')
subplot(5,2,[4,6]+4)
[C,B]=CrossCorr(rg,rg,5,1000);C(B==0)=0;
bar(B,C,'FaceColor','k','EdgeColor','k')
xlabel('time (ms)')


end
