% SubstractRef

%Path='/media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M231/FEAR-Mouse231-EXTenvC-_150212_140054/FEAR-Mouse-231-12022015-EXTenvC/LFPData_Ref2substract';
%Path='/media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie/M230/FEAR-Mouse230-EXTenvC-_150212_132714/FEAR-Mouse-230-12022015-EXTenvC/LFPData_Ref2substract';
%Path='/media/DataMOBS23/M244/20150506/FEAR-Mouse-244-06052015-EXTenvC/FEAR-Mouse-244-06052015/LFPData_Ref2substract';
%Path='/media/DataMOBS23/M244/20150507/FEAR-Mouse-244-07052015-EXTenvB/FEAR-Mouse-244-07052015/LFPData_Ref2substract';
%Path='/media/DataMOBS23/M244/20150508/FEAR-Mouse-244-08052015-EXTenvC/FEAR-Mouse-244-08052015/LFPDataRef2subtract';
%Path='/media/DataMOBs29/M253/20150701-04-manip control/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/LFPDataRef2Substract';
%Path='/media/DataMOBs29/M253/20150701-04-manip control/20150704-EXT-48h-envB/FEAR-Mouse-253-04072015/LFPDataRef2Subtract';
%Path='/media/DataMOBs29/M254/20150701-04-manip control/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015/LFPDataRef2Substract';
%Path='/media/DataMOBs29/M254/20150701-04-manip control/20150704-EXT-48h-envB/FEAR-Mouse-254-04072015/LFPDataRef2Substract';
%Path='/media/DataMOBs29/M254/20150706-09-manip CNO1/20150714-EXT-24h-envC/FEAR-Mouse-254-07072015/LFPDataRef2Substract';
%Path='/media/DataMOBs29/M254/20150706-09-manip CNO1/20150715-EXT-48h-envC/FEAR-Mouse-254-08072015/LFPDataRef2Substract';
%Path='/media/DataMOBs29/M254/20150713-15-manip CNO2/20150714-EXT-24-envC/FEAR-Mouse-254-14072015/LFPDataRef2Substract';
Path='/media/DataMOBs29/M254/20150713-15-manip CNO2/20150715-EXT-48h-envB/FEAR-Mouse-254-15072015/LFPDataRef2substract';

cd(Path)
load InfoLFP
NbRef=find(strcmp(InfoLFP.structure, 'Ref')); 
NbRef=InfoLFP.channel(NbRef);% attention  nécessoaire les n° de channels ne sont pas rangés dans l'ordre dans InfoLPF.channel
load(['LFP' num2str(NbRef) '.mat']);

Ref=FilterLFP(LFP,[0.1 5], 2048);
Ref=Data(Ref);
NbAccelero=InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
list=dir;
% remove channel from accelerometer from the list
for i=1:length(list)
    %list_temp(i).name=list(i).name;
    for j=1:length(NbAccelero)
        if ~isempty(findstr(list(i).name, num2str(NbAccelero(j))))
            list(i).name='-';
        end
    end
end
%list.name=list_temp.name;
a=1;
            
for i=1:length(list)
    if length(list(i).name) >3
        if strcmp(list(i).name(1:3), 'LFP')

                load(list(i).name)

                t=Range(LFP);
                LFP_temp=Data(LFP);
                figure; plot(Range(LFP), Data(LFP)),
                hold on, plot(t, Ref,'k')

                LFP_temp=LFP_temp-Ref;
                LFP=tsd(t,LFP_temp);
                hold on, plot(t, LFP_temp-4000,'r')
                title(list(i).name)
                legend('rawLFP', 'Ref','LFP_temp-Ref')
                saveas (gcf,[list(i).name(1:end-4) '.fig'])
                cd ..
                save(['LFPData/' list(i).name], 'LFP')
                cd(Path)

        end
    end
end

                    
