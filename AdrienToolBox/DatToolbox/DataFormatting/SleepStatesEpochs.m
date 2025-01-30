function SleepStatesEpochs(fbasename)

    load([fbasename filesep 'BehavEpochs.mat'])
    fname = [fbasename filesep];
    matFName = [fbasename filesep 'SleepStates'];

    Fs = 1250;

    done = 0;
    acqSyst = LoadPar([fname fbasename '.xml']);
    epochs = {'sleepPreEp';'sleepPostEp'};

    params.Fs = Fs;
    freqRange = [0 45];
    params.tapers = [3 5];
    window = 1;

    epREMall = [];
    epSWSall = [];
    chanIx = zeros(length(epochs),1);
    thresREM = zeros(length(epochs),1);
    thresSWS = zeros(length(epochs),1);
    
    gw = gausswin(10);

    for ii=1:length(epochs)
            eval(['ep = ' epochs{ii} ';']);

            if ~isempty(ep)
               start = (ep(1)-1)/Fs;
               duration = (ep(2)-ep(1))/Fs;
               doneLFP=0;
               if ii>1
                   chan=chanIx(ii-1);
               else
                   chan=1;
               end
               while ~doneLFP
                   if ii==1 || chan==0
                        chan = inputdlg('Which LFP Channel?:');
                        chan = str2num(chan{1});
                   end

                   disp(['Loading LFP channel #' num2str(chan)])

                   lfp = LoadBinary([fname fbasename '.eeg'],'nChannels',str2num(acqSyst.nChannels),'channels',chan,'frequency',Fs,'start',start,'duration',duration);
                   lfp = lfp-mean(lfp);

                   fprintf('computing spectrograms, may take time ... \n');

                   specWindow = 2^round(log2(window*Fs));% choose window length as power of two
                   nFFT = specWindow*4;
                   weeg = WhitenSignal(lfp,Fs*2000,1);
                   [S,f,t] = mtcsglong(weeg,nFFT,Fs,specWindow,[],2,'linear',[],freqRange);

                   Ss = convn(S,gw,'same');
                   deltaPow = mean(Ss(:,f<5),2);
                   thetaPow = mean(Ss(:,f>6 & f<9),2);

                   gamPow = mean(Ss(:,f>25),2);

                   figure(1),clf
                       imagesc(t,f,log10(Ss')),axis xy
                       hold on
                    button = input('Is LFP OK? [Y(default)/N]','s');
                    if strcmp(button,'N')
                       chan=0;
                    else
                       doneLFP = 1;
                       chanIx(ii)=chan;                        
                    end
               end

               fprintf('First REM epochs ... \n');          
               doneREM = 0;
               epREM = [];
               while ~doneREM
               %if 0
                   ratioTD = log10(thetaPow) - log10(deltaPow);
                   ratioTD = (ratioTD-min(ratioTD))/(max(ratioTD)-min(ratioTD));

                   hold on
                   plot(t,30*ratioTD,'Color','w','LineWidth',2);

                   fprintf('Select a threshold \n')
                   gg = ginput(1);
                   th = gg(1,2)/30;

                   %Here, call the @TSDToolbox objects...
                   ep = thresholdIntervals(tsd(t,ratioTD),th); %Hre we don't care about the time units
                   ep = mergeCloseIntervals(ep,10); %Merge anything closer than 10s
                   ep = dropShortIntervals(ep,20); %Drop anything shorter than 20s

                   st = Start(ep);
                   en = End(ep);
                   if isempty(st)
                       button = questdlg('No REM episodes! Continue (yes), Restart REM detection (No/Cancel)');
                       if strcmp(button,'Yes')
                           doneREM = 1;
                       end
                   else
                        sbp = [];
                        figure(1),clf
                        sbp(1)=subplot(2,1,1);
                            imagesc(t,f,log10(Ss')),axis xy                     
                            hold on
                            plot(t,30*ratioTD,'Color','w','LineWidth',2);
                            hUp = zeros(length(st),2);
                            hUp(:,1) = line([st';st'],freqRange'*ones(1,length(st)),'Color','k','LineWidth',2);
                            hUp(:,2) = line([en';en'],freqRange'*ones(1,length(st)),'Color','r','LineWidth',2);                                 
                        sbp(2)=subplot(2,1,2);
                            imagesc(t,f,log10(Ss')),axis xy
                            hold on
                            plot(t,30*ratioTD,'Color','w','LineWidth',2);

                        button = input('Good For You? [Y/N(default)/R(restart threshold)]','s');
                        if strcmp(button,'Y')
                           epREM = [st en];
                           doneREM=1;
                        elseif strcmp(button,'R')
                            doneREM=0;
                        else
                            [newSt newEn] = SelectEpochs(ep,hUp,sbp);
                            epREM = [newSt newEn];
                            button2 = input('Good For You? [Y(default)/N]','s');
                            if ~strcmp(button2,'N')
                                doneREM=1;
                            end
                        end
                   end
                   if ~doneREM
                       fprintf('OK, let''s restart REM detection! \n')
                       figure(1),clf
                       imagesc(t,f,log10(Ss')),axis xy 
                   end
               end
               thresREM(ii) = th;
               clear ratioTD

               fprintf('\nThen SWS epochs ... \n');          
               doneSWS = 0;
               epSWS = [];
               while ~doneSWS
                   ratioDG = deltaPow./gamPow;
                   ratioDG = (ratioDG-min(ratioDG))/(max(ratioDG)-min(ratioDG));              

                   figure(1),clf
                   imagesc(t,f,log10(Ss')),axis xy
                   hold on
                   plot(t,30*ratioDG,'Color','w','LineWidth',2);

                   fprintf('Select a threshold \n')
                   gg = ginput(1);
                   th = gg(1,2)/30;

                  %Here, call the @TSDToolbox objects...
                  ep = thresholdIntervals(tsd(t,ratioDG),th); %Hre we don't care about the time units
                  ep = mergeCloseIntervals(ep,20); %Merge anything closer than 20s
                  if ~isempty(epREM)
                      ep = ep-intervalSet(epREM(:,1)-10,epREM(:,2)+10); %Exclude the REM episodes that we just detected +/-10s
                  end
                  ep = dropShortIntervals(ep,120); %Drop anything shorter than 2 min
                  
                  st = Start(ep);
                   en = End(ep);
                   if isempty(st)
                       button = questdlg('No SWS episodes! Continue (yes), Restart SWS detection (No/Cancel)');
                       if strcmp(button,'Yes')
                           doneSWS = 1;
                       end
                   else
                        sbp = [];
                        figure(1),clf
                        sbp(1)=subplot(2,1,1);
                            imagesc(t,f,log10(Ss')),axis xy                     
                            hold on
                            plot(t,30*ratioDG,'Color','w','LineWidth',2);
                            hUp = zeros(length(st),2);
                            hUp(:,1) = line([st';st'],freqRange'*ones(1,length(st)),'Color','k','LineWidth',2);
                            hUp(:,2) = line([en';en'],freqRange'*ones(1,length(st)),'Color','r','LineWidth',2);
                            line([epREM(:,1)';epREM(:,1)'],freqRange'*ones(1,size(epREM,1)),'Color',[1 1 1]/2,'LineWidth',2);
                            line([epREM(:,2)';epREM(:,2)'],freqRange'*ones(1,size(epREM,1)),'Color',[1 1 1]/2,'LineWidth',2);

                        sbp(2)=subplot(2,1,2);
                            imagesc(t,f,log10(Ss')),axis xy
                            hold on
                            plot(t,30*ratioDG,'Color','w','LineWidth',2);
                            
                        button = input('Good For You? [Y/N(default)/R(restart threshold)]','s');
                        if strcmp(button,'Y')
                           epSWS = [st en];
                           doneSWS=1;
                        elseif strcmp(button,'R')
                            doneSWS=0;
                        else
                            [newSt newEn] = SelectEpochs(ep,hUp,sbp);
                            epSWS = [newSt newEn];
                            button2 = input('Good For You? [Y(default)/N]','s');
                            if ~strcmp(button2,'N')
                                doneSWS=1;
                            end
                        end
                   end
                   if ~doneREM
                       fprintf('OK, let''s restart SWS detection! \n')
                       figure(1),clf
                       imagesc(t,f,log10(Ss')),axis xy 
                   end                   
               end
               clear ratioDG
               
               thresSWS(ii) = th;
               keyboard
               epREMall = [epREMall;epREM+start];
               epSWSall = [epSWSall;epSWS+start];          
            
            end

    end
    
    epREM = epREMall;
    epSWS = epSWSall;
    save([fname 'SleepStateEpochs'],'epochs','chanIx','epREM','epSWS','thresREM','thresSWS');
 
end

           
        
        
function [newst,newen] = SelectEpochs(ep,hUp,sbp)

st = Start(ep);
en = End(ep);
hSt = hUp(:,1);
hEn = hUp(:,2);
e=1;
ix=1;

while ix<=length(st)
    axes(sbp(2));
    set(sbp(2),'XLim',[st(ix)-35 en(ix)+35]);
    %set(gca,'XLimMode','auto');    
    h1=line([st(ix) st(ix)],[0 40],'Color','k','LineWidth',2);
    h2=line([en(ix) en(ix)],[0 40],'Color','r','LineWidth',2);
    
    axes(sbp(1))    
    set(hSt(ix),'LineStyle','--');
    set(hEn(ix),'LineStyle','--'); 
    doPlain=0;
    done=0;
    while ~done
        button = input('OK with this epoch? Yes [Y] (default) Change [C] Delete [D] Merge w/ closest [M] Expand View [E]?','s');
        if strcmp(button,'D')
            axis(sbp(1));           
            set(hSt(ix),'Visible','off');
            set(hEn(ix),'Visible','off'); 
            hSt(ix)=[];
            hEn(ix)=[];
            st(ix) = [];
            en(ix)=[];
            done=1;
        elseif strcmp(button,'M')
            if length(st)==1
                fprintf('Could not merge, there''s only one epoch!')
            else    
                axes(sbp(1));
                if ix==1
                    mergeCase=1;
                elseif ix==length(st)
                    mergeCase=2;
                else
                    [dummy,mergeCase] = min([st(ix+1)-en(ix),st(ix)-en(ix-1)]);
                end
                if mergeCase==1
                    st(ix+1) = [];
                    en(ix) = [];
                    set(hSt(ix+1),'Visible','off');
                    set(hEn(ix),'Visible','off');
                    set(h2,'Visible','off')
                    hSt(ix+1)=[];
                    hEn(ix)=[];
                    done=1;
                elseif mergeCase==2
                    en(ix-1) = [];
                    st(ix)=[];
                    set(hSt(ix),'Visible','off');
                    set(hSt(ix-1),'Visible','off');
                    set(h1,'Visible','off');
                    hSt(ix)=[];
                    hEn(ix-1)=[];
                    done=1;
                else
                    fprintf('Something went wrong...')
                end
            end

        elseif strcmp(button,'C')
            fprintf('     Select start, then end of epoch.\n')
            doneSelect=0;
            while ~doneSelect
                gg = ginput(2);
                nst = gg(1,1);
                nen = gg(2,1);
                axes(sbp(2));                
                set(h1,'XData',[nst nst]);
                set(h2,'XData',[nen nen]);
                axes(sbp(1));
                set(hSt(ix),'XData',[nst nst]);
                set(hEn(ix),'XData',[nen nen]);
                if nst>nen
                    fprintf('     Warning! start after end! Restart.\n')
                else
                    st(ix)=nst;
                    en(ix)=nen;
                    doneSelect=1;
                end
            end

            doPlain=1;
        elseif strcmp(button,'Y')            
            ix=ix+1;
            done=1;
            axes(sbp(1));   
            doPlain=1; 
        elseif strcmp(button,'E')   
            xl = get(sbp(2),'XLim');
            set(sbp(2),'XLim',[xl(1)-30 xl(2)+30])
        else
            fprintf('     Option %s not recognized.\n',button)
        end
    end
    if doPlain
        axes(sbp(1));   
        set(hSt(ix-1),'LineStyle','-');
        set(hEn(ix-1),'LineStyle','-'); 
    end
end
newst = st;
newen = en;
end

