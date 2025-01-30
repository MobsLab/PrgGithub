#include <math.h>
#include "mex.h"




void mexFunction(int nOUT, mxArray *pOUT[], int nINP, const mxArray *pINP[])
{
  double m, *pr;
  int i, j;
  

  mxArray *lhs[2], *x;
  
  lhs[0] = mxCreateDoubleMatrix(1, 100, mxREAL);
  pr = mxGetPr(lhs[0]);
  

  for(i = 0; i < 100; i++)
    pr[i] = (double)i * 0.25;
  
  mexCallMATLAB(1, &lhs[1], 1, lhs, "sin");
  

  mexCallMATLAB(0, NULL, 2, lhs, "plot");
  
  mxDestroyArray(lhs[0]);
  mxDestroyArray(lhs[1]);
  







}
