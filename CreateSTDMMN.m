%CreateSTDMMN


try
    numSession;
    filename=['behavResources',num2str(numSession)];
catch
    numSession=[]; 
    filename='behavResources';
end


ShortStim=1;




    try
   eval(['load ',filename]) 
        evt';

    catch

        SetCurrentSession


        evt=GetEvents('output','Descriptions');

        for i=1:length(evt)
            tpsEvt{i}=GetEvents(evt{i});
        end
                    try
                        stim=GetEvents('0')*1E4;
                        stim=tsd(stim,stim);
                    catch
                        stim=[];
                    end

        try
            eval(['save ',filename,' -Append evt tpsEvt stim'])  
        catch
            eval(['save ',filename,' evt tpsEvt stim'])  
        end


    end




try 
    tp1;
catch
    
         try


                if evt{1}=='49'
                tp1=tpsEvt{1};
                good1=1;
                elseif evt{2}=='49'
                tp1=tpsEvt{2};
                good1=2;
                elseif evt{3}=='49'
                tp1=tpsEvt{3};
                good1=3;
                end

                ts1=ts(tp1*1E4);
                eval(['save ',filename,' -Append evt tpsEvt stim tp1 ts1 good1'])
                %                 save behavResources evt tpsEvt stim tp1 ts1 good1
                catch

                tp1=[];
                ts1=[];
                good1=[];
                eval(['save ',filename,' -Append evt tpsEvt stim tp1 ts1 good1'])
                %                 save behavResources evt tpsEvt stim tp1 ts1 good1
                end


                try
                if evt{1}=='50'
                tp2=tpsEvt{1};
                good2=1;
                elseif evt{2}=='50'
                tp2=tpsEvt{2};
                good2=2;
                elseif evt{3}=='50'
                tp2=tpsEvt{3};
                good2=3;
                end



                ts2=ts(tp2*1E4);
                eval(['save ',filename,' -Append evt tpsEvt stim tp2 ts2 good2'])
                % save behavResources -Append evt tpsEvt stim tp2 ts2 good2
                catch

                tp2=[];
                ts2=[];
                good2=[];
                eval(['save ',filename,' -Append evt tpsEvt stim tp2 ts2 good2'])
                % save behavResources evt tpsEvt stim tp2 ts2 good2
                end





                try

                if evt{1}=='66'
                tpB=tpsEvt{1};
                elseif evt{2}=='66'
                tpB=tpsEvt{2};
                elseif evt{3}=='66'
                tpB=tpsEvt{3};
                elseif evt{4}=='66'
                tpB=tpsEvt{4};
                end

                tsB=ts(tpB*1E4);
                eval(['save ',filename,' -Append tpB tsB'])                
                %                 save behavResources -Append tpB tsB    

                end

                try

                if evt{1}=='82'
                tpR=tpsEvt{1};
                elseif evt{2}=='82'
                tpR=tpsEvt{2};
                elseif evt{3}=='82'
                tpR=tpsEvt{3};
                elseif evt{4}=='82'
                tpR=tpsEvt{4};
                end

                tsR=ts(tpR*1E4);

                eval(['save ',filename,' -Append tpB tsB'])                

                end


end


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------




if length(numSession)==0
    
    
    
    
    id=diff(tp1);
    stim1=tp1(id>0.5);

    id2=diff(tp2);
    stim2=tp2(id2>0.5);
    
    tstim1=ts(stim1*1E4);
    tstim2=ts(stim2*1E4);   
    
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

    
    a=1;
    b=1;
   for i=1:length(evt)
    
        if evt{i}(1)=='b' 
            tpsManipeDeb{a}=tpsEvt{i};
            a=a+1;
        end
        if evt{i}(1)=='e'
            tpsManipeFin{b}=tpsEvt{i};
            b=b+1;
        end
        
        
   end
   
    
    
    c=1;
    for i=1:length(evt)
    
    
        if length(evt{i})>40&evt{i}(1)=='b'

            if evt{i}(41)~='-'
            nameManipe{c}=evt{i}(39:41);
            else
            nameManipe{c}=[evt{i}(39:40),'s'];
            end
        
            EpochManipe{c}=intervalSet(tpsManipeDeb{c}*1E4,tpsManipeFin{c}*1E4);
            
            c=c+1;
            
            
%             filenameStim=['Newstim'];
%             eval(['save ',filenameStim,' sda MMN']) 

        end
    
    end
    
 
  
    
    
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

    iX=[];
    iXyX=[];
    iXXy=[];
    iY=[];
    iYYx=[]; 
    iYxY=[]; 
    
    iX=1;
    iXyX=1;
    iXXy=1;
    iY=1;
    iYYx=1; 
    iYxY=1; 
    
%     
       for i=1:length(nameManipe)
%         
%      for i=13:length(nameManipe)
%      for i=1:12
        
        if nameManipe{i}=='XXs'
            
            disp(' ')      
            disp('XXs')
            disp(' ')
            
                id=diff(tp1);
                stim1=tp1(id>0.5);

                id2=diff(tp2);
                stim2=tp2(id2>0.5);

                tstim1=ts(stim1*1E4);
                tstim2=ts(stim2*1E4);   


            temp1=ts(stim1*1E4);
            Ctrl{i}=Restrict(temp1,EpochManipe{i});
            CtrlX{iX}=Restrict(temp1,EpochManipe{i});
            iX=iX+1;
            clear temp1
            
        elseif nameManipe{i}=='XXy'
            
  
            disp(' ')
            disp('XXy ')
            disp(' ')      

                id=diff(tp1);
                stim1=tp1(id>0.5);

                id2=diff(tp2);
                stim2=tp2(id2>0.5);

                tstim1=ts(stim1*1E4);
                tstim2=ts(stim2*1E4);   
                
                
                
            Idx=[];
            for j=1:length(stim2)

              Badsda=stim2(j)-stim1;
              idx=find(Badsda>0&Badsda<0.4);
              Idx=[Idx,idx]; 

            end

            stim1b=stim1;
            stim1b(Idx)=[];

            Iddx=[];
            for k=1:length(stim1b)
            BE=stim1b(k)-tp1(tp1<stim1b(k));
            if min(BE)>0.4 
            Iddx=[Iddx,k]; 
            end
            end

            stim1b(Iddx)=[];

            stim1=stim1b;
            
            temp1=ts(stim1*1E4);
            temp2=ts(stim2*1E4);            
            Ctrl{i}=Restrict(temp1,EpochManipe{i});
            CtrlXXy{iXXy}=Restrict(temp1,EpochManipe{i});           
            Dev{i}=Restrict(temp2,EpochManipe{i});
            DevXXy{iXXy}=Restrict(temp2,EpochManipe{i}); 
            iXXy=iXXy+1; 
            localSTD{i}=Restrict(temp1,EpochManipe{i});   
            localDEV{i}=Restrict(temp2,EpochManipe{i});   
            globalSTD{i}=Restrict(temp1,EpochManipe{i});   
            globalDEV{i}=Restrict(temp2,EpochManipe{i});  
            
            clear temp1
            clear temp2
            
        elseif nameManipe{i}=='XyX'
            

            disp(' ')
            disp('XyX ')
            disp(' ')      

                id=diff(tp1);
                stim1=tp1(id>0.5);

                id2=diff(tp2);
                stim2=tp2(id2>0.5);

                tstim1=ts(stim1*1E4);
                tstim2=ts(stim2*1E4);   
                
                
            Idx=[];
            for j=1:length(stim2)

              Badsda=stim2(j)-stim1;
              idx=find(Badsda>0&Badsda<0.4);
              Idx=[Idx,idx]; 

            end

            stim1b=stim1;
            stim1b(Idx)=[];

            Iddx=[];
            for k=1:length(stim1b)
            BE=stim1b(k)-tp1(tp1<stim1b(k));
            if min(BE)>0.4 
            Iddx=[Iddx,k]; 
            end
            end

            stim1b(Iddx)=[];

            stim1=stim1b;
            
            temp1=ts(stim1*1E4);
            temp2=ts(stim2*1E4);
            
            Ctrl{i}=Restrict(temp1,EpochManipe{i});   
            CtrlXyX{iXyX}=Restrict(temp1,EpochManipe{i});   
            Dev{i}=Restrict(temp2,EpochManipe{i});
            DevXyX{iXyX}=Restrict(temp2,EpochManipe{i});             
            iXyX=iXyX+1;
            localSTD{i}=Restrict(temp1,EpochManipe{i});   
            localDEV{i}=Restrict(temp2,EpochManipe{i});   
            globalSTD{i}=Restrict(temp2,EpochManipe{i});   
            globalDEV{i}=Restrict(temp1,EpochManipe{i});   
            
            clear temp1
            clear temp2
            
        elseif nameManipe{i}=='YYs'
            
            disp(' ')      
            disp('YYs')
            disp(' ')
 
            
            
            
                id=diff(tp1);
                stim1=tp1(id>0.5);

                id2=diff(tp2);
                stim2=tp2(id2>0.5);

                tstim1=ts(stim1*1E4);
                tstim2=ts(stim2*1E4);   
                
                
            temp2=ts(stim2*1E4);
            Ctrl{i}=Restrict(temp2,EpochManipe{i});
            CtrlY{iY}=Restrict(temp2,EpochManipe{i});
            iY=iY+1;
            
            
            clear temp2
            
        elseif nameManipe{i}=='YYx'
            
            
            disp(' ')
            disp('YYx')
            disp(' ')      

                id=diff(tp1);
                stim1=tp1(id>0.5);

                id2=diff(tp2);
                stim2=tp2(id2>0.5);

                tstim1=ts(stim1*1E4);
                tstim2=ts(stim2*1E4);   
                
                
            Idx=[];
            for j=1:length(stim1)

              Badsda=stim1(j)-stim2;
              idx=find(Badsda>0&Badsda<0.4);
              Idx=[Idx,idx]; 

            end

            stim2b=stim2;
            stim2b(Idx)=[];

            Iddx=[];
            for k=1:length(stim2b)
            BE=stim2b(k)-tp2(tp2<stim2b(k));
            if min(BE)>0.4 
            Iddx=[Iddx,k]; 
            end
            end

            stim2b(Iddx)=[];

            stim2=stim2b;
            
            temp1=ts(stim1*1E4);            
            temp2=ts(stim2*1E4);
            
            Ctrl{i}=Restrict(temp2,EpochManipe{i});   
            CtrlYYx{iYYx}=Restrict(temp2,EpochManipe{i});   
            Dev{i}=Restrict(temp1,EpochManipe{i});
            DevYYx{iYYx}=Restrict(temp1,EpochManipe{i});            
            iYYx=iYYx+1;
            
            localSTD{i}=Restrict(temp2,EpochManipe{i});   
            localDEV{i}=Restrict(temp1,EpochManipe{i});   
            globalSTD{i}=Restrict(temp2,EpochManipe{i});   
            globalDEV{i}=Restrict(temp1,EpochManipe{i});  
            
            
            clear temp1
            clear temp2
            
        elseif nameManipe{i}=='YxY'            
            
            disp(' ')
            disp('YxY')
            disp(' ')      


                id=diff(tp1);
                stim1=tp1(id>0.5);

                id2=diff(tp2);
                stim2=tp2(id2>0.5);

                tstim1=ts(stim1*1E4);
                tstim2=ts(stim2*1E4);   
                
                
            Idx=[];
            for j=1:length(stim1)

              Badsda=stim1(j)-stim2;
              idx=find(Badsda>0&Badsda<0.4);
              Idx=[Idx,idx]; 

            end

            stim2b=stim2;
            stim2b(Idx)=[];

            Iddx=[];
            for k=1:length(stim2b)
                BE=stim2b(k)-tp2(tp2<stim2b(k));
                if min(BE)>0.4 
                    Iddx=[Iddx,k]; 
                end
            end

            stim2b(Iddx)=[];

            stim2=stim2b;
            
            temp1=ts(stim1*1E4);            
            temp2=ts(stim2*1E4);
            
            Ctrl{i}=Restrict(temp2,EpochManipe{i});   
            CtrlYxY{iYxY}=Restrict(temp2,EpochManipe{i});   
            Dev{i}=Restrict(temp1,EpochManipe{i});
            DevYxY{iYxY}=Restrict(temp1,EpochManipe{i});            
            iYxY=iYxY+1;

            localSTD{i}=Restrict(temp2,EpochManipe{i});   
            localDEV{i}=Restrict(temp1,EpochManipe{i});   
            globalSTD{i}=Restrict(temp1,EpochManipe{i});   
            globalDEV{i}=Restrict(temp2,EpochManipe{i});  
            
            clear temp1
            clear temp2
            
        end
        
        
        
        
        
    end
    
    try
    Ctrl=tsdArray(Ctrl);
    CtrlX=tsdArray(CtrlX);    
    CtrlY=tsdArray(CtrlY);
    CtrlXXy=tsdArray(CtrlXXy);    
    CtrlXyX=tsdArray(CtrlXyX);
    CtrlYYx=tsdArray(CtrlYYx);
    CtrlYxY=tsdArray(CtrlYxY);   
    DevXXy=tsdArray(DevXXy);
    DevXyX=tsdArray(DevXyX);
    DevYxY=tsdArray(DevYxY);
    DevYYx=tsdArray(DevYYx);
    Slocal=tsdArray(Slocal);
    Sglobal=tsdArray(Sglobal);    
    end
    
    
        TlocalSTD=[];
        TlocalDEV=[];        
        TglobalSTD=[];    
        TglobalDEV=[];
        
    for i=1:length(localSTD)
        TlocalSTD=[TlocalSTD; Range(localSTD{i})];
        TlocalDEV=[TlocalDEV; Range(localDEV{i})];
        TglobalSTD=[TglobalSTD; Range(globalSTD{i})];
        TglobalDEV=[TglobalDEV; Range(globalDEV{i})];
    end
    
    
    
    TStdXX=[];
    TDevXX=[];
    TStdXY=[];
    TDevXY=[];
    TStdYY=[];
    TDevYY=[];
    TStdYX=[];
    TDevYX=[];
    
    
    TStdXXall=[];
    TStdXYall=[];
    TDevXXall=[];
    TDevXYall=[];

    
    
    for i=1:length(nameManipe)
      try
          
           TStdXX=[TStdXX;Range(CtrlXXy{i})];
           TDevXX=[TDevXX;Range(DevXXy{i})];
           TStdXY=[TStdXY;Range(CtrlXyX{i})];
           TDevXY=[TDevXY;Range(DevXyX{i})];
           
           TStdYY=[TStdYY;Range(CtrlYYx{i})];
           TDevYY=[TDevYY;Range(DevYxY{i})];
           TStdYX=[TStdYX;Range(CtrlYxY{i})];
           TDevYX=[TDevYX;Range(DevYxY{i})];           
           
           
           TStdXXall=[TStdXXall;Range(CtrlXXy{i});Range(CtrlYYx{i})];
           TStdXYall=[TStdXYall;Range(CtrlXyX{i});Range(CtrlYxY{i})];
           TDevXXall=[TDevXXall;Range(DevXXy{i});Range(DevYYx{i})];
           TDevXYall=[TDevXYall;Range(DevXyX{i});Range(DevYxY{i})];
           
       end
       
       
    end
    
    
    
    
    TStdXX=sort(TStdXX);
    TDevXX=sort(TDevXX);
    TStdXY=sort(TStdXY);
    TDevXY=sort(TDevXY);
    TStdYY=sort(TStdYY);
    TDevYY=sort(TDevYY);
    TStdYX=sort(TStdYX);
    TDevYX=sort(TDevYX);
    
    TStdXXall=sort(TStdXXall);
    TStdXYall=sort(TStdXYall);
    TDevXXall=sort(TDevXXall);
    TDevXYall=sort(TDevXYall);
    
        TlocalSTD=sort(TlocalSTD);
        TlocalDEV=sort(TlocalDEV);
        TglobalSTD=sort(TglobalSTD);
        TglobalDEV=sort(TglobalDEV); 
    
 filenameStim=['Newstim'];
    
 try   
 eval(['save ',filenameStim,' EpochManipe nameManipe Ctrl CtrlX CtrlY CtrlXXy CtrlXyX CtrlYYx CtrlYxY Dev DevXXy DevXyX DevYxY DevYYx localSTD localDEV globalSTD globalDEV TlocalSTD TlocalDEV TglobalSTD TglobalDEV TStdXX TStdXY TDevXX TDevXY TStdYY TStdYX TDevYY TDevYX TStdXXall TStdXYall TDevXXall TDevXYall tstim1 tstim2 stim1 stim2'])   
 catch
 eval(['save ',filenameStim,' EpochManipe nameManipe Ctrl CtrlX CtrlXXy CtrlXyX Dev DevXXy DevXyX localSTD localDEV globalSTD globalDEV TlocalSTD TlocalDEV TglobalSTD TglobalDEV TStdXX TStdXY TDevXX TDevXY tstim1 tstim2 stim1 stim2'])       
 end
  
     
     
     try
     for i=1:length(LFP)
            [a,b,c] = mETAverage(TlocalSTD,Range(LFP{i}),Data(LFP{i}),1,2000);
            [a2,b2,c2] = mETAverage(TlocalDEV,Range(LFP{i}),Data(LFP{i}),1,2000);
            figure('color',[1 1 1])
            subplot(2,1,1), plot(c,a)
            hold on, plot(c2,a2,'r')
            yl=ylim;
            hold on, line([0 0],yl,'color','k')
            title(num2str(i))
            [a,b,c] = mETAverage(TglobalSTD,Range(LFP{i}),Data(LFP{i}),1,2000);
            [a2,b2,c2] = mETAverage(TglobalDEV,Range(LFP{i}),Data(LFP{i}),1,2000);
            subplot(2,1,2), plot(c,a)
            hold on, plot(c2,a2,'r')
            yl=ylim;
            hold on, line([0 0],yl,'color','k')
     end
     end
     
     
     



    
else

%--------------------------------------------------------------------------    
%%   ----------------------------------------------------------------------
%--------------------------------------------------------------------------    
    
    
    
disp('pb')


        sda=Range(sda,'s');
        MMN=Range(MMN,'s');

        clear sda2
        clear MMN2

        if length(tp1)>length(tp2)

            disp(' ')
            disp('XXy ')
            disp(' ')      


            Idx=[];
            for i=1:length(MMN)

              Badsda=MMN(i)-sda;
              idx=find(Badsda>0&Badsda<0.4);
              Idx=[Idx,idx]; 

            end

            sda2=sda;
            sda2(Idx)=[];

            Iddx=[];
            for i=1:length(sda2)
            BE=sda2(i)-tp1(tp1<sda2(i));
            if min(BE)>0.4 
            Iddx=[Iddx,i]; 
            end
            end

            sda2(Iddx)=[];

            sda=sda2;


        else

            disp(' ')
            disp('YYx ')
            disp(' ')        


            Idx=[];
        for i=1:length(sda)

          BadMMN=sda(i)-MMN;

          idx=find(BadMMN>0&BadMMN<0.5);
          Idx=[Idx,idx]; 

        end

        MMN2=MMN;
        MMN2(Idx)=[];

        Iddx=[];
        for i=1:length(MMN2)
        BE=MMN2(i)-tp2(tp2<MMN2(i));
        if min(BE)>0.4 
        Iddx=[Iddx,i]; 
        end
        end

        MMN2(Iddx)=[];

        MMN=MMN2;

        end



        filenameStim=['Newstim',num2str(numSession)];
        eval(['save ',filenameStim,' sda MMN']) 

end

