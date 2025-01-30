function TransformDataStep1(AouN,nom,opt)


% AouN 'Astro' ou 'Neuron'
% opt [0.5 0.1]
% example of use: TransformDataStep1('N','11n18029_7_-60_CPPOK3.abf',[0.5 0.1]);
%
%
thresholdManual=1;
shortUpLimit=0.3; %default value 0.3


disp('Starts and Ends of recording period must be in Down states!!!!')


try 
    opt;
    th=opt(1);
    shortUpLimit=opt(2);
    choiceTh=0;

catch
    choiceTh=1;
    
end


try
    opt(3);
    if (opt(3))>=1
    ParamsMaud=opt(3);
    else
       ParamsMaud=10000; 
    end
    
catch
    ParamsMaud=10000;
end



    
    
try 
    nom;
catch
    
    temp=dir;
    for i=1:length(temp)
        temp2=temp(i).name;
        le=length(temp2);
        if length(temp2)>4&temp2(le-2:le)=='abf'
        nom=temp2;
        end
    end
end


le=length(nom);
nomL=nom(1:le-4);

try
    load Data
    data;
    
catch
    
    
    eval(['data=abfloadKB(''',nom,''');'])

    nbtraces=size(data,2)-1;
    freq=1/median(diff(data(:,1)));
    figure('color',[1 1 1]), hold on
        plot(data(:,1),data(:,2))
        try
        plot(data(:,1),data(:,3),'r')
        end
        
        x=ginput;

            tinit=min(x(:,1));
            tfin=max(x(:,1));              
            data=data(find(data(:,1)>tinit&data(:,1)<tfin),:);
            data(:,1)=data(:,1)-data(1,1)+(data(2,1)-data(1,1));
    save Data data freq nbtraces nom
    close
end



try 
    eval(['load DataVM',nomL])

catch
    
    if AouN(1)=='N'  
            raw=tsd(data(:,1),data(:,2));
            ii=thresholdIntervals(raw,-10,'Direction','Above');
            spikes=Start(ii);
            spk=tsd(spikes,spikes);


            clear raw
            Vm=data(:,1:2);
            h = waitbar(0,'Please wait...');

            for i=1:length(spikes)
                ix(i)=find(data(:,1)==spikes(i));

		if ix(i)+100<length(data)&ix(i)-50>1
		    Vm(ix(i)-50:ix(i)+100,:)=RemoveSpike(data(ix(i)-50:ix(i)+100,:));
		else if ix(i)+100<length(data)&ix(i)-50<1
		    Vm(1:ix(i)+100,:)=RemoveSpike(data(1:ix(i)+100,:));
		else if ix(i)+100>length(data)
		    Vm(ix(i)-50:end,:)=RemoveSpike(data(ix(i)-50:end,:));

		end
	    end

     end

        %     if ix(i)+250<length(data)
        %         Vm(ix(i)-100:ix(i)+250,:)=RemoveSpike(data(ix(i)-100:ix(i)+250,:));
        %     else
        %         Vm(ix(i)-100:end,:)=RemoveSpike(data(ix(i)-100:end,:));
        %     end


                waitbar(i/length(spikes),h)

            end

            close(h)
    
    
    else
        
    ii=[];
    spikes=[];
    spk=[];
    Vm=data(:,1:2);
    
    end
    
    

    % tps=data(1:10:end,1);
    temp=[Vm(1,2)*ones(500000,1); Vm(:,2); Vm(end,2)*ones(500000,1)];
    VM=resample(temp,1,100);
    VM=VM(5001:end-5000);
    
    tps=data(1:100:end,1);

    [b,a]=butterlow1(2/100);
    dEeg = filtfilt(b,a,[VM(1)*ones(5000,1); VM; VM(end)*ones(5000,1)]);

                %pour virer la baseline
                %filtre passe bas (0,005Hz)
                if tps(end)>500
                    if tps(end)>800
                        [b,a]=butterlow1(0.005/100);
                    else
                [b,a]=butterlow1(0.05/100);
                    end
                else if tps(end)>100&tps(end)<500
                        [b,a]=butterlow1(0.5/100);
                    else
                        [b,a]=butterlow1(1/100);
                    end
                end

                dEeg2 = filtfilt(b,a,dEeg);
                %valeurs filtrées: dEeg

                %échelle de temps recalculée


dEeg=dEeg(5001:end-5000);
dEeg2=dEeg2(5001:end-5000);

eval(['save DataVM',nomL,' VM Vm data tps spikes dEeg2 dEeg'])

end



% limite=5000;
% tps=tps(limite:end-limite);
% yy=dEeg(limite:end-limite)-dEeg2(limite:end-limite);

yy=dEeg-dEeg2;
Epoch=intervalSet(tps(1), tps(end));


% try
%     tinit;
%     tps=tps(tps>tinit&tps>tfin);
%     yy=yy(tps>tinit&yy>tfin);
%     spikes=spikes(spikes>tinit&spikes>tfin);
%     Epoch=intervalSet(tinit, tfin);
% end

% l=0;
% l=l+1;labels{l}='nbspk/temps';
% l=l+1;labels{l}='maxAuto';
% l=l+1;labels{l}='maxAutoShort';
% l=l+1;labels{l}='Skew';
% l=l+1;labels{l}='Kurto';
% l=l+1;labels{l}='Indice';
% l=l+1;labels{l}='PBimod';
% l=l+1;labels{l}='PUnimod';
% l=l+1;labels{l}='Delai';
% l=l+1;labels{l}='nbspkUp/DureeUpTotal';
% l=l+1;labels{l}='(nbspk-nbspkUp)/DureeDownTotal';
% l=l+1;labels{l}='nbupStates/temps';
% l=l+1;labels{l}='DureeUp';
% l=l+1;labels{l}='DureeDown';
% l=l+1;labels{l}='amplUp';
% l=l+1;labels{l}='DureeUpTotal';
% l=l+1;labels{l}='DureeDownTotal';
% l=l+1;labels{l}='percS';
% l=l+1;labels{l}='percE';
% l=l+1;labels{l}='MembPot';
% l=l+1;labels{l}='PotUp';
% l=l+1;labels{l}='PotDown';
% l=l+1;labels{l}='AmpSpk';
% l=l+1;labels{l}='AhpSpk';

    if AouN(1)=='N'  
   
        

if thresholdManual
    try
        ThM;
    
        if ThM<0
            figure, hist(yy,100)

            x=ginput;
            ThM=x(1);
        end
        figure, hist(yy,100)

            x=ginput;
            ThM=x(1);
    catch
    end
    s=ones(length(yy),1);
    s(find(yy>ThM))=2;
    c(1)=mean(yy(s==1));
    c(2)=mean(yy(s==2));
else
    [c,s]=kmeans(yy,2);
    ThM=0;
end


amplUp=abs(c(1)-c(2));
MembPot=mean(VM);    
PotUp=max(c(1),c(2))+MembPot;
PotDown=min(c(1),c(2))+MembPot;
        
        
Bins=[-15:0.1:15]+mean(yy);

[h,x]=hist(yy,Bins);
[h2,x2]=hist(yy(s==2),Bins);
[h1,x1]=hist(yy(s==1),Bins);


    
if choiceTh==1
if min(x2(h2>0))>min(x1(h1>0))
th=min(x2(h2>0));
else
    try
        th;
    catch
th=min(x1(h1>0));
    end
end

end


bi = burstinfo(tps(find(yy>th)), 0.1, tps(end));

DebutUp=bi.t_start;
FinUp=bi.t_end;

ide=find(FinUp-DebutUp<shortUpLimit);

Upav=length(DebutUp);
DebutUp(ide)=[];
FinUp(ide)=[];
Upap=length(DebutUp);

shortUpStates=Upav-Upap;

UpStates=intervalSet(DebutUp,FinUp);

eval(['save DataVM',nomL,' -Append DebutUp FinUp ThM'])

    

try 
    eval(['load DataVMmaud',nomL,' f dw spikes spk'])
    
catch
    
    %data=abfloadKB(nom);

    figure('Color',[1 1 1])
    numfig=gcf;
%     set(numfig,'Position',[45 66 938 749])
    
    subplot(3,4,[9:12])
    [dat, f, dw] = plotMaudsFromData(data(:,2), ParamsMaud, 1, 0, data(1,1), data(end-1,1), data(1,1), 1, 0);
    close
    raw=tsd(data(:,1),data(:,2));
    ii=thresholdIntervals(raw,-10,'Direction','Above');
    spikes=Start(ii);
    spk=tsd(spikes,spikes);

    ploti=1;

eval(['save DataVMmaud',nomL,' data dat f dw spikes spk'])

end


DebutUp=dw(:,2)/1E4;
FinUp=dw(:,1)/1E4;

if FinUp(1)<DebutUp(1)
    
    FinUp=FinUp(2:end);
    DebutUp=DebutUp(1:end-1);
    
end

ide=find(FinUp-DebutUp<0.3);

Upav=length(DebutUp);
DebutUp(ide)=[];
FinUp(ide)=[];
Upap=length(DebutUp);

eval(['save DataVMmaud',nomL,' -Append DebutUp FinUp ThM'])



    
    
    
try
    eval(['load DataFinal',nomL,' tinit tfin tps'])
    tinit;
catch
 
cont=ChechUpstates(nom);

end



    else
        
        
        figure('color',[1 1 1]), hold on
        plot(data(:,1),data(:,2))
        try
        plot(data(:,1),data(:,3),'r')
        end
        
        x=ginput;

            tinit=min(x(:,1));
            tfin=max(x(:,1));              
           

            data=data(find(data(:,1)>tinit&data(:,1)<tfin),:);
            yy=yy(tps>tinit&tps<tfin);
            try
            spikes=spikes(spikes>tinit&spikes<tfin);
            end
            Epoch=intervalSet(tinit, tfin);
            dEeg=dEeg(tps>tinit&tps<tfin);    
            dEeg2=dEeg2(tps>tinit&tps<tfin);
            VMf=VM(tps>tinit&tps<tfin);
            tps=tps(tps>tinit&tps<tfin);
            
        
            cont=input('garder les signaux? (si oui: ''o'', non: ''n'') ','s');
            eval(['save DataFinal',nomL,' yy cont data dEeg dEeg2 tps tinit tfin VMf'])            
                    
                    
                    
    end
    

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



try
    
    eval(['load DataLFP',nomL,' LFP'])
    LFP;

    
catch
    
    try

        eval(['load DataFinal',nomL,' data tps'])
        lfp=data(:,3);

        % --------------------------------------------------------------------
        temp=[lfp(1)*ones(500000,1); lfp(:); lfp(end)*ones(500000,1)];
        LFP=resample(temp,1,100);
        LFP=LFP(5001:end-5000);
        tps=data(1:100:end,1);
        [b,a]=butterlow1(2/100);
            LFPf = filtfilt(b,a,[LFP(1)*ones(5000,1); LFP; LFP(end)*ones(5000,1)]);
                        %pour virer la baseline
                        %filtre passe bas (0,005Hz)
                        if tps(end)>500
                        [b,a]=butterlow1(0.05/100);
                        else if tps(end)>100&tps(end)<500
                                [b,a]=butterlow1(0.5/100);
                            else
                                [b,a]=butterlow1(1/100);
                            end
                        end
                        LFPf2 = filtfilt(b,a,LFPf);
                        %valeurs filtrÈes: dEeg
                        %Èchelle de temps recalculÈe
        LFPf=LFPf(5001:end-5000);
        LFPf2=LFPf2(5001:end-5000);
        

%         [b,a]=butterlow1(2/100);
%             LFPf = filtfilt(b,a,[LFP(1)*ones(5000,1); LFP; LFP(end)*ones(5000,1)]);
%                         %pour virer la baseline
%                         %filtre passe bas (0,005Hz)
%                         if tps(end)>500
%                         [b,a]=butterlow1(0.05/100);
%                         else if tps(end)>100&tps(end)<500
%                                 [b,a]=butterlow1(0.5/100);
%                             else
%                                 [b,a]=butterlow1(1/100);
%                             end
%                         end
%                         LFPf2 = filtfilt(b,a,LFPf);
%                         %valeurs filtrÈes: dEeg
%                         %Èchelle de temps recalculÈe
%         LFPf=LFPf(5001:end-5000);
%         LFPf2=LFPf2(5001:end-5000);

%         eval(['load DataVM',nomL,' tps'])

        eval(['save DataLFP',nomL,' LFP lfp LFPf LFPf2 tps'])


    end
    
end
    

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



try
    eval(['load DataLFPfinal',nomL,' final'])
    final;
    
catch
    try
    eval(['load DataFinal',nomL,' tinit tfin'])   
    eval(['load DataLFP',nomL,' LFP lfp LFPf LFPf2 tps'])
    
    LFP=LFP(tps>tinit&tps<tfin);
    LFPf=LFPf(tps>tinit&tps<tfin);
    LFPf2=LFPf2(tps>tinit&tps<tfin);
    tps=tps(tps>tinit&tps<tfin);
    final=1;

    eval(['save DataLFPfinal',nomL,' LFP lfp LFPf LFPf2 tinit tfin final tps'])
    end

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



% keyboard

eval(['load DataVM',nomL,' spikes'])
spikes2=spikes(spikes>tinit&spikes<tfin);
save Spikes spikes spikes2


try
    load DataMCLFP tps Y Y2 cont
    Y;
    Y2;
catch

%         try

                eval(['load DataFinal',nomL,' dEeg2 dEeg tps VMf cont'])
                
                Y=dEeg;
                Y2=dEeg2;
                tpsRef=tps;
                Ytsd=tsd(tps,Y);
                Y2tsd=tsd(tps,Y2);

                
                try
                eval(['load DataLFPfinal',nomL,' LFPf LFPf2'])
                end

                

                try
                F=LFPf;
                F2=LFPf2;
                end

                % keyboard
                
                try
                try    
                    eval(['load Datafinal',nomL,' tps VMf'])
                    VMftsd=tsd(tps,VMf);
                catch
                    eval(['load DataLFPfinal',nomL,' tps VMf'])                
                    VMftsd=tsd(tps,VMf);
                end
                
                
                eval(['load DataLFPfinal',nomL,' tps'])
                Ftsd=tsd(tps,F);
                F2tsd=tsd(tps,F2);
                
                
                Ftsd=Restrict(Ftsd,Ytsd);
                F2tsd=Restrict(F2tsd,Ytsd);
                VMftsd=Restrict(VMftsd,Ytsd);
                F=Data(Ftsd);
                F2=Data(F2tsd);
                VMf=Data(VMftsd);
                eval(['load DataFinal',nomL,' tps']) 
                
                %tps=tpsRef;
                 end
                
                % keyboard



                clear fac1
                clear fac2

                figure('Color',[1 1 1]), hold on
                num=gcf;

                conto=1;

                while conto==1

                            figure(num),clf
                            subplot(4,1,1), hold on
                            %keyboard
                            plot(tps,VMf-VMf(1),'k')
                            plot(tps,Y-Y(1))
                            xlim([tps(1),tps(end)])

                            subplot(4,1,2),hold on
                            plot(tps,VMf-VMf(1),'k')
                            plot(tps,Y2-Y2(1))
                            xlim([tps(1),tps(end)])

                            try
                            F;
                            subplot(4,1,3),hold on
                            plot(tps,LFP(1:length(tps))-LFP(1),'k')
                            plot(tps,F-F(1))
                            xlim([tps(1),tps(end)])            

                            subplot(4,1,4),hold on
                            plot(tps,LFP(1:length(tps))-LFP(1),'k')
                            plot(tps,F2-F2(1))
                            xlim([tps(1),tps(end)])
                             end

                            try
                                fac1;
                                fac2;
                            catch
                            fac1=100;
                            fac2=10;
                            end

                            chF=1/median(diff(tps));
                            try
                            Yf=locdetrend(Y,chF,[fac1,fac2]);

                            catch

                                fac1=10
                                fac2=1
                                Yf=locdetrend(Y,chF,[fac1,fac2]);
                            end



                            Y2f=locdetrend(Y2,chF,[fac1,fac2]);
                            try
                                Ff=locdetrend(F,chF,[fac1,fac2]);
                                F2f=locdetrend(F2,chF,[fac1,fac2]);
                            end



                            subplot(4,1,1),hold on
                            plot(tps,Yf-Yf(1),'r')
                            xlim([tps(1),tps(end)])


                            subplot(4,1,2), hold on
                            plot(tps,Y2f-Y2f(1),'r')
                            xlim([tps(1),tps(end)])           


                            try
                             F;
                             subplot(4,1,3),hold on   
                             plot(tps,Ff-Ff(1),'r')
                             xlim([tps(1),tps(end)])

                             subplot(4,1,4),hold on               
                             plot(tps,F2f-F2f(1),'r')
                             xlim([tps(1),tps(end)])

                            end


                                        conti=input('continuer de modifier la baseline? (si oui: ''o'', non: ''n'') ','s');


                                        if conti=='o'
                                            fac1=input('parametre 1 (default 100) : ');
                                            fac2=input('parametre 2 (default 10) : '); 
                                            conto=1;
                                        else
                                            conto=0;
                                        end



                end

                Y=Yf;
                Y2=Y2f;
                try
                F=Ff;
                F2=F2f;
                end

                X=VMf;

                % tpsRef=tps;
                % 
                % 
                % Ytsd=tsd(tps,Y);
                % Y2tsd=tsd(tps,Y2);
                % 
                % 
                % 
                % eval(['load DataLFPfinal',nomL,' tps'])
                % Ftsd=tsd(tps,F);
                % F2tsd=tsd(tps,F2);
                % 
                % Ftsd=Restrict(Fstd,Ytsd);
                % F2tsd=Restrict(F2std,Ytsd);
                % F=Data(Ftsd);
                % F2=Data(F2tsd);
                % tps=tpsRef;

                chF=1/median(diff(tps));

                try
                    F;
                    save DataMCLFP tps Y Y2 F F2 X chF cont
                    
                    if AouN(1)=='N'  
                    save UpDown -Append ThM cont
                    end
                catch
                    chF=1/median(diff(tps));
                    save DataMCLFP tps Y Y2 X chF cont
                    
                    if AouN(1)=='N'  
                    save UpDown -Append ThM cont    
                    end
                    
                end

%         catch
%                     X=VMf;
%                     chF=1/median(diff(tps));
%                     save DataMCLFP tps Y Y2 X chF cont
%                     save UpDown -Append cont
%         end



    
end


