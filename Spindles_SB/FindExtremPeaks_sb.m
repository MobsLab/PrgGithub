function [tpeaks,tDeltaP2,tDeltaT2,t,brst]=FindExtremPeaks_sb(lfp,thD,Epoch)

relativ=1;
rg=Range(lfp);


% lfp=ResampleTSD(lfp,500);

try
    Epoch;
catch
    
    Epoch=intervalSet(rg(1),rg(end));
end

tDeltaT=[];
tDeltaP=[];

h = waitbar(0,'Please wait...');

% length(Start(Epoch))

    lfpr=Restrict(lfp,Epoch); 
    for j=2:10
  try

   Filt_EEGd = FilterLFP(lfpr, [2*j 2*(j+1)], 256);
            eegd=Data(Filt_EEGd)';
            td=Range(Filt_EEGd,'s')';

          de = diff(eegd);
          de1 = [de 0];
          de2 = [0 de];

          %finding peaks
          upPeaksIdx = find(de1 < 0 & de2 > 0);
          downPeaksIdx = find(de1 > 0 & de2 < 0);

          PeaksIdx = [upPeaksIdx downPeaksIdx];
          PeaksIdx = sort(PeaksIdx);

          Peaks = eegd(PeaksIdx);
        %   Peaks = abs(Peaks);

         tDeltatemp=td(PeaksIdx);

          if relativ
            DetectThresholdP=+mean(Data(Filt_EEGd))+thD*std(Data(Filt_EEGd))*log(j+2);
            DetectThresholdT=-mean(Data(Filt_EEGd))-thD*std(Data(Filt_EEGd))*log(j+2);
            %thD*std(Data(Filt_EEGd))
          else
            DetectThresholdP=+mean(Data(Filt_EEGd))+absTh;
            DetectThresholdT=-mean(Data(Filt_EEGd))-absTh;
          end

        % length(tDeltatemp)

            idsT=find((Peaks<DetectThresholdT));
            idsP=find((Peaks>DetectThresholdP));

            tDeltatempT=tDeltatemp(idsT);
            tDeltatempP=tDeltatemp(idsP);
            
            try

                        tDeltaT=[tDeltaT;[tDeltatempT',(2*j+1)*ones(length(tDeltatempT),1)]];
                        tDeltaP=[tDeltaP;[tDeltatempP',(2*j+1)*ones(length(tDeltatempP),1)]];
            %             tDeltaT(2,:)=[tDeltaT(2,:),2*(j+1)*ones(1,length(tDeltatempT)
            %             )];
            catch
                        tDeltaT=zeros(size(tDeltatempT',1),size(tDeltatempT',2));
                        tDeltaT(:,1)=[tDeltatempT'];
                        tDeltaT(:,2)=[2*(j+1)*ones(length(tDeltatempT),1)];    

                        tDeltaP=zeros(size(tDeltatempP',1),size(tDeltatempP',2));
                        tDeltaP(:,1)=[tDeltatempP'];
                        tDeltaP(:,2)=[2*(j+1)*ones(length(tDeltatempP),1)];  
            end
% 
%             tDeltaP=[tDeltaP,tDeltatempP];
        
     end
         end



% 
% tDeltaT=ts(sort(tDeltaT(:,1))*1E4);
 %tDeltaP=ts(sort(tDeltaP)*1E4);
% 
% tdeltaT=Range(tDeltaT);
 %tdeltaP=Range(tDeltaP);

 close (h)
 
[BE,idx]=sort(tDeltaT(:,1));
 tdeltaT=[tDeltaT(idx,1)*1E4 tDeltaT(idx,2)];
idd=find(tdeltaT(:,1)+1E4<rg(end)&tdeltaT(:,1)-1E4>0);
tDeltaT2=tdeltaT(idd,:);
tDeltaT2=tsd(tDeltaT2(:,1),tDeltaT2(:,2));

 [BE,idx]=sort(tDeltaP(:,1));
 tdeltaP=[tDeltaP(idx,1)*1E4 tDeltaP(idx,2)];
idd=find(tdeltaP(:,1)+1E4<rg(end)&tdeltaP(:,1)-1E4>0);
tDeltaP2=tdeltaP(idd,:);
tDeltaP2=tsd(tDeltaP2(:,1),tDeltaP2(:,2));


% idd=find(tdeltaP+1E4<rg(end)&tdeltaP-1E4>0);
% tDeltaP2=tdeltaP(idd);
% tDeltaP2=ts(tDeltaP2);
[tps,id]=sort([Range(tDeltaP2);Range(tDeltaT2)]);
Mat=[Data(tDeltaP2);Data(tDeltaT2)];

tpeaks=tsd(tps,Mat(id,:));

brst = burstinfo(Range(tpeaks,'s'), 5);

t{1}=brst.t_start;
t{2}=brst.t_end;
t{3}=brst.n;



