/* function ac = spaceAutoCorr(V, x, y, binSize, nBins, maxTimeLag) */

/* ac = spaceAutoCorr(V, x, y, binsize, nbins) */
/* returns a matrix with correlation of firing as a function of the  */
/* distance between the two points  */

/* INPUTS: */
/* V: a (nCellxnTimes) matrix of cell activities (continuous) */
/* x, y: two (1xnTimes) arrays of rat positions on the plane */
/* binSize: the linear size of the space bin   */
/* nBins: number of bins starting from center in the four directions (that is,  */
/*        the resulting matrix is (2*nBins+1 x 2*nBins+1)   */
/* maxTimeLag: the maximum time LAg of the pairs of points considered  */


/* copyright (c) 2004 Francesco P. Battaglia */
/* This software is released under the GNU GPL */
/* www.gnu.org/copyleft/gpl.html */

#include <matrix.h>
#include <mex.h>
#include <math.h>

inline int binning(double x, double binSize, int nBins)
{
  int r = (int)floor((x+binSize/2)/binSize) + nBins;
  if(r < 0 || r > 2 * nBins)
    r = -1;
  return r;
}


void mexFunction(int nOUT, mxArray *pOUT[], int nINP, const mxArray
                 *pINP[])
{

  int nCells, nTimes ;
  double *V, *x, *y, *ac;
  double binSize ;
  int nBins, maxTimeLag;

  /* dynamically allocated in the function */
  double **Sxy, **Sx, **S2x, **Sy, **S2y;
  int **N;
  
  

  int i, j;
  int max_j, min_j;
  


  if(nINP != 6)
    mexErrMsgTxt("Requires six inputs");
  
  if(nOUT != 1)
    mexErrMsgTxt("Requires one output");
  
  
  /* unpack inputs */

  /* input 0 is V */

  nCells = mxGetM(pINP[0]);
  nTimes = mxGetN(pINP[0]);
  
  if (nCells > 1)
    mexErrMsgTxt("V must be 1 x nTimes");
  
  
  V = mxGetPr(pINP[0]);

  /* input 1 is x */

  if(mxGetM(pINP[1]) != 1 && mxGetN(pINP[1]) != nTimes)
    mexErrMsgTxt("x must be a (1 x nTimes) vector");

  x = mxGetPr(pINP[1]);
  
  /* input 2 is y */

  if(mxGetM(pINP[2]) != 1 && mxGetN(pINP[2]) != nTimes)
    mexErrMsgTxt("y must be a (1 x nTimes) vector");

  y = mxGetPr(pINP[2]);
  
  /* input 3 is binSize */

  if(mxGetM(pINP[3]) * mxGetN(pINP[3]) != 1)
    mexErrMsgTxt("binSize must be a scalar");
  
  binSize = mxGetScalar(pINP[3]);
  

  /* input 4 is nBins */ 

  if(mxGetM(pINP[4]) * mxGetN(pINP[4]) != 1)
    mexErrMsgTxt("nBins must be a scalar");
  
  nBins = (int)mxGetScalar(pINP[4]);
  
  /* input 5 is maxTimeLag */

  if(mxGetM(pINP[5]) * mxGetN(pINP[5]) != 1)
    mexErrMsgTxt("maxTimeLag must be a scalar");

  maxTimeLag = (int)mxGetScalar(pINP[5]);

  


  /* prepare output */

  pOUT[0] = mxCreateNumericMatrix(2*nBins+1, 2*nBins+1, mxDOUBLE_CLASS, mxREAL);
  
  ac = mxGetPr(pOUT[0]);
  
  

  /* spit out some parameters */


  /* here's the action */


  /* dynamically allocated in the function */

 
  N = (int **)mxCalloc(2*nBins+1, sizeof(int *));
  for(i = 0; i < 2 * nBins + 1; i++)
    N[i] = (int *)mxCalloc(2*nBins+1, sizeof(int));
  
  Sxy = (double **)mxCalloc(2*nBins+1, sizeof(double *));
  Sx = (double **)mxCalloc(2*nBins+1, sizeof(double *));
  S2x = (double **)mxCalloc(2*nBins+1, sizeof(double *));
  Sy = (double **)mxCalloc(2*nBins+1, sizeof(double *));
  S2y = (double **)mxCalloc(2*nBins+1, sizeof(double *));
  
  for(i = 0; i < 2 * nBins + 1; i++)
    {
      Sxy[i] = (double *)mxCalloc(2*nBins+1, sizeof(double));
      Sx[i] = (double *)mxCalloc(2*nBins+1, sizeof(double));
      S2x[i] = (double *)mxCalloc(2*nBins+1, sizeof(double));
      Sy[i] = (double *)mxCalloc(2*nBins+1, sizeof(double));
      S2y[i] = (double *)mxCalloc(2*nBins+1, sizeof(double));
    }
  

  

  for (i = 0; i < nTimes; i++)
    {
      min_j = i - maxTimeLag;
      max_j = i + maxTimeLag + 1;
      min_j = (min_j < 0 ? 0 : min_j);
      max_j = (max_j > nTimes ? nTimes : max_j);
 
	
      
	  
      for(j = min_j; j < max_j; j++)
	{
	  int xBin = binning(x[i]-x[j], binSize, nBins);
	  int yBin = binning(y[i]-y[j], binSize, nBins);
	  if(xBin != -1 && yBin != -1)
	    {
	      N[xBin][yBin] += 1;
	      Sxy[xBin][yBin] += V[i] * V[j];
	      Sx[xBin][yBin] += V[i];
	      S2x[xBin][yBin] += V[i] * V[i];
	      Sy[xBin][yBin] += V[j];
	      S2y[xBin][yBin] += V[j] * V[j];
	      if(xBin < 0 || xBin > 2 * nBins || yBin < 0 || yBin > 2*nBins)
		mexErrMsgTxt("What the hell???");
	      
	      
	    }
	  
	}
    }
  

  for(i=0; i < 2 * nBins + 1; i ++)
    for(j=0; j < 2 * nBins + 1; j ++)
      {
	Sxy[i][j] /= N[i][j];
	Sx[i][j] /= N[i][j];
	S2x[i][j] /= N[i][j];
	Sy[i][j] /= N[i][j];
	S2y[i][j] /= N[i][j];
	ac[i + (2 * nBins + 1) * j] = (Sxy[i][j] - Sx[i][j]*Sy[i][j]) / 
	  sqrt((S2x[i][j] - Sx[i][j] * Sx[i][j]) * (S2y[i][j] - Sy[i][j] * Sy[i][j]));
	     
      }
  

  










  /****************************************************************/






  /* free memory */
  for(i = 0; i < 2 * nBins + 1; i++)
    {
      mxFree((void *)Sxy[i]);
      mxFree((void *)Sx[i]);
      mxFree((void *)S2x[i]);
      mxFree((void *)Sy[i]);
      mxFree((void *)S2y[i]);
      mxFree((void *)N[i]);
    }
  

  mxFree((void *)Sxy);
  mxFree((void *)Sx);
  mxFree((void *)S2x);
  mxFree((void *)Sy);
  mxFree((void *)S2y);
  mxFree((void *)N);
  

  
}
