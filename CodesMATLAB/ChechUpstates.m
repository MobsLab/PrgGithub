function cont=ChechUpstates(nom)
% function ParcoursNewCaracMitral(nomgenotype)



    le=length(nom);
    nomL=nom(1:le-4);

        
        try
            
                        eval(['load DataFinal',nomL,' cont'])
        catch
            
%         try
            
            close all
            try
                eval(['load DataVM',nomL,' dEeg dEeg2 data tps spikes DebutUp FinUp ThM VM'])
            catch
                eval(['load DataVM',nomL,' dEeg dEeg2 data tps DebutUp FinUp ThM VM'])
            end
%             eval(['load DataPlotVM',nomL,' DebutUp FinUp'])

            yy=dEeg-dEeg2;

            DebutUpb=DebutUp;
            FinUpb=FinUp;            
            

            eval(['load DataVMmaud',nomL,' DebutUp FinUp ThM'])


            
            conti='o';
            
            figure('Color',[1,1,1]), 
            set(1,'Position',[20 -300 1200 800])
            
            
            
                    
            UpStates=intervalSet(DebutUp,FinUp);
            
            DebutUpRef=DebutUp;
            FinUpRef=FinUp;
            UpStatesRef=UpStates;
            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
            
                    for i=1:length(DebutUp)
                    rectangle('Position', [DebutUp(i) boxbottom FinUp(i)-DebutUp(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
                    end
                    subplot(2,1,1), hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
                    subplot(2,1,1), hold on, plot(tps,dEeg,'r','linewidth',2)
                    ylim([boxbottom boxhight+boxbottom])
                    title('methode maud')

%------------------------------------------------------

            
            UpStatesb=intervalSet(DebutUpb,FinUpb);
            
            DebutUpRefb=DebutUpb;
            FinUpRefb=FinUpb;
            UpStatesRefb=UpStatesb;
            
            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
            

                    for i=1:length(DebutUpb)
                    subplot(2,1,2), rectangle('Position', [DebutUpb(i) boxbottom FinUpb(i)-DebutUpb(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
                    end
                    subplot(2,1,2), hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
                    subplot(2,1,2), hold on, plot(tps,dEeg,'r','linewidth',2)
                    ylim([boxbottom boxhight+boxbottom])
                    title('methode karim')


                    

            
            while conti=='o'

                    UpStates=UpStatesRef;
                    DebutUp=Start(UpStates);
                    FinUp=End(UpStates);

            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
            
            
            subplot(2,1,1), clf
                    for i=1:length(DebutUp)
                    subplot(2,1,1), rectangle('Position', [DebutUp(i) boxbottom FinUp(i)-DebutUp(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
                    end
                    subplot(2,1,1), hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
                    subplot(2,1,1), hold on, plot(tps,dEeg,'r','linewidth',2)
                    ylim([boxbottom boxhight+boxbottom])
                    title('methode maud')
                    
            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
            
        
                for i=1:length(DebutUpb)
                subplot(2,1,2), rectangle('Position', [DebutUpb(i) boxbottom FinUpb(i)-DebutUpb(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
                end
                subplot(2,1,2), hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
                subplot(2,1,2), hold on, plot(tps,dEeg,'r','linewidth',2)
                ylim([boxbottom boxhight+boxbottom]) 
                title('methode karim')

                    try
                        m;
                    catch

                    m=0.5;
                    s=0.5;
                    end
                   
                    UpStates=UpStatesRef;
                    UpStates=mergeCloseIntervals(UpStates,m);
                    UpStates=dropShortIntervals(UpStates,s);

                    DebutUp=Start(UpStates);
                    FinUp=End(UpStates);

                    
                    
                    UpStatesb=UpStatesRefb;
                    UpStatesb=mergeCloseIntervals(UpStatesb,m);
                    UpStatesb=dropShortIntervals(UpStatesb,s);

                    DebutUpb=Start(UpStatesb);
                    FinUpb=End(UpStatesb);
                    
                    
                    pause(2)
                    
            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
            
            
            subplot(2,1,1), clf
                    for i=1:length(DebutUp)
                    subplot(2,1,1), rectangle('Position', [DebutUp(i) boxbottom FinUp(i)-DebutUp(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
                    end
                    subplot(2,1,1), hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
                    subplot(2,1,1), hold on, plot(tps,dEeg,'r','linewidth',2)
                    ylim([boxbottom boxhight+boxbottom])
                    title('methode maud')
                    
            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
            
            
                for i=1:length(DebutUpb)
                subplot(2,1,2), rectangle('Position', [DebutUpb(i) boxbottom FinUpb(i)-DebutUpb(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
                end
                subplot(2,1,2), hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
                subplot(2,1,2), hold on, plot(tps,dEeg,'r','linewidth',2)
                ylim([boxbottom boxhight+boxbottom])
                title('methode karim')

                    
                    conti=input('continuer? oui: ''o'', autre non ','s');
                        if conti=='o'
                    m=input('merge close intervals (default value 0.5) ');
                    s=input('drop short intervals (default value 0.5) ');
                        end
                        
                        
                        
                        
            end



% pause(2)
%                     m=1;
% 
%                     UpStates=UpStatesRef;
%                     UpStates=mergeCloseIntervals(UpStates,m);
%                     UpStates=dropShortIntervals(UpStates,0.3);
% 
%                     DebutUp=Start(UpStates);
%                     FinUp=End(UpStates);
% 
%             
%       


methode=input('methode karim (k) ou maud (m)? ','s');
             
if methode=='k'
DebutUp=DebutUpb;
FinUp=FinUpb;
end

close 
            colorUp=[207 35 35]/255;
            colorDown=[32 215 28]/255;
            colorBox=[205 225 255]/255; %[197 246 255]/255;
            boxbottom = min(data(:,2));
            boxhight = max(data(:,2)) - boxbottom+10;
            

            figure('Color',[1,1,1]), hold on
            for i=1:length(DebutUp)
            rectangle('Position', [DebutUp(i) boxbottom FinUp(i)-DebutUp(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
            end
            hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
            hold on, plot(tps,dEeg,'r','linewidth',2)
            ylim([boxbottom boxhight+boxbottom])
            numfig=gcf;
            title(nomL)
            
            set(1,'Position',[20 -300 1200 800])
                    
                    
                    
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
            
            
            UpStates=intervalSet(DebutUp,FinUp);
            UpStates=and(UpStates,Epoch);
            DebutUp=Start(UpStates);
            FinUp=End(UpStates);
                    
                    

            cont=input('garder la cellule? (si oui: ''o'', non: ''n'') ','s');

            if cont=='o'
                cont=1;
            else
                cont=0;
            end

            
            eval(['save DataFinal',nomL,' yy cont data dEeg dEeg2 tps DebutUp FinUp tinit tfin Epoch UpStates spikes VMf'])

            eval(['save UpDown DebutUp FinUp UpStates ThM'])
        

            %--------------------------------------------------------------------------       
            %--------------------------------------------------------------------------



        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------



%         end %try 17   
        

end

