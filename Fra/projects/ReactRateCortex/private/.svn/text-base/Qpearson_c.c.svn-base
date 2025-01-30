/*************************************************
 *  Qpearson_c.c C core for the Qpearson routine. 
 *  Computes the pearson correlation between a prototype vector and
 *  each row in a matrix, returns a column vector of pearson
 *  coefficients
 * 
 * % copyright (c) 2004 Francesco P. Battaglia
 * % This software is released under the GNU GPL
 * % www.gnu.org/copyleft/gpl.html
 ******************************************************************/




#include <math.h>
#include <mex.h>
#include <matrix.h>





/*--------------------
 * gateway function
 --------------------*/

void mexFunction(
  int nOUT, mxArray *pOUT[],
  int nINP, const mxArray *pINP[])
{
  
  int n_cells;
  int n_times;
  
  const mxArray *Q_mx;
  double *q;
  double *q_row;
  double *proto;
  double *r;
  

  int i, j;
  int subs[2];
  
  double r12, r1, r2, r11, r22;
  int N;
  

  /* check number of arguments: expects 6 inputs, 1 output */
  if (nINP != 2)
    mexErrMsgTxt("Call with Q, prototype as inputs");
  if (nOUT != 1)
    mexErrMsgTxt("Requires one output.");

  /* check validity of inputs */

  /* input 0 is the q matrix: n_cells X n_times */
  n_times = mxGetN(pINP[0]);
  n_cells = mxGetM(pINP[0]);
  Q_mx = pINP[0];
  q = mxGetPr(Q_mx);
  

  /* input 1 is the prototype vector: n_cells X 1 */

  if(mxGetM(pINP[1]) != n_cells || mxGetN(pINP[1]) != 1)
    mexErrMsgTxt("prototype must be a n_cells X 1 vector");
  
  proto = mxGetPr(pINP[1]);
  

  /* prepare output */

  pOUT[0] = mxCreateDoubleMatrix(n_times, 1, mxREAL);
  r = mxGetPr(pOUT[0]);
  
  

  /* perform computations */

  


  /* compute quantities for q, and crossed */

  for(i = 0; i < n_times; i++)
    {
      subs[0] = 0;
      subs[1] = i;
      
      q_row = q + mxCalcSingleSubscript(Q_mx, 2, subs);
      
      r1 = 0;
      r11 = 0;
      r12 = 0;
      r2 = 0;
      r22 = 0;
      N = 0;
      
      
      for(j = 0; j < n_cells; j++)
	{
	  double qt = q_row[j];
	  double rt = proto[j];
	  
	  if(mxIsFinite(qt * rt)) /* Pearson coefficient is only
				    computed for cells with finite q-value */
	    {
	      N++;
	      r12 += qt * rt;
	      r1 += qt;
	      r2 += rt;
	      r11 += qt * qt;
	      r22 += rt * rt;
	    }
	}
      
      if(N==0) 
	mexErrMsgTxt("N is 0");
      

      r12 /= N;
      r11 /= N;
      r1 /= N;
      r22 /= N;
      r2 /= N;
      

      r[i] = (r12 - r1* r2) / sqrt((r22 - r2 * r2) * (r11 - r1 * r1));
/*       if(!mxIsFinite(r[i])) */
/* 	{ */
/* 	  char err_msg[80]; */
/* 	  mexPrintf("r12 = %g\nr1 = %g\nr11 = %g\nr2 = %g\nr22 = %g\nn = %d\n", */
/* 		    r12, r1, r11, r2, r22, N); */
/* 	  for(j = 0; j < n_cells; j++) */
/* 	    mexPrintf("r[%d] = %g\n", j, q_row[j]); */
	  
/* 	  sprintf(err_msg, "r[i] is not finite at i = %d", i); */
	  
/* 	  mexErrMsgTxt(err_msg); */
/* 	} */
      if(!mxIsFinite(r[i]))
	r[i] = 0;
      
      
    }
  

  
  
}


	  
