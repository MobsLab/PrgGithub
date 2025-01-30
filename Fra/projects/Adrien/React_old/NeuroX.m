function NeuroXidenceStat = NeuroX(dataGDF,nbCells)

	nbTrials = length(dataGDF)
	
	eta                                 = 4;
	Input.Trials                        = nbTrials;
	Input.GDF_all_trials                = dataGDF;
	Input.Window                        = [0 100];
	Input.Nr_Neurons                    = nbCells;
	Input.dt                            = 1/10^3;                           % Resolution of your Data
	Input.Max_Nr_Jitter_Points          = 300;                              % Tau_C in units of Input.dt - Timescale of Joint Spike Events
	Input.Jittering_for_sig             = eta*Input.Max_Nr_Jitter_Points ;  % Tau_R in units of Input.dt - Lower bound of Timescale of Rate co-variations 
	Input.Nr_Surrogate                  = 20;                               % Number ofSurrogates
	Input.test_level                    = 0.01;                             % Testlevel
	Input.flag_both_jitter              = 0;                                % Destroys structure in the surrogate as well as in the original dataset- Must be used to  estimate efects under H0
	NeuroXidenceStat                    = NeuroXidence_Windowed_V2(Input);
