/*********************************************************************
pathIntegratorNetImpl, C implementation of the dynamics loop of the
path integrator network 

Vconf = pathIntegratorNetImpl(J, dirCell, Vi, vRat, params);

 * % copyright (c) 2004 Francesco P. Battaglia
 * % This software is released under the GNU GPL
 * % www.gnu.org/copyleft/gpl.html

**********************************************************************/




#include <math.h>
#include <mex.h>
#include <matrix.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#define J_ELEM(i, j) (J[(j)*N + (i)]) 
#define EPSILON (1e-20)
/*--------------------
 * gateway function
 --------------------*/

int sortDescending(const void *a, const void *b)
{
  double A = *(double *)a;
  double B = *(double *)b;
  
  if(A < B ) return 1;
  if(A > B)  return -1;
  
  return 0;
}



void mexFunction(
  int nOUT, mxArray *pOUT[],
  int nINP, const mxArray *pINP[])
{

  int N; /* the number of cells in the network */
  
  /* parameters (see MATLAB file for description) */

  int nSteps;
  int monitorStep;

  double dT;
  double tau;
  double G;
  double threshold;
  double fixAct;
  double Tadapt;
  double Kadapt;

  
  int adaptStep;
  double adaptInc;
  
 

  /* dynamic variables */

  double *J; /* the synaptic matrix */
  double *dirCell_x; /* the directional preference of each cell */
  double *dirCell_y;
  double *Vi; /* the activation variables */
  double *vRat_x, *vRat_y;	/* the instantaneous rat speed  */
  
  double *Vconf; /* the output history */
  
  double inhib; 		/* the global inhibition  */
  double Ci, CiM; 		/* moltiplicative factors for the
				   Wilson/Cowan equations */
  
  /* temporary variables */

  double **Va;
  double **Vadapt;
  double *A, *F, *Vs, *dirInp, *Viold, *Q;
  
  int *isActive; /* the index to the cells that are active, this
		    allows to avoid multiplication for all units that
		    are zero (which should be the majority */
  int nActive;
  

  int i, j, ns; 
  int monitorIx = 0; 		/* index in the monitor  */
  

  /**********************************************************/
  /* parsing the input                                      */
  /**********************************************************/
  FILE *log;
  log = fopen("debug.log", "w");
  

  if(nINP != 5 || nOUT != 1)
    mexErrMsgTxt("must have 5 inputs and 1 output");
  

  /* input 4 is the parameter structure */

  nSteps = (int)mxGetScalar(mxGetField(pINP[4], 0, "nSteps"));
  monitorStep = (int)mxGetScalar(mxGetField(pINP[4], 0, "monitorStep"));
  
  dT = mxGetScalar(mxGetField(pINP[4], 0, "dT"));
  tau = mxGetScalar(mxGetField(pINP[4], 0, "tau"));
  G = mxGetScalar(mxGetField(pINP[4], 0, "G"));  
  threshold = mxGetScalar(mxGetField(pINP[4], 0, "threshold"));     
  fixAct = mxGetScalar(mxGetField(pINP[4], 0, "fixAct"));
  Tadapt = mxGetScalar(mxGetField(pINP[4], 0, "Tadapt"));  
  Kadapt = mxGetScalar(mxGetField(pINP[4], 0, "Kadapt"));  

  
  /* input 0 is the synaptic matrix */

  N = mxGetM(pINP[0]);
  if(mxGetN(pINP[0]) != N)
    mexErrMsgTxt("J must be a square matrix");
  
  J = mxGetPr(pINP[0]);
  
  /* input 1 is dirCell */

  if(mxGetM(pINP[1]) != 2 || mxGetN(pINP[1]) != N)
    mexErrMsgTxt("dirCell must be 2 x N");

  dirCell_x = (double *)mxCalloc(N, sizeof(double));
  dirCell_y = (double *)mxCalloc(N, sizeof(double));
  
  
  {
    int i;
    double *pr;
    
    pr = mxGetPr(pINP[1]);
    

    for(i = 0; i < N; i++)
      {
	dirCell_x[i] = pr[2*i];
	dirCell_y[i] = pr[2*i+1];
      }
  }
  

  /* input 2 is Vi (get the initialization from outside) */

  if(mxGetM(pINP[2]) != N || mxGetN(pINP[2]) != 1)
    mexErrMsgTxt("Vi must be N x 1");
  
  Vi = mxGetPr(pINP[2]);
  

  /* input 3 is vRat */

  if(mxGetM(pINP[3]) != 2 || mxGetN(pINP[3]) != nSteps)
    mexErrMsgTxt("vRat must be 2 X nSteps");

  vRat_x = (double *)mxCalloc(nSteps, sizeof(double));
  vRat_y = (double *)mxCalloc(nSteps, sizeof(double));
  
  {
    int i;
    double *pr;
    
    pr = mxGetPr(pINP[3]);
    
    for(i = 0; i < nSteps; i++)
      {
	vRat_x[i] = pr[2*i];
	vRat_y[i] = pr[2*i+1];
      }
    
  }
  
	  
  fprintf(log,"End of parse input"); /* DEBUG */
  
  
  /* prepare output */


  pOUT[0] = mxCreateDoubleMatrix(N, (int)ceil((double)nSteps/monitorStep), mxREAL);
  Vconf = mxGetPr(pOUT[0]);
  
  
  /* initialization of the dynamics */

  Ci = exp(-dT/tau);
  CiM = 1 - Ci;
  adaptStep = (int)floor(Tadapt/dT);
  adaptInc = - Kadapt / (double)(adaptStep);
			 
  /* allocate temporary storage */

			 
  Va = (double **)mxCalloc(monitorStep, sizeof(double *));   /* the
			   store to compute instantaneous average 
			   (monitorStep x N)*/
  for(i = 0; i < monitorStep; i++)
    Va[i] = (double *)mxCalloc(N, sizeof(double));
  

  Vadapt = (double **)mxCalloc(adaptStep, sizeof(double *));   /* the
				   buffer to compute adaptation 
				   (adaptStep x N) */
  for(i = 0; i < adaptStep; i++)
    Vadapt[i] = (double *)mxCalloc(N, sizeof(double));
  
  A  = (double *)mxCalloc(N, sizeof(double));	   /* the
						      instantaneous
						      adaption  (N)*/   
  F  = (double *)mxCalloc(N, sizeof(double));	   /* the input to
						      each neuron (N) */ 
  Vs  = (double *)mxCalloc(N, sizeof(double));	   /* buffer for the
						      sorted list of
						      activities */ 
  
  dirInp  = (double *)mxCalloc(N, sizeof(double));  /* the directional
						       input */

  Viold = (double *)mxCalloc(N, sizeof(double));  /* to save previous state*/
  
  Q= (double *)mxCalloc(N, sizeof(double));  /* cumulative sum of
						input */

  isActive = (int *)mxCalloc(N, sizeof(int));  /* to save previous state*/

  fprintf(log,"Just Before dynamics\n"); /* DEBUG */
  

  

  /* the dynamics */ 




  
  for(ns = 0; ns < nSteps; ns++)
    {


      double  K = adaptInc;


      fprintf(log,"# = %d\n", ns); /* DEBUG */
      fprintf(log,"N = %d\n", N); /* DEBUG */
      
      /* compute adaptation, Vadapt is treated as a ring buffer */
      for(i = 0; i < N; i++) A[i] = 0.;
      
      fprintf(log,"0.9\n");
      
      int adaptPos = ns % adaptStep; /* adaptPos is the current position in the
					Vadapt ring buffer */ 
      for(i = (adaptPos+1) % adaptStep; i !=adaptPos; i++, i %=  adaptStep)
	{

	  
	  mxAssert(i >=0 && i <adaptStep, "Tadapt screwup");
	  
	  
	  for(j=0; j < N; j++)
	    A[j] += K * Vadapt[i][j];
	  K += adaptInc;
	}
      

      fprintf(log,"Directional input \n"); /* DEBUG */
      

      fprintf(log,"1.1\n"); 	/* DEBUG */
      
      /* compute directional input  as vRat \dot dirCell*/
      double vx = vRat_x[ns];
      double vy = vRat_y[ns];
      
      for(j = 0; j< N; j++)
	dirInp[j] = (vx * dirCell_x[j] + vy * dirCell_y[j]);
      
      fprintf(log,"1.2\n"); 	/* DEBUG */
      
      /* find which neurons are active */
      int na = 0;
      
      for(j =0; j < N ; j++)
	if(Vi[j] > EPSILON)
	    isActive[na++] = j;
/* 	    fprintf(log,"1.2.1: na = %d\n", na); */
	    


      fprintf(log,"1.3\n");
      
      nActive = na;

      fprintf(log,"Total input\n"); /* DEBUG */
      
      /* compute total ipnut and put it in A */
      for(j = 0; j < N; j++)
	A[j] +=dirInp[j];
      
      /* save yourself a few multiplications in the synaptic matrix
	 product */

      for(i = 0; i< N; i++)
	for(j = 0; j < nActive; j++)
	  A[i] += J_ELEM(i, isActive[j]) * Vi[j];

      /* compute activity without counting synaptic inhibition */
      
      double S = 0.;
      
      for(j = 0; j < N; j++)
	{
	  Viold[j] = Vi[j]; /* save current state */
	  Vi[j] = CiM * (A[j] > threshold ? G * (A[j] - threshold) : 0)
	    + Ci * Viold[j];  
	  Vs[j] = Vi[j]; /* to sort and compute inhibition */
	  S += Vi[i];
	}
      
      fprintf(log,"Inhibition\n"); /* DEBUG */
      

      /* compute the global inhibition, which is done with the "sort"
	 trick */
      qsort((void *)Vs, N, sizeof(double), sortDescending);
      
      /* cumulative sum of the input */
      for(j = 1; j < N; j++)
	Q[j] = Vs[j] + Vs[j-1];

      /* calculate inhibition */
      inhib = 0.;
      int ix = -1;
      
      for(j = 0; j < N; j++)
	{
	  Q[j] -= Vs[j] * (double) j;
	  if(Q[j] > N * fixAct)
	    {
	      ix = j;
	      break;
	    }
	}
      
      if(ix < 0 && S > N * fixAct)
	ix = N - 1;
      
      if(ix < 0)
	inhib = 0;
      else
	inhib = Vs[ix] / (G*CiM);
      
      for(j = 0; j < N; j++)
	Vi[j] = CiM * (A[j] -inhib > threshold ? 
		       G * (A[j] -inhib - threshold) : 0)
	  + Ci * Viold[j];  
      

      fprintf(log,"Save configuration\n"); /* DEBUG */
      
      /* save the configuration in the buffer */
      int ma = ns % monitorStep;
      
      mxAssert(adaptPos < adaptStep && adaptPos >= 0, "Tadapt screwup 2");
      
      
      double *ptr = Va[ma], *ptr1 = Vadapt[adaptPos]; 
      
      fprintf(log,"2.1\n"); 	/* DEBUG */
      fprintf(log,"2.1.1: monitorStep = %d ns = %d ma = %d\n", monitorStep, ns, ma); /* DEBUG */

      for(j = 0; j < N; j++) 
	{
	  ptr[j] = Vi[j];
	  ptr1[j] = Vi[j];

	}
      
      
      if(ma==0) /* save average instantaneous average activity in
		   output */
	{
	  ptr = Vconf + N * monitorIx;
	  for(i = 0; i < monitorStep; i++)
	    {
	      /* fprintf(log,"2.1.2: i =%d\n", i); /*  DEBUG */
	      
	    for(j = 0; j < N; j++) 
	      ptr[j] += Va[i][j];
	    }
	  
	  fprintf(log,"2.2\n");
	  
	  for(j = 0; j < N; j++) 
	    ptr[j] /= (double)monitorStep;
	  fprintf(log,"2.3\n");
	  
	  if(ns % 50 == 0)
	    {
	      double S = 0.;
	      for(j = 0; j < N; j++)
		S+= ptr[j];
	      S /= N;
	      
	      mexPrintf("step = %d\nS = %g\n\n\n", ns, S);
	    }
	  

	  monitorIx++;
	  
	}
   
      
      fflush(log);
      
    }
  
      
  


  fprintf(log, "3.0"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
  
      
  



  /* release memory */
  mxFree((void *) isActive);
  fprintf(log, "3.0.1"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
  
  mxFree((void *) Q);
  fprintf(log, "3.0.1"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
      
  mxFree((void *) Viold);
  fprintf(log, "3.0.2"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
  
  fprintf(log, "3.1"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */

  mxFree((void *)dirInp);
  fprintf(log, "3.1"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
  mxFree((void *)Vs);
  fprintf(log, "3.1"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
  mxFree((void *)F);
  fprintf(log, "3.1"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
  mxFree((void *)A);
  
  fprintf(log, "3.2"); 		/*  DEBUG */
  fflush(log); 			/* DEBUG */
  for(i = 0; i < adaptStep; i++)
    mxFree((void *)Vadapt[i]);
  mxFree((void *)Vadapt);
  
  fprintf(log, "3.3"); 		/*  DEBUG */
  for(i = 0; i < monitorStep; i++)
    mxFree((void *)Va[i]);
  mxFree((void *)Va);
  
  fflush(log);
  fprintf(log, "3.4"); 		/*  DEBUG */
  fflush(log);
  
  mxFree((void *)vRat_x);
  mxFree((void *)vRat_y);
  fprintf(log, "3.5"); 		/*  DEBUG */
  fflush(log);
  
  mxFree((void *)dirCell_x); 
  mxFree((void *)dirCell_y); 
    
  fprintf(log, "3.6"); 		/*  DEBUG */
  fflush(log);
  

  
}

  
	
