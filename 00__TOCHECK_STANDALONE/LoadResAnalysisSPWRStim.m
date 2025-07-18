function [Res,Res2,ResC,ResC2,k,l]=LoadResAnalysisSPWRStim(Res,Res2,ResC,ResC2,k,l)

% Outpu:
%---------------------------------------
% Res(1,l)=channel ;
% Res(2,l)=DurationSWS ;
% Res(3,l)=DurationREM ;
% Res(4,l)=RatioREMSWS; 
% Res(5,l)=NbStimREM ;
% Res(6,l)=NbStimSWS  ;
% Res(7,l)=FreqStimTheta;  
% Res(8,l)=FreqStimSWS ;
% Res(9,l)=PercStimRiplpes ;
% Res(10,l)=NbIntactRipplesOutsideStim; 
% Res(11,l)=NbIntactRipplesDuringSWS ;
% Res(12,l)=NbIntactRipplesDuringREM ;
% Res(13,l)=FreqIntactRipplesDuringSWS ;
% Res(14,l)=FreqIntactRipplesDuringREM ;
% Res(15,l)=NbRipplesCorrectedDuringSWS ;
% Res(16,l)=NbRipplesCorrectedDuringREM ;
% Res(17,l)=FreqRipplesCorrectedDuringSWS ;
% Res(18,l)=FreqRipplesCorrectedDuringREM; 
% Res(19,l)=NbSpikeRipples ;
% Res(20,l)=NombreRipples ;
% Res(21,l)=NombreSpikes ;
% Res(22,l)=DurationPeriod ;
% Res(23,l)=NbRipplesWithSpikes;
%
%


Ti{1}='channel' ;
Ti{2}='DurationSWS' ;
Ti{3}='DurationREM' ;
Ti{4}='RatioREMSWS' ;
Ti{5}='NbStimREM' ;
Ti{6}='NbStimSWS' ;
Ti{7}='FreqStimTheta' ;  
Ti{8}='FreqStimSWS' ;
Ti{9}='PercStimRiplpes' ;
Ti{10}='NbIntactRipplesOutsideStim' ; 
Ti{11}='NbIntactRipplesDuringSWS' ;
Ti{12}='NbIntactRipplesDuringREM' ;
Ti{13}='FreqIntactRipplesDuringSWS' ;
Ti{14}='FreqIntactRipplesDuringREM' ;
Ti{15}='NbRipplesCorrectedDuringSWS' ;
Ti{16}='NbRipplesCorrectedDuringREM' ;
Ti{17}='FreqRipplesCorrectedDuringSWS' ;
Ti{18}='FreqRipplesCorrectedDuringREM' ;
Ti{19}='OccurenceBefore';
Ti{20}='FreqBefore';

Ti{21}='NbSpikeRipples' ;
Ti{22}='NombreRipples' ;
Ti{23}='NombreSpikes' ;
Ti{24}='DurationPeriodv' ;
Ti{25}='NbRipplesWithSpikes' ;

load ResAnalysisSPWRStimMFBburst

Res(1,k)=channel ;
Res(2,k)=DurationSWS ;
Res(3,k)=DurationREM ;
Res(4,k)=RatioREMSWS; 
Res(5,k)=NbStimREM ;
Res(6,k)=NbStimSWS  ;
Res(7,k)=FreqStimTheta;  
Res(8,k)=FreqStimSWS ;
Res(9,k)=PercStimRiplpes ;
Res(10,k)=NbIntactRipplesOutsideStim; 
Res(11,k)=NbIntactRipplesDuringSWS ;
Res(12,k)=NbIntactRipplesDuringREM ;
Res(13,k)=FreqIntactRipplesDuringSWS ;
Res(14,k)=FreqIntactRipplesDuringREM ;
Res(15,k)=NbRipplesCorrectedDuringSWS ;
Res(16,k)=NbRipplesCorrectedDuringREM ;
Res(17,k)=FreqRipplesCorrectedDuringSWS ;
Res(18,k)=FreqRipplesCorrectedDuringREM; 
Res(19,k)=OccurenceBefore;
Res(20,k)=FreqBefore;

Res2{1,k}=pwd;
Res2{2,k}=freq ;
Res2{3,k}=SpectrumSWS ;
Res2{4,k}=SpectrumREM ;

k=k+1;

try
load ResAnalysisSPWRStimCtrl 
ResC(1,l)=channel ;
ResC(2,l)=DurationSWS ;
ResC(3,l)=DurationREM ;
ResC(4,l)=RatioREMSWS; 
ResC(5,l)=NbStimREM ;
ResC(6,l)=NbStimSWS  ;
ResC(7,l)=FreqStimTheta;  
ResC(8,l)=FreqStimSWS ;
ResC(9,l)=PercStimRiplpes ;
ResC(10,l)=NbIntactRipplesOutsideStim; 
ResC(11,l)=NbIntactRipplesDuringSWS ;
ResC(12,l)=NbIntactRipplesDuringREM ;
ResC(13,l)=FreqIntactRipplesDuringSWS ;
ResC(14,l)=FreqIntactRipplesDuringREM ;
ResC(15,l)=NbRipplesCorrectedDuringSWS ;
ResC(16,l)=NbRipplesCorrectedDuringREM ;
ResC(17,l)=FreqRipplesCorrectedDuringSWS ;
ResC(18,l)=FreqRipplesCorrectedDuringREM; 

ResC(19,l)=OccurenceBefore;
ResC(20,l)=FreqBefore;

ResC(21,l)=NbSpikeRipples ;
ResC(22,l)=NombreRipples ;
ResC(23,l)=NombreSpikes ;
ResC(24,l)=DurationPeriod ;
ResC(25,l)=NbRipplesWithSpikes; 
 
ResC2{1,l}=pwd;
ResC2{2,l}=freq ;
ResC2{3,l}=SpectrumSWS ;
ResC2{4,l}=SpectrumREM ;
l=l+1;
end