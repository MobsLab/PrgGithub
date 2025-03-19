clear all

CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
n=1;
StrucNames={'HPC','OB','PFCx'};
order=10;
FilterFreq=[0.1 100];
FilterFreq2=[2 7];
num=1;
for k=1:3
    for kk=1:3
        Remember{k,kk}=[];
    end
end
for k=1:3
    for kk=1:3
        if kk~=k
            num=1;
            for mm=KeepFirstSessionOnly
                temp=zeros(41,1);
                AllDat2=0;
                cd(Dir.path{mm})
                clear ret EpDur
                try load('PartGrangerOBHPCPFC0.1100Hz.mat')
                    if size([ret{1,:}],2)>0
                        for st=1:size([ret{1,:}],2)
                            temp=temp+squeeze(ret{1,st}.GW(k,kk,:)).*EpDur{1,st};
                            AllDat2=AllDat2+ret2{1,st}.fg(k,kk).*EpDur{1,st};
                        end
                        temp=temp./sum([EpDur{1,:}]);
                        FreqGranger{k,kk}(num,:)=temp;
                        PartGranger{k,kk}(num)=AllDat2./sum([EpDur{1,:}]);
                        Mouse{num}=Dir.path{mm};
                        num=num+1;
                    end
                    
                end
            end
        end
    end
end

figure;
AllCombi=combnk([1,2,3],2);
Cols2=[0,146,146;189,109,255]/263;
freqBin=[0:0.5:20];
for k=1:length(AllCombi)
    subplot(3,2,(k-1)*2+1)
    patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.8,'EdgeColor',[1 1 1]*0.8),hold on
    [hl,hp]=boundedline(freqBin,nanmean(FreqGranger{AllCombi(k,1),AllCombi(k,2)}),[stdError(FreqGranger{AllCombi(k,1),AllCombi(k,2)});stdError(FreqGranger{AllCombi(k,1),AllCombi(k,2)})]','alpha');hold on
    set(hl,'Color',Cols2(1,:)*0.7,'linewidth',2)
    set(hp,'FaceColor',Cols2(1,:))
    hold on
    [hl,hp]=boundedline(freqBin,nanmean(FreqGranger{AllCombi(k,2),AllCombi(k,1)}),[stdError(FreqGranger{AllCombi(k,2),AllCombi(k,1)});stdError(FreqGranger{AllCombi(k,2),AllCombi(k,1)})]','alpha');hold on
    set(hl,'Color',Cols2(2,:)*0.7,'linewidth',2)
    set(hp,'FaceColor',Cols2(2,:))
    ylim([0 0.5]), hold on
    title([StrucNames{AllCombi(k,1)},' - ',StrucNames{AllCombi(k,2)}])
    set(gca,'Layer','top')
    subplot(3,2,(k-1)*2+2)
    plotSpread([PartGranger{AllCombi(k,1),AllCombi(k,2)}',PartGranger{AllCombi(k,2),AllCombi(k,1)}']), hold on,ylim([0 0.2])
end




