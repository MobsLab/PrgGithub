%% Evaluate bimodality of distribution
struc={'B','H','Pi','PF','Pa','PFSup','PaSup','Amyg'};
clear todo chan dataexis
m=1;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[1,10,NaN,4,13,6,2,NaN];

m=2;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[2,9,NaN,10,7,8,3,NaN];

m=3;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[6,10,NaN,5,13,1,7,NaN];

m=4;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,1,1,1];
chan(m,:)=[15,6,0,4,9,12,NaN,3];

m=5;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,0,0,1];
chan(m,:)=[11,2,12,8,4,15,NaN,15];

for s=[2,3,4,5,8]
struc{s}
    clear dist rms coeff
    for file=1:5
        %Getting the right Epochs
        file
        cd(filename2{file})
        if todo(file,s)==1
            load(strcat('LFPData/LFP',num2str(chan(file,s)),'.mat'));
            load('StateEpochSB.mat');
            rg=Range(LFP);
            TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
            try
                load('behavResources.mat','PreEpoch');
                TotalEpoch=And(TotalEpoch,PreEpoch);
            end
            
            % Generate the data of varying smoothness
            Filgamma=FilterLFP(LFP,[50 70],1024);
            Restrict(Filgamma,TotalEpoch);
            Hilgamma=hilbert(Data(Filgamma));
            Hilgamma=tsd(Range(Filgamma),abs(Hilgamma));
            smrange=[0.1,0.2,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5];
            smfact=floor(smrange/median(diff(Range(Hilgamma,'s'))));
            cc=jet(length(smfact));
            figure(1)
            figure(2)
            clear smooth_ghi_hil
          
            
            % Evaluate bimodality
            
            for i=1:length(smfact)
                clear smooth_ghi_hil
                smooth_ghi_hil{i}=tsd(Range(Hilgamma),smooth(Data(Hilgamma),smfact(i)));
                [Y,X]=hist(log(Data(smooth_ghi_hil{i})),700);
                figure(1)
                plot(X,Y/sum(Y),'color',cc(i,:))
                hold on
                [cf2,goodness2]=createFit2gauss(X,Y/sum(Y),[]);
                [cf1,goodness1]=createFit1gauss(X,Y/sum(Y));
                % goodness of fits
                rms{file}(i,1)=goodness1.sse;
                rms{file}(i,2)=goodness2.sse;
                rms{file}(i,3)=goodness1.rsquare;
                rms{file}(i,4)=goodness2.rsquare;
                rms{file}(i,5)=goodness1.adjrsquare;
                rms{file}(i,6)=goodness2.adjrsquare;
                rms{file}(i,7)=goodness1.rmse;
                rms{file}(i,8)=goodness2.rmse;
                
                % distance between peaks
                a= coeffvalues(cf2);
                dist{file}(i,1)=abs(a(2)-a(5));
                b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
                dist{file}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
                
                % overlap
                d=([min(X):max(X)/1000:max(X)]);
                Y1=normpdf(d,a(2),a(3));
                Y2=normpdf(d,a(5),a(6));
                dist{file}(i,3)=sum(min(Y1,Y2)/sum(Y2));
                dist{file}(i,4)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
                coeff{file}(i,1:6)=a;
                coeff{file}(i,7:8)=intersect_gaussians(a(2), a(5), a(3), a(6));
                figure(2)
                subplot(3,4,i)
                plot(X,Y/sum(Y))
                hold on
                h_ = plot(cf2,'fit',0.95);
                set(h_(1),'Color',[1 0 0],...
                    'LineStyle','-', 'LineWidth',2,...
                    'Marker','none', 'MarkerSize',6);
                h_ = plot(cf1,'fit',0.95);
                set(h_(1),'Color',[0 1 0],...
                    'LineStyle','-', 'LineWidth',2,...
                    'Marker','none', 'MarkerSize',6);
                h=legend({})
                delete(h)
                title(num2str(smrange(i)))
                
            end
            saveas(1,strcat('DistribsSuperposed',struc{s},'.png'))
            saveas(1,strcat('DistribsSuperposed',struc{s},'.fig'))
            saveas(2,strcat('DistribsFit',struc{s},'.png'))
            saveas(2,strcat('DistribsFit',struc{s},'.fig'))
            close(1), close(2)
        end
    end
cd /home/mobs/Documents/
save(strcat('bimod',struc{s},'.mat'),'rms','dist','coeff')
end
