function Bimod_S_by_S(filename,channels,struc)
close all
%% Evaluate bimodality of distributions in all structures at different smoothing rates
smrange=[0.1,0.2,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]; % in seconds
    cd(filename)
load(strcat('LFPData/LFP',num2str(channels(1)),'.mat'));
load('StateEpochSB.mat');
rg=Range(LFP);
TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
TotalEpoch=And(TotalEpoch,Epoch);
TotalEpoch=CleanUpEpoch(TotalEpoch);

try
    load('behavResources.mat','PreEpoch');
    TotalEpoch=And(TotalEpoch,PreEpoch);
end

for s=1:length(struc)
    
    disp(strcat('Bimodality in ',struc{s}))
        %Getting the right Epochs
    if ~isnan(channels(s))
        load(strcat('LFPData/LFP',num2str(channels(s)),'.mat'));
        
        % Generate the data of varying smoothness
        Filgamma=FilterLFP(LFP,[50 70],1024);
        Restrict(Filgamma,TotalEpoch);
        Hilgamma=hilbert(Data(Filgamma));
        Hilgamma=tsd(Range(Filgamma),abs(Hilgamma));
        smfact=floor(smrange/median(diff(Range(Hilgamma,'s'))));
        cc=jet(length(smfact));
        figure(1);
        figure(2);
        
        
        % Evaluate bimodality
        
        for i=1:length(smfact)
            clear smooth_ghi_hil
            smooth_ghi_hil=tsd(Range(Hilgamma),runmean(Data(Hilgamma),smfact(i)));
            [Y,X]=hist(log(Data(Restrict(smooth_ghi_hil,Epoch))),700);
            Y=Y/sum(Y);
            
            [rms{s,i},dist{s,i},coeff{s,i},cf1,cf2]=BimodParams(smooth_ghi_hil);
            
%             figure(1)
%             plot(X,Y,'color',cc(i,:))
%             hold on
%             
%             figure(2)
%             subplot(3,4,i)
%             plot(X,Y)
%             hold on
%             h_ = plot(cf2,'fit',0.95);
%             set(h_(1),'Color',[1 0 0],...
%                 'LineStyle','-', 'LineWidth',2,...
%                 'Marker','none', 'MarkerSize',6);
%             h_ = plot(cf1,'fit',0.95);
%             set(h_(1),'Color',[0 1 0],...
%                 'LineStyle','-', 'LineWidth',2,...
%                 'Marker','none', 'MarkerSize',6);
%             h=legend({})
%             delete(h)
%             title(num2str(smrange(i)))
            
        end
%         saveas(1,strcat('DistribsSuperposed',struc{s},'.png'))
%         saveas(1,strcat('DistribsSuperposed',struc{s},'.fig'))
%         saveas(2,strcat('DistribsFit',struc{s},'.png'))
%         saveas(2,strcat('DistribsFit',struc{s},'.fig'))
%         close(1), close(2)
    end
end

save('AllStrucBimod.mat','rms','dist','coeff')

end
