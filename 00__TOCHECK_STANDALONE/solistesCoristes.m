function [C,Cz,B,h,b,CSspkS,BSspkS,CEspkS,BEspkS,CSspkC,BSspkC,CEspkC,BEspkC,MiceNameSoliste,PathSoliste,NeuronIDSoliste,NombreNeuronsS,PathSolisteBis]=solistesCoristes(exp,ch,Ana)

limSolistes=2;
try
    exp;
catch
    exp='BASAL';
    exp='DeltaTone';
end

try
    ch;
catch
    ch=1;
end

try
    Ana;
catch
    Ana=1;
end

Dir=PathForExperimentsDeltaSleepNew(exp);
k=1;ii=1;jj=1;ok=0;
        a=1;
        
        
        for ijk=1:length(Dir.path)
%             try
                
            eval(['cd(Dir.path{',num2str(ijk),'}'')'])
            disp(pwd)
            
            

                load StateEpochSB SWSEpoch REMEpoch Wake
                load SpikeData
                [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');

                if length(NumNeurons)>5
                    clear NumNeuronsOK
                    b=1;
                    for i=1:length(NumNeurons)
                        if str2num(cellnames{NumNeurons(i)}(length(cellnames{NumNeurons(i)})))>1
                            NumNeuronsOK(b)=NumNeurons(i);
                            b=b+1;
                        end
                    end
                    
                    % Restrict Spike Analysis to Brain States : SWS, REM or Wake
                    if ch==1
                        Ssws=Restrict(S,SWSEpoch);
                    elseif ch==2
                        Ssws=Restrict(S,REMEpoch);
                    else
                        Ssws=Restrict(S,Wake);
                    end
                    
                    
                    % Solist or Corist Analysis
                    for i=1:length(NumNeuronsOK)
                        num=1:length(NumNeuronsOK);
                        num(i)=[];
                        [C(k,:),B]=CrossCorr(Range(Ssws{NumNeuronsOK(i)}),Range(poolNeurons(Ssws,NumNeuronsOK(num))),10,500);
                        C(k,:)=SmoothDec(C(k,:),0.6);
                        
                        temp=zscore(C(k,:));
                        
                        if Ana
                            load DownSpk
                            if temp(252)<limSolistes
                                ok=1;
                                [CSspkS(ii,:),BSspkS]=CrossCorr(Start(Down),Range(Ssws{NumNeuronsOK(i)}),10,100);
                                [CEspkS(ii,:),BEspkS]=CrossCorr(End(Down),Range(Ssws{NumNeuronsOK(i)}),10,100);
                                MiceNameSoliste{ii}=Dir.name{ijk};
                                PathSoliste{ii}=Dir.path{ijk};
                                PathSolisteBis{ii}=pwd;
                                NeuronIDSoliste(ii)=NumNeuronsOK(i);
                                NombreNeuronsS(ii)=length(NumNeuronsOK);
                                ii=ii+1;
                            else
                                [CSspkC(jj,:),BSspkC]=CrossCorr(Start(Down),Range(Ssws{NumNeuronsOK(i)}),10,100);
                                [CEspkC(jj,:),BEspkC]=CrossCorr(End(Down),Range(Ssws{NumNeuronsOK(i)}),10,100);
                                jj=jj+1;
                            end
                            
                            
                            
                        else
                            
                            CSspkS=[];
                            BSspkS=[];
                            CEspkS=[];
                            BEspkS=[];
                            CSspkC=[];
                            BSspkC=[];
                            CEspkC=[];
                            BEspkC=[];
                            
                        end
                        
                        k=k+1;
                    end
                    
                    MiceName{a}=Dir.name{ijk};
                    PathOK{a}=Dir.path{ijk};
                    
                    a=a+1;
                end
                
                %             end % try 58
                
        end
        
        
        if ok==0
            CSspkS=[];
            BSspkS=[];
            CEspkS=[];
            BEspkS=[];
        end
        
 Cz=zscore(C')';
 [h,b]=hist(Cz(:,252),50);
 
 
%         
% figure('color',[1 1 1]), subplot(2,1,1), imagesc(B/1E3,1:size(C,1),zscore(C')'), xlim([-0.5 0.5]), title(pwd)
% subplot(2,1,2), plot(B/1E3,zscore(C')), xlim([-0.5 0.5])     
% 
% 
% figure('color',[1 1 1]), 
% subplot(1,2,1), plot(sort(Cz(:,252)),'k')
% subplot(1,2,2), plot(b,h,'k')
% 
% figure('color',[1 1 1]), 
% subplot(2,2,1), plot(BSspkS/1E3,CSspkS./((max(CSspkS')'*ones(1,size(CSspkS,2)))),'k'), hold on, plot(BSspkS/1E3,mean(CSspkS./((max(CSspkS')'*ones(1,size(CSspkS,2))))),'r','linewidth',2),  ylim([0 1.2])
% subplot(2,2,2), plot(BEspkS/1E3,CEspkS./((max(CEspkS')'*ones(1,size(CEspkS,2)))),'k'), hold on, plot(BEspkS/1E3,mean(CEspkS./((max(CEspkS')'*ones(1,size(CEspkS,2))))),'r','linewidth',2),  ylim([0 1.2])
% subplot(2,2,3), plot(BSspkC/1E3,CSspkC./((max(CSspkC')'*ones(1,size(CSspkC,2)))),'k'), hold on, plot(BSspkC/1E3,mean(CSspkC./((max(CSspkC')'*ones(1,size(CSspkC,2))))),'r','linewidth',2),  ylim([0 1.2])
% subplot(2,2,4), plot(BEspkC/1E3,CEspkC./((max(CEspkC')'*ones(1,size(CEspkC,2)))),'k'), hold on, plot(BEspkC/1E3,mean(CEspkC./((max(CEspkC')'*ones(1,size(CEspkC,2))))),'r','linewidth',2),  ylim([0 1.2])  
% 



                