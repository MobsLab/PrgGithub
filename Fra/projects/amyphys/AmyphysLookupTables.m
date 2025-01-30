function AmyphysLookupTables()
  
  
  Amyphys_StimLookup = dictArray;
  
  Amyphys_StimLookup{'Monkey 1'} =  [1, 6, 11, 31, 36, 41];
  Amyphys_StimLookup{'Monkey 2'} =  [2, 7, 12, 32, 37, 42];
  Amyphys_StimLookup{'Monkey 3'} =  [3, 8, 13, 33, 38, 43];
  Amyphys_StimLookup{'Monkey 4'} =  [4, 9, 14, 34, 39, 44];
  Amyphys_StimLookup{'Monkey 5'} =  [5, 10, 15, 35, 40, 45];
  
  Amyphys_StimLookup{'Expr Neutral'} = [1:5, 31:35];
  Amyphys_StimLookup{'Expr Lipsmack'} = [6:10, 36:40];
  Amyphys_StimLookup{'Expr Threat'} = [11:15, 41:45];
  
  Amyphys_StimLookup{'Object familiar'} = [16:20];
  Amyphys_StimLookup{'Object unfamiliar'} = [26:30];  
  
  Amyphys_StimLookup{'Human faces'} = [21:25];  
  
  Amyphys_StimLookup{'Trial Rewarded'} = [1:30];
  Amyphys_StimLookup{'Trial Unrewarded'} = [31:60];  
  
  
  
%%%%%%%%%%%%%% phys1

  Phys1_StimLookup = dictArray;
  
  Phys1_StimLookup{'Monkey 1'} =  [1, 2, 3];
  Phys1_StimLookup{'Monkey 2'} =  [4, 5, 6];
  Phys1_StimLookup{'Monkey 3'} =  [7, 8, 9];
  Phys1_StimLookup{'Monkey 4'} =  [10, 11, 12];
  Phys1_StimLookup{'Monkey 5'} =  [13, 14, 15];
  Phys1_StimLookup{'Monkey 6'} =  [16, 17, 18];
  Phys1_StimLookup{'Monkey 7'} =  [19, 20, 21];
  Phys1_StimLookup{'Monkey 8'} =  [22, 23, 24];
  Phys1_StimLookup{'Monkey 9'} =  [25, 26, 27];
  Phys1_StimLookup{'Monkey 10'} =  [28, 29, 30];  
  
  Phys1_StimLookup{'Expr Neutral'} = [1,4,7,10,13,16,19,22,25,28];
  Phys1_StimLookup{'Expr Lipsmack'} = [2,5,8,11,14,17,20,23,26,29];
  Phys1_StimLookup{'Expr Threat'} = [3,6,9,12,15,18,21,24,27,30];
  
  Phys1_StimLookup{'Objects'} = [31:40];
  Phys1_StimLookup{'Human'} = [41:50];
  Phys1_StimLookup{'Animal'} = [51:60];  
  
  Phys1_StimLookup{'Gaze Direct'} = [1,2,3,7,8,9,13,14,15,16,17,18,19,20, ...
		    21,25,26,27];
  Phys1_StimLookup{'Gaze Away'} = [4,5,6,10,11,12,22,23,24,28,29,30];
  
%%%%%%%%%%%%%% phys2  


  Phys2_StimLookup = dictArray;
  Phys2_StimLookup{'Monkey 1'} =  [1,2,3,4,5];
  Phys2_StimLookup{'Monkey 2'} =  [6,7,8,9,10];
  Phys2_StimLookup{'Monkey 3'} =  [11,12,13,14,15];
  Phys2_StimLookup{'Monkey 4'} =  [16,17,18,19,20];
  Phys2_StimLookup{'Monkey 5'} =  [21,22,23,24,25];
  Phys2_StimLookup{'Monkey 6'} =  [26,27,28,29,56];
  Phys2_StimLookup{'Monkey 7'} =  [30,31,32,33,34];
  Phys2_StimLookup{'Monkey 8'} =  [35,36,37,38,39];

  Phys2_StimLookup{'Expr Fullbody'} = [1,6,11,16,21,26,30,35];
  Phys2_StimLookup{'Expr Lipsmack'} = [2,7,12,17,22,27,31,36];
  Phys2_StimLookup{'Expr Neutral'} = [3,8,13,18,23,56,32,37];
  Phys2_StimLookup{'Expr Threat Mild'} = [4,9,15,19,24,28,33,39];
  Phys2_StimLookup{'Expr Threat Strong'} = [5,10,14,20,25,29,34,38];
  
  Phys2_StimLookup{'Human'} = [40,41,42,43,44,45,54,55];
  Phys2_StimLookup{'Objects'} = [46,47,48,49,50,51,52,53];  
  
  
%%%%%%%%%%%%%% face

  Face_StimLookup = dictArray;
  Face_StimLookup{'Expr Fullbody'} = [1,2,5,6,7,8,9,10,11,12,13,14,17,18, ...
		    25,26,31,32,43,44,49,50,51,52,59,60,73,74,75,76,77,78,89,90]; 

  Face_StimLookup{'Expr Faces'} =   [3,4,15,16,19,20,21,22,23,24,27,28, ...
		    29,30,33,34,35,36,37,38,39,40,41,42,45,46,47,48,53, ...
		    54,55,56,57,58,61,62,63,64,65,66,67,68,69,70,71,72, ...
		    79,80,81,82,83,84,85,86,87,88];   
  
%%%%%%%%%%%%%% DandM  

  DandM_StimLookup = dictArray;
  DandM_StimLookup{'Monkeys'} = [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29, ...
		    31,33,35,37,39,41,43,45,47,4 9,51,53,55,57,59,61,63, ...
		    65,67,69,71,73,75,77,79,]; 
  
  DandM_StimLookup{'Dog'} = [2,4,6,8,10,12,14,16,18,20,222,24,26,28,30, ...
		    32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64, ...
		    66,68,70,72,74,76,78,80]; 
  
  
  
  
  
  
  BehaviorLookup = dictArray;
  BehaviorLookup{'StartITI'} = 9;
  BehaviorLookup{'EndITI'} = 10;  
  BehaviorLookup{'FixSpotOn'} = 35;
  BehaviorLookup{'StartFixating'} = 20;
  BehaviorLookup{'FixSpotOff'} = 36;
  BehaviorLookup{'CueOn'} = 23;
  BehaviorLookup{'CueOff'} = 24;
  BehaviorLookup{'EndTrial'} = 17;
  BehaviorLookup{'EndPostTrial'} = 18;
  BehaviorLookup{'Reward'} = 3;
 
  
  
  
  save AmyphysLookupTables Amyphys_StimLookup  Phys1_StimLookup ...
      Phys2_StimLookup Face_StimLookup DandM_StimLookup BehaviorLookup
  
  
  
