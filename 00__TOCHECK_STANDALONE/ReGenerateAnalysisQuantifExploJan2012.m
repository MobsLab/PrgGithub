function ReGenerateAnalysisQuantifExploJan2012

load ParametersAnalyseICSS varargin o N M

length(varargin)

dok=0;
le=length(varargin);
for i=1:le
    try
        if varargin{i}(1)=='s'&varargin{i}(2)=='a'&varargin{i}(3)=='v'
            varargin{i+1}='y'; 
            dok=1;
        end
    end
end

if dok==0
    varargin{le+1}='save'; 
    varargin{le+2}='y';    
end

dok=0;
le=length(varargin);
for i=1:le
    try
        if varargin{i}(1)=='p'&varargin{i}(2)=='o'&varargin{i}(3)=='s'
            varargin{i+1}='s'; 
            dok=1;
        end
    end
end
if dok==0
    varargin{le+1}='positions'; 
    varargin{le+2}='s';    
end


% dok=0;
% le=length(varargin);
% for i=1:le
%     try
%         if varargin{i}(1)=='l'&varargin{i}(2)=='i'&varargin{i}(3)=='m'&varargin{i}(4)=='d'
%             varargin{i+1}=20; 
%             dok=1;
%         end
%     end
% end
% if dok==0
%     varargin{le+1}='limdist'; 
%     varargin{le+2}=5;    
% end



vara=[];
for i=1:length(varargin)
    try
        if ~ischar(varargin{i})
           
            if length(varargin{i})==1
                varargin{i}=num2str(varargin{i});
            else
                temp=[];
                for j=1:length(varargin{i})
                    temp=[temp,' ',num2str(varargin{i}(j))];
                end
                varargin{i}=['[',temp(2:end),']'];
            end
            
        else
            
            varargin{i}=['''',varargin{i},''''];
        
        end
    end
    
    vara=[vara,',',varargin{i}];
end
vara=vara(2:end);


% eval(['AnalysisQuantifExploJan2012(o,N,M,',vara,');']);
eval(['[Res, mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2,homogeneity,TimeInStimAreaPre,TimeInStimAreaPost,TimeInLargeStimAreaPre,TimeInLargeStimAreaPost,CorrelationCoef,CorrelationCoefCorrected,DistanceToStimZonePre,DistanceToStimZonePost,DelayToStimZonePre,DelayToStimZonePost,ICSSefficiency,QuadrantTimePre,QuadrantTimePost,listQuantif,theroriticalTh,StdAnglePre,StdAnglePost,theroriticalThL,PFb,BW,N,M,mapSs,spike]=AnalysisQuantifExploJan2012(o,N,M,',vara,');']);

save AnalyseResourcesICSSNew Res homogeneity TimeInStimAreaPre TimeInStimAreaPost TimeInLargeStimAreaPre TimeInLargeStimAreaPost CorrelationCoef CorrelationCoefCorrected DistanceToStimZonePre DistanceToStimZonePost StdAnglePre StdAnglePost DelayToStimZonePre DelayToStimZonePost QuadrantTimePre QuadrantTimePost mapS mapSs listQuantif theroriticalTh theroriticalThL PF PFb BW ICSSefficiency N M pxS pyS
    


