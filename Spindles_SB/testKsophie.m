%testKsophie

voie{1}='23';
voie{2}='24';
voie{3}='26';
voie{4}='21';
voie{5}='20';
voie{6}='25';
voie{7}='22';
voie{8}='29';
voie{9}='30';
voie{10}='31';

close all

refch=[11 2 21 23 25 26];

load behavResources

for a=1:6
    

for i=[20,21,22,23,25,26,30]
    
        try

            ch=i;
            ch=num2str(ch);

            eval(['load NoiseEPochs_',ch,])

            %load StateEpoch NoiseEpoch GndNoiseEpoch
            NEpoch=SWSEpoch-NoiseEpoch;
            NEpoch=NEpoch-GndNoiseEpoch;

            
            if 1
                
            eval(['load(''/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/SpindlesTry6/Sophie_spindles_51_try6_',ch,'.mat'')'])
            Epoch=intervalSet(brst_all_freq_nonoise.t_start*1E4,brst_all_freq_nonoise.t_end*1E4);
            
            else
            
            
                            Epoch=[];
                for v=1:10
                        eval(['load(''/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/SpindlesTry6/safe/Sophie_spindles_51_try6_',voie{v},'.mat'')'])
                        if v==1
                            Epoch=intervalSet(brst_all_freq_nonoise.t_start*1e4,brst_all_freq_nonoise.t_end*1e4);
                        else
                        Epoch_int=intervalSet(brst_all_freq_nonoise.t_start*1e4,brst_all_freq_nonoise.t_end*1e4);
                        Epoch=OR(Epoch_int,Epoch);
                        Epoch = mergeCloseIntervals(Epoch, 0.01*1e4);
                        end
                end
                begin=Start(Epoch);
                halt=Stop(Epoch);
                Epochbeg=intervalSet(max(begin-2.5e4,0),halt);
                Epochhalt=intervalSet(begin,halt+2.5e4);
                Epochbeg=mergeCloseIntervals(Epochbeg, 0.01*1e4);
                Epochhalt=mergeCloseIntervals(Epochhalt, 0.01*1e4);
                Epoch=OR(Epochbeg,Epochhalt);

            end
            
            
            
            
            %eval(['load(''/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/SpectrumDataL/Spectrum',ch,'.mat'')'])
            %eval(['load(''/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/SpectrumDataL/Spectrum','11','.mat'')'])
            eval(['load(''/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/SpectrumDataL/Spectrum',num2str(refch(a)),'.mat'')'])
            %eval(['load(''/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/SpectrumDataL/Spectrum','2','.mat'')'])
            
            %f2=f;
            f2=ones(size(f,1),size(f,2));

            Sptsd=tsd(t*1E4,Sp);

            %figure('color',[1 1 1]), plot(f,f2.*(mean(Data(Restrict(Sptsd,Epoch-CPEpoch)))),'r'), hold on, plot(f,f2.*(mean(Data(Restrict(Sptsd,NEpoch-CPEpoch)))),'b')


            figure('color',[1 1 1]), 
            subplot(3,1,1), plot(f,f2.*(mean(Data(Restrict(Sptsd,Epoch-CPEpoch)))),'k'), hold on, plot(f,f2.*(mean(Data(Restrict(Sptsd,and(Epoch,CPEpoch))))),'r'),title(['Spindles epochs, channel: ',ch,' sp:',num2str(refch(a))])
            subplot(3,1,2), plot(f,f2.*(mean(Data(Restrict(Sptsd,NEpoch-CPEpoch)))),'color',[0.6 0.6 0.6]), hold on, plot(f,f2.*(mean(Data(Restrict(Sptsd,and(NEpoch,CPEpoch))))),'r'),title(['SWS, channel: ',ch])
            subplot(3,1,3), plot(f,f2.*(mean(Data(Restrict(Sptsd,Epoch-CPEpoch)))),'m'), hold on, plot(f,f2.*(mean(Data(Restrict(Sptsd,NEpoch-CPEpoch)))),'b'),title(['Spindles epochs versus SWS (basal)'])
        end



        tfreq=tsd(time_freq_final(:,1)*1E4,time_freq_final(:,2));

        clear v
        clear H
        a=1;
        b=1;

        clear id
        clear id2
        clear tpsSpi

        ti=1;
        for i=1:length(Start(Epoch))
        data= Data(Restrict(tfreq,subset(Epoch,i)));
            try
                for k=1:10
                     M(ti,k)=mean(data(data(:,2)==2*k+1,3));
                end
                ti=ti+1;

            end

            H(i,:)=hist(Data(Restrict(tfreq,subset(Epoch,i))),[0:2:25]);
            v(i)=std(Data(Restrict(tfreq,subset(Epoch,i))));
            if v(i)<nanmean(v)
                id(a)=i;
                a=a+1;
            else
                id2(b)=i;
            b=b+1;
            end



    %         [BE,idmax]=max(H(i,:));
    %         temp=[0:2:25];
    %         []
    %         tpsSpi(i)=temp(idmax);


            end



            figure('color',[1 1 1]), 
                    plot(f,f2.*(mean(Data(Restrict(Sptsd,subset(Epoch,id)-CPEpoch)))),'b'), hold on, plot(f,f2.*(mean(Data(Restrict(Sptsd,(subset(Epoch,id2)-CPEpoch))))),'m'),title(['Difference betwwen spindles with variable (m) versus non-variable (b) frequencies ',ch])

            figure('color',[1 1 1]), 
                    subplot(2,1,1), plot(f,f2.*(mean(Data(Restrict(Sptsd,subset(Epoch,id)-CPEpoch)))),'k'), hold on, plot(f,f2.*(mean(Data(Restrict(Sptsd,and(subset(Epoch,id),CPEpoch))))),'r'),title(['Difference betwwen spindles with non-variable frequencies ',ch])
                    subplot(2,1,2), plot(f,f2.*(mean(Data(Restrict(Sptsd,subset(Epoch,id2)-CPEpoch)))),'color',[0.7 0.7 0.7]), hold on, plot(f,f2.*(mean(Data(Restrict(Sptsd,and(subset(Epoch,id2),CPEpoch))))),'r'),title(['Difference betwwen spindles with variable frequencies ',ch])

end


% merge all Epochs of spindles across channels +/-2sec
% use find spindles here to look at spindles

end

% 
% Epoch=[];
% for v=1:10
%         eval(['load(''/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/SpindlesTry6/safe/Sophie_spindles_51_try6_',voie{v},'.mat'')'])
%         if v==1
%             Epoch=intervalSet(brst_all_freq_nonoise.t_start*1e4,brst_all_freq_nonoise.t_end*1e4);
%         else
%         Epoch_int=intervalSet(brst_all_freq_nonoise.t_start*1e4,brst_all_freq_nonoise.t_end*1e4);
%         Epoch=OR(Epoch_int,Epoch);
%         Epoch = mergeCloseIntervals(Epoch, 0.01*1e4);
%         end
% end
% begin=Start(Epoch);
% halt=Stop(Epoch);
% Epochbeg=intervalSet(max(begin-2.5e4,0),halt);
% Epochhalt=intervalSet(begin,halt+2.5e4);
% Epochbeg=mergeCloseIntervals(Epochbeg, 0.01*1e4);
% Epochhalt=mergeCloseIntervals(Epochhalt, 0.01*1e4);
% Epoch=OR(Epochbeg,Epochhalt);
       
% FindSpindlesKarim(LFP)



