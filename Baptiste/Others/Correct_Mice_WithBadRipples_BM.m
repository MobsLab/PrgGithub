
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for sess=1:length(Sess.M1189)
    
    cd(Sess.M1189{sess})
    
     channel=4;
     save('ChannelsToAnalyse/dHPC_rip','channel')
     
     delete Ripples.fig
     delete Ripples.png
     delete Ripples.mat
     delete RipplesSleepThresh.fig
     delete RipplesSleepThresh.mat
     delete RipplesSleepThresh.png
    
    SessNames{1} = cd;
    GetRipplesForSessions_BM
    
end
