
%FigureWTKOSpectroClean

NameDir={'BASAL'};



ST1=[];
ST2=[];
ST3=[];
ST4=[];
ST5=[];
ST6=[];


ST1ko=[];
ST2ko=[];
ST3ko=[];
ST4ko=[];
ST5ko=[];
ST6ko=[];

a=1;
b=1;

  
    for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        
        for man=1:length(Dir.path)
            
            try
            disp('  ')
            
            cd(Dir.path{man})
            disp(pwd)
            load behavResources
            clear chHPC
            clear LFP
            clear f
            clear t
            clear SP
            
            res=pwd;
            
            tempchHPC=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
            chHPC=tempchHPC.channel;
            
            
            if isempty(chHPC)
            disp('No dHPC channel!!! skipping...')
            %keyboard
            
            else
                %try
            eval(['load([res,''/LFPData/LFP',num2str(chHPC),'.mat'']);'])
            eval(['load([res,''/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'']);'])
            

            
            res=pwd;
            tempLoad=load([res,'/StateEpoch.mat'],'SWSEpoch','MovEpoch','ThetaEpoch','REMEpoch','NoiseEpoch','GndNoiseEpoch');
            load behavResources PreEpoch Movtsd
            SWSEpoch=tempLoad.SWSEpoch-tempLoad.GndNoiseEpoch;
            SWSEpoch=SWSEpoch-tempLoad.NoiseEpoch;
            SWSEpoch=and(SWSEpoch,PreEpoch);
 
            REMEpoch=tempLoad.REMEpoch-tempLoad.GndNoiseEpoch;
            REMEpoch=REMEpoch-tempLoad.NoiseEpoch;
            REMEpoch=and(REMEpoch,PreEpoch);
            
            MovEpoch=tempLoad.MovEpoch-tempLoad.GndNoiseEpoch;
            MovEpoch=MovEpoch-tempLoad.NoiseEpoch;
            MovEpoch=and(MovEpoch,PreEpoch);
            
            MovTEpoch=and(MovEpoch,tempLoad.ThetaEpoch);
            MovIEpoch=MovEpoch-tempLoad.ThetaEpoch;
            
            rg=t(end)*1e4;
            TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;

            % First Way : divide into four parts
            sptsd=tsd(t*1e4,mean(Sp(:,find(f>1.5,1,'first'):find(f<5,1,'last'))')');
            sptsd=Restrict(sptsd,SWSEpoch);
            dat=Data(sptsd);
            lim(1)=percentile(dat,0.75);
            lim(2)=percentile(dat,0.55);
            lim(3)=percentile(dat,0.25);
            tempEp=thresholdIntervals(sptsd,lim(1),'Direction','Above');
            tempEp=mergeCloseIntervals(tempEp,2*1E4);
            tempEp=dropShortIntervals(tempEp,2*1E4);
        
        
            %close all
            Stsd=tsd(t*1E4,Sp);
            [Sc,Th,Epoch]=CleanSpectro(Stsd,f);
            [Sc2,Th,Epoch]=CleanSpectro(Stsd,f,8);
            
            figure(1), clf
            subplot(1,4,4),plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'k')
            hold on, plot(f,10*log10(mean(Data(Restrict(Sc,SWSEpoch)))),'b')
            plot(f,10*log10(mean(Data(Restrict(Sc2,SWSEpoch)))),'r')

            subplot(1,4,1:3), plot(Range(LFP,'s'),Data(LFP),'k')
            hold on, plot(Range(Restrict(LFP,SWSEpoch),'s'),Data(Restrict(LFP,SWSEpoch)),'r')
            hold on, plot(Range(Restrict(LFP,and(SWSEpoch,tempEp)),'s'),Data(Restrict(LFP,and(SWSEpoch,tempEp))),'g')
            hold on, plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'b')
            hold on, plot(Range(Movtsd,'s'),-4E4+1000*Data(Movtsd),'m','linewidth',2)
            set(gcf,'position',[133         554        1747         395])
            
            try
                load BadEpoch 
                BadEpoch;
                
                subplot(1,4,1:3),
                plot(Range(Restrict(LFP,BadEpoch),'s'),Data(Restrict(LFP,BadEpoch)),'color',[0.3 0.3 0.3])
                
                subplot(1,4,4),
                hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch-BadEpoch)))),'g')
                hold on, plot(f,10*log10(mean(Data(Restrict(Sc,SWSEpoch-BadEpoch)))),'c')
                hold on, plot(f,10*log10(mean(Data(Restrict(Sc2,SWSEpoch-BadEpoch)))),'m')
            end
            
          %  keyboard
            
            if 0
            
                
   
                
                clear BadEpoch1
                clear BadEpoch2
                clear BadEpoch
                clear Epoch
                
                BadEpoch1=thresholdIntervals(LFP,-2.5*1E4,'Direction','Below');
                BadEpoch2=thresholdIntervals(LFP,2.5*1E4,'Direction','Above');
                BadEpoch=or(BadEpoch1,BadEpoch2);

                BadEpoch=intervalSet(Start(BadEpoch)-2E4,End(BadEpoch)+2E4);
                BadEpoch=mergeCloseIntervals(BadEpoch,1);
                
                Epoch=intervalSet(8600*1E4,8800*1E4)
                BadEpoch=or(BadEpoch,Epoch);
                
                save BadEpoch BadEpoch
                
                subplot(1,4,4),
                hold on, plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch-BadEpoch)))),'g')
                hold on, plot(f,10*log10(mean(Data(Restrict(Sc,SWSEpoch-BadEpoch)))),'c')
                hold on, plot(f,10*log10(mean(Data(Restrict(Sc2,SWSEpoch-BadEpoch)))),'m')
      
            end
            
            
            if Dir.group{man}(1)=='W'
                
                ST1=[ST1;mean(Data(Restrict(Stsd,SWSEpoch)))];
                ST2=[ST2;mean(Data(Restrict(Sc,SWSEpoch)))];
                ST3=[ST3;mean(Data(Restrict(Sc2,SWSEpoch)))];
                try
                    BadEpoch;
                    ST4=[ST4;mean(Data(Restrict(Stsd,SWSEpoch-BadEpoch)))];
                    ST5=[ST5;mean(Data(Restrict(Sc,SWSEpoch-BadEpoch)))];
                    ST6=[ST6;mean(Data(Restrict(Sc2,SWSEpoch-BadEpoch)))];
                catch
                    
                ST4=[ST4;mean(Data(Restrict(Stsd,SWSEpoch)))];
                ST5=[ST5;mean(Data(Restrict(Sc,SWSEpoch)))];
                ST6=[ST6;mean(Data(Restrict(Sc2,SWSEpoch)))];
                end
                
                listMice{a}=Dir.path{man};
                a=a+1;
            else
                
                ST1ko=[ST1ko;mean(Data(Restrict(Stsd,SWSEpoch)))];
                ST2ko=[ST2ko;mean(Data(Restrict(Sc,SWSEpoch)))];
                ST3ko=[ST3ko;mean(Data(Restrict(Sc2,SWSEpoch)))];
                try
                    BadEpoch;
                    ST4ko=[ST4ko;mean(Data(Restrict(Stsd,SWSEpoch-BadEpoch)))];
                ST5ko=[ST5ko;mean(Data(Restrict(Sc,SWSEpoch-BadEpoch)))];
                ST6ko=[ST6ko;mean(Data(Restrict(Sc2,SWSEpoch-BadEpoch)))]; 
                catch
                ST4ko=[ST4ko;mean(Data(Restrict(Stsd,SWSEpoch)))];
                ST5ko=[ST5ko;mean(Data(Restrict(Sc,SWSEpoch)))];
                ST6ko=[ST6ko;mean(Data(Restrict(Sc2,SWSEpoch)))];       
                listMiceKO{b}=Dir.path{man};
                end
                
                b=b+1;
            end
            
            
            
                end
                
            %end
            end
        end
    end
    
 
