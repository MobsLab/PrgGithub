%genLocalGlobal2013
load LocalGlobalTotalAssignment

Event_LstdGstd_A=LocalStdGlobStdA;
Event_LstdGstd_B=LocalStdGlobStdB;
Event_LdvtGstd_A=LocalDvtGlobStdA;
Event_LdvtGstd_B=LocalDvtGlobStdB;
Event_LstdGdvt_A=LocalStdGlobDvtA;
Event_LstdGdvt_B=LocalStdGlobDvtB;
Event_LdvtGdvt_A=LocalDvtGlobDvtA;
Event_LdvtGdvt_B=LocalDvtGlobDvtB;
Event_OmiFreq_A=OmiAAAA;
Event_OmiFreq_B=OmiBBBB;
Event_OmiRare_A=OmissionRareA;
Event_OmiRare_B=OmissionRareB;



% % remove Global_Std if preceeding by Global_Dvt
% figure, plot(Event_LstdGstd_A,10,'ko')
% hold on, plot(Event_LdvtGdvt_A,10.1,'bo')
% hold on, axis([2*1E6 8*1E7 9.5 10.5])
% clear id, clear id2,clear id3, clear ValueToDelete
% 
% id=[];
% i=1;
% j=1;
% while i<length(Event_LdvtGdvt_A)+1
%     id=(Event_LstdGstd_A(:,1)-Event_LdvtGdvt_A(i));
%     id2=find(id>0);
%     id3=min(id2);
%     if ~isempty(id3)
%         ValueToDelete(j)=id3;
%         hold on, plot(Event_LstdGstd_A(id3),10,'rd','linewidth',2)
%         disp(['total suppressed value:  ', num2str(length(ValueToDelete))])
%         j=j+1;
%     end
%     i=i+1;
% end
% Event_LstdGstd_A([ValueToDelete])=[];
% 
% % remove Global_Std if preceeding by Global_Dvt
% figure, plot(Event_LstdGstd_B,10,'ko')
% hold on, plot(Event_LdvtGdvt_B,10.1,'bo')
% hold on, axis([2*1E6 8*1E7 9.5 10.5])
% clear id, clear id2,clear id3, clear ValueToDelete
% 
% id=[];
% i=1;
% j=1;
% while i<length(Event_LdvtGdvt_B)+1
%     id=(Event_LstdGstd_B(:,1)-Event_LdvtGdvt_B(i));
%     id2=find(id>0);
%     id3=min(id2);
%     if ~isempty(id3)
%         ValueToDelete(j)=id3;
%         hold on, plot(Event_LstdGstd_B(id3),10,'rd','linewidth',2)
%         disp(['total suppressed value:  ', num2str(length(ValueToDelete))])
%         j=j+1;
%     end
%     i=i+1;
% end
% Event_LstdGstd_B([ValueToDelete])=[];
% % remove Global_Std if preceeding by Global_Dvt
% figure, plot(Event_LdvtGstd_A,10,'ko')
% hold on, plot(Event_LstdGdvt_A,10.1,'bo')
% hold on, axis([2*1E6 8*1E7 9.5 10.5])
% clear id, clear id2,clear id3, clear ValueToDelete
% 
% id=[];
% i=1;
% j=1;
% while i<length(Event_LstdGdvt_A)+1
%     id=(Event_LdvtGstd_A(:,1)-Event_LstdGdvt_A(i));
%     id2=find(id>0);
%     id3=min(id2);
%     if ~isempty(id3)
%         ValueToDelete(j)=id3;
%         hold on, plot(Event_LdvtGstd_A(id3),10,'rd','linewidth',2)
%         disp(['total suppressed value:  ', num2str(length(ValueToDelete))])
%         j=j+1;
%     end
%     i=i+1;
% end
% Event_LdvtGstd_A([ValueToDelete])=[];
% 
% % remove Global_Std if preceeding by Global_Dvt
% figure, plot(Event_LdvtGstd_B,10,'ko')
% hold on, plot(Event_LstdGdvt_B,10.1,'bo')
% hold on, axis([2*1E6 8*1E8 9.5 10.5])
% clear id, clear id2,clear id3, clear ValueToDelete
% 
% id=[];
% i=1;
% j=1;
% while i<length(Event_LstdGdvt_B)+1
%     id=(Event_LdvtGstd_B(:,1)-Event_LstdGdvt_B(i));
%     id2=find(id>0);
%     id3=min(id2);
%     if ~isempty(id3)
%         ValueToDelete(j)=id3;
%         hold on, plot(Event_LdvtGstd_B(id3),10,'rd','linewidth',2)
%         disp(['total suppressed value:  ', num2str(length(ValueToDelete))])
%         j=j+1;
%     end
%     i=i+1;
% end
% Event_LdvtGstd_B([ValueToDelete])=[];


LocalEffect_std=[Event_LstdGstd_A;Event_LstdGstd_B];
LocalEffect_dvt=[Event_LdvtGstd_A;Event_LdvtGstd_B];

GlobalEffectLstd_std=[Event_LstdGstd_A;Event_LstdGstd_B];
GlobalEffectLstd_dvt=[Event_LstdGdvt_A;Event_LstdGdvt_B];

GlobalEffectLdvt_std=[Event_LdvtGstd_A;Event_LdvtGstd_B];
GlobalEffectLdvt_dvt=[Event_LdvtGdvt_A;Event_LdvtGdvt_B];

OmissionEffect_std=[Event_OmiFreq_A;Event_OmiFreq_B];
OmissionEffect_dvt=[Event_OmiRare_A;Event_OmiRare_B];

%-------------------------------------------------------------------------------------------------------------------
save LocalGlobal Event_LstdGstd_A Event_LdvtGstd_A Event_LstdGdvt_A Event_LdvtGdvt_A Event_OmiRare_A Event_OmiFreq_A
%-------------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------
save LocalGlobal -append Event_LstdGstd_B Event_LdvtGstd_B Event_LstdGdvt_B Event_LdvtGdvt_B Event_OmiRare_B Event_OmiFreq_B
%---------------------------------------------------------------------------------------------------------------------------