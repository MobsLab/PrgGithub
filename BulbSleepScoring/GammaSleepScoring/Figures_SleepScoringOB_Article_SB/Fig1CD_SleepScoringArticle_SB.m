%% This code was used for Fig1 in draft for 11th april 2016
%% Evaluate bimodality of distribution
struc={'B','H','PF','Pa'};
clear chan filename2
AllSlScoringMice_SleepScoringArticle_SB;
smrange=[0.1,0.5,1,2,3,4,5];

cc=jet(length(smrange));

for file=1:m
    %Getting the right Epochs
    file
    cd(filename2{file})
    load('StateEpochSB.mat','NoiseEpoch','GndNoiseEpoch','Epoch');
    clear X Y
    
    for st=1:4
        if not(isnan(chan(file,st)))
            load(strcat('LFPData/LFP',num2str(chan(file,st)),'.mat'));
            rg=Range(LFP);
            TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
            
            % Generate the data of varying smoothness
            clear Hilgamma
            try 
                load(strcat('Hilgamma', num2str(st), '.mat'))
                
            catch
            Filgamma=FilterLFP(LFP,[50 70],1024);
            Restrict(Filgamma,TotalEpoch);
            Hilgamma=hilbert(Data(Filgamma));
            Hilgamma=tsd(Range(Filgamma),abs(Hilgamma));
            save(strcat('Hilgamma', num2str(st), '.mat'),'Hilgamma','-v7.3')
            end
                        smfact=floor(smrange/median(diff(Range(Hilgamma,'s'))));

            clear smooth_ghi_hil
            for i=1:length(smfact)
                i
                smooth_ghi_hil{i}=tsd(Range(Hilgamma),runmean(Data(Hilgamma),smfact(i)));
            end
            
            for i=1:length(smfact)
                [Y{i,st},X{i,st}]=hist(log(Data(smooth_ghi_hil{i})),700);
                st_ = [1.0e-2 X{i,st}(find(Y{i,st}==max(Y{i,st}))) 0.101 5e-3 X{i,st}(find(Y{i,st}==max(Y{i,st})))+1 0.21];
                [cf2,goodness2]=createFit2gauss(X{i,st},Y{i,st}/sum(Y{i,st}),st_);
                [cf1,goodness1]=createFit1gauss(X{i,st},Y{i,st}/sum(Y{i,st}));
                
                % goodness of fits
                rms{file,st}(i,1)=goodness1.sse;
                rms{file,st}(i,2)=goodness2.sse;
                rms{file,st}(i,3)=goodness1.rsquare;
                rms{file,st}(i,4)=goodness2.rsquare;
                rms{file,st}(i,5)=goodness1.adjrsquare;
                rms{file,st}(i,6)=goodness2.adjrsquare;
                rms{file,st}(i,7)=goodness1.rmse;
                rms{file,st}(i,8)=goodness2.rmse;
                % distance between peaks
                a= coeffvalues(cf2);
                dist{file,st}(i,1)=abs(a(2)-a(5));
                b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
                dist{file,st}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
                % overlap
                d=([min(X{i,st}):max(X{i,st})/1000:max(X{i,st})]);
                Y1=normpdf(d,a(2),max(a(3)/sqrt(2),mean(diff(d))));
                Y2=normpdf(d,a(5),max(a(6)/sqrt(2),mean(diff(d))));
                dist{file,st}(i,3)=sum(min(Y1,Y2)*mean(diff(d)));
                dist{file,st}(i,4)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
                coeff{file,st}(i,1:6)=a;
                coeff{file,st}(i,7:8)=intersect_gaussians(a(2), a(5), a(3), a(6));
                %                   clf
                %                   sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2)
                %                   sum(min(Y1,Y2)/sum(Y2))
                %                 plot(X{i,st},Y{i,st}/sum(Y{i,st}))
                                hold on
                                h_ = plot(cf2,'fit',0.95);
                %                 keyboard
            end
        end
    end
%     save('BimdodPapierData.mat','X','Y')
end
% save('/media/DataMOBsRAIDN/ProjetSlSc/AnalysisResults/ResultsPapier/BimodalityPapierResults.mat','rms','dist','coeff')

%%%
load('/media/DataMOBsRAIDN/ProjetSlSc/AnalysisResults/ResultsPapier/BimodalityPapierResultsOB.mat','rms','dist','coeff')
smrange=[0.25,0.5,0.75,1,1.5,2,2.5,3,3.5,4,4.5,5];


%% Ashman's D figure
figure

for st=1:4
    D{st}=[];Overlap{st}=[];

    for file=1:m
        try         
D{st}=[D{st},dist{file,st}(:,4)];
Overlap{st}=[Overlap{st},dist{file,st}(:,3)];

        end
    end
end

figure
st=1
g=shadedErrorBar(smrange,nanmean(Overlap{st}'),[stdError(Overlap{st}');stdError(Overlap{st}')],'k')

figure
st=1
g=shadedErrorBar(smrange,nanmean(D{st}'),[stdError(D{st}');stdError(D{st}')],'k')


%% Example figure
cd(filename2{13})
load('BimdodPapierData.mat')
cols=paruly(9);
i=5;
figure
for k=[1,2,3,7]
plot(X{k,1},runmean(Y{k,1}./max(Y{k,1}),30),'color',cols(i,:),'linewidth',3), hold on
i=i+1;
end


load(strcat('Hilgamma', num2str(1), '.mat'))
smfact=floor(smrange/median(diff(Range(Hilgamma,'s'))));
for i=1:length(smfact)
    i
    smooth_ghi_hil{i}=tsd(Range(Hilgamma),runmean(Data(Hilgamma),smfact(i)));
end
figure
Ep=intervalSet(5370*1e4,5460*1e4);
i=5;
for k=[1,2,3,7]
 plot(Range(Restrict(smooth_ghi_hil{k},Ep),'s'),Data(Restrict(smooth_ghi_hil{k},Ep)),'color',cols(i,:))   , hold on
i=i+1;
end
box off