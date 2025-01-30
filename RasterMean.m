
function [matValst,matValto]=RasterMean(date, tsa,essaiDeb,essaiFin)


cd /media/karimou/Data



date=num2str(date);

if date(1:2)=='18'
    fichierDate=num2str(['/media/karimou/Data/Rat18/',date]);
    else if date(1:2)=='12'
        fichierDate=num2str(['/media/karimou/Data/Rat12/',date]);
        else if date(1:2)=='19'
            fichierDate=num2str(['/media/karimou/Data/Rat19/',date]);
            else if date(1:2)=='20'
                fichierDate=num2str(['/media/karimou/Data/Rat20/',date]);
                else if date(1:2)=='15'
                    fichierDate=num2str(['/media/karimou/Data/Rat15/',date]);
                    end
                end
            end
        end
end

                  

            
cd (fichierDate)

load DataFinal
%  load CoherenceGlobal
%  load CoherenceData

load behavResources

nametsa=tsa;
eval(['tsa=',tsa,';'])


st=Range(startTrial{1});
%st=st(2:end-1);
to=Range(trialOutcome{1});
%to=to(2:end-1);


tps(1)=st(1);
				for i=1:length(st)-1
				ypos=Restrict(YS{1},IntervalSet(to(i),to(i+1)));
				datY=[Range(ypos) Data(ypos)];
				l=find(datY(:,2)==max(datY(:,2)));
				tps(i+1)=datY(l(1),1);
				end
				
				ArmExtTps=tsd(tps,Data(startTrial{1}));
tpsArm=Range(ArmExtTps);




%--------------------------------------------------------------------------------------------------------------------------------------------



l=length(nametsa);
num=nametsa(l-1:end);


		if essaiFin>length(st)
			figure,  [fh1, rasterAx1, histAx1, matValst] = ImagePETH(tsa, ts(st(essaiDeb:end-1)), -100000, 100000, ...
			'Markers', {ts(tpsArm(essaiDeb:end-1))},'MarkerTypes', {'k.' } , 'Markers2', {ts(to(essaiDeb:end-1))} ,'MarkerTypes2', {'w.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean startTrial ',num,' ',date,' ', num2str(essaiDeb),' a ','Fin']));
			
			
%  			saveas(gcf, num2str(num2str(['RasterMean_startTrial_',num,'_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
			
			%  	if essaiDeb==1
			%  	essaiDeb=2;
			%  	end
			
			figure,  [fh1, rasterAx1, histAx1, matValto] = ImagePETH(tsa, ts(to(essaiDeb:end-1)), -100000, 700000, ...
			'Markers', {ts(tpsArm(essaiDeb+1:end))},'MarkerTypes', {'k.' } , 'Markers2', {ts(st(essaiDeb:end-1))} ,'MarkerTypes2', {'w.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean trialOutcome ',num,' ',date,' ', num2str(essaiDeb),' a ','Fin']));
			
			
			
%  			saveas(gcf, num2str(num2str(['RasterMean_trialoutcome_',num,'_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
		
		
		else
			figure,  [fh1, rasterAx1, histAx1, matValst] = ImagePETH(tsa, ts(st(essaiDeb:essaiFin)), -100000, 100000, ...
					'Markers', {ts(tpsArm(essaiDeb:essaiFin))} , 'MarkerTypes', {'k.' },'Markers2', {ts(to(essaiDeb:essaiFin))} ,'MarkerTypes2', {'w.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean startTrial ',num,' ',date,' ', num2str(essaiDeb),' a ','Fin']));
			
%  			saveas(gcf, num2str(num2str(['RasterMean_startTrial_',num,'_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
				
			
			
			%  if essaiDeb==1
			%  essaiDeb=2;
			%  end
			figure,  [fh1, rasterAx1, histAx1, matValto] = ImagePETH(tsa, ts(to(essaiDeb:essaiFin-1)), -100000, 700000, ...
					'Markers', {ts(tpsArm(essaiDeb+1:essaiFin))} , 'MarkerTypes', {'k.' },'Markers2', {ts(st(essaiDeb:essaiFin-1))} ,'MarkerTypes2', {'w.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean trialOutcome ',num,' ',date,' ', num2str(essaiDeb),' a ','Fin']));
			
%  			saveas(gcf, num2str(num2str(['RasterMean_trialOutcome_',num,'_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
				
			
		end
		
		
		
		%-------------------------------------------------------------------------------------------------------------------------------------------------------
		%Figure des moyennes
		%
		
%  		MeanMatValst=(matValst)';
%  		MeanMatValst=mean(MeanMatValst);
%  		
%  		MeanMatValto=(matValto)';
%  		MeanMatValto=mean(MeanMatValto);
%  		
%  		MeanMatValstTsd=tsd(Range(matValst),MeanMatValst');
%  		MeanMatValtoTsd=tsd(Range(matValto),MeanMatValto');
%  		
%  		MeanMatValtoTsdfil=FiltGauss(MeanMatValtoTsd,10,1);
%  		MeanMatValstTsdfil=FiltGauss(MeanMatValstTsd,10,1);
%  		
%  		figure, hold on
%  		plot(Range(MeanMatValstTsd),Data(MeanMatValstTsd))
%  		plot(Range(MeanMatValstTsd),Data(MeanMatValstTsdfil),'r')
%  		saveas(gcf, num2str(num2str(['Mean_st_',num,'_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
%  		
%  		figure, hold on
%  		plot(Range(MeanMatValtoTsd),Data(MeanMatValtoTsd))
%  		plot(Range(MeanMatValtoTsd),Data(MeanMatValtoTsdfil),'r')
%  		saveas(gcf, num2str(num2str(['Mean_to_',num,'_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
		
		
		
		%------------------------------------------------------------------------------------------------------------------------------------------------------------------