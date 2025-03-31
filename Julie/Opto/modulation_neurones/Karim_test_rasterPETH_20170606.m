% script with Karim 2017.06.06
% attempt to see the effect of the stim with all neurons
% (PoolNeurons(S,id2))
% 
% 2 questions
% - la reponse des neurones est elle un potentiel évoqué => devrait être ma même pour toute les frequence
% - est-ce que les neurones continuent à etre modulés après la fin de la stim
% 



% interneuons
id2=find(fr>3);


% pyramidals
id2=find(fr<3);



fq=3;
num=7;




for fq=1:3
     stim_int_dur=subset(int_laser,ind_OI{fq});
     test=Range(Restrict(ts(dotps), stim_int_dur));
    figure('Position',[100+fq*300,100,300,500])
    [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH(PoolNeurons(S,7), ts(test(1:10:end)), -10000, 10000,'BinSize',1000);% Triggered on opto stim
    %[C,B]=CrossCorr(test,Range(PoolNeurons(S,id2)),100,2000);
    %plot(B/1E3,C)
    title (num2str(fq_list(fq)))
end








 [C,B]=CrossCorr(Range(PoolNeurons(S,id2)), Range(Restrict(ts(uptps), stim_int_dur)),100,100);
figure, plot(B/1E3,C)