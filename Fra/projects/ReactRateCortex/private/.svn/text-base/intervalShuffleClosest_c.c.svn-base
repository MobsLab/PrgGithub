/* intervalShuffle_c.c C implementation of the intervalShuffle function.
   inputs are:
   1: cellArray of timestamp arrays
   2: array of timestamps for starting times of intervals
   3: array of timestamps for end times of intervals

   outputs are:
   1: cellArray with the shuffled spike trains
*/  

/* copyright (c) 2004 Francesco P. Battaglia */
/* This software is released under the GNU GPL */
/* www.gnu.org/copyleft/gpl.html */

#include <matrix.h>
#include <mex.h>
#include <stdlib.h>
#include <math.h>

#define MEX_FUNCTION 1

#ifdef MEX_FUNCTION
#define calloc mxCalloc
#define free mxFree
#endif


int binsearch_closest(double *data, double key, int min_idx, int max_idx)
{
  
  int mid, start = min_idx, end = max_idx-1, result;
  while (start < (end-1))
    {
      mid = floor((start + end)/2);
      if ((key) == data[mid])
	start = end = mid;
      if ((key) < data[mid])
	end = mid;
      if ((key) > data[mid])
	start = mid;
    }
  if (((key) - data[start]) <= (data[end] - (key)))
    result = start;
  else 
    result = end;
  return result;
  
}


int compare_double(const void *pav, const void *pbv)
{
  const double *pa = (const double *)pav;
  const double *pb = (const double *)pbv;
  
  if((*pa) == (*pb))
    return 0;
  
  return ((*pa) < (*pb) ? -1 : 1);
}






struct perm_str 
{
  double l;
  int ix;
};

int compare_perm_str(const void *pav,  const void *pbv)
{
  
  const struct perm_str *pa = (const struct perm_str *)pav;
  const struct perm_str *pb = (const struct perm_str *)pbv;
  

  if(pa->l == pb->l)
    return 0;
  
  return (pa->l < pb->l ? -1 : 1);
  
}

  
/* function that returns a random permutation of the integers from 0
   to n-1 in the array  pointed by *idx_pr (memory should be allocated
   by caller  
*/
  


void random_perm(int n, int **idx_pr)
{
  int i;
  int *idx;
  
  struct perm_str *p_pr;
  

  idx = *idx_pr;
  

  
  p_pr = calloc(n, sizeof(struct perm_str));
  
  for( i = 0; i < n; i++)
    {
      p_pr[i].l = drand48();
      p_pr[i].ix = i;
    }
  
  qsort(p_pr, n, sizeof(struct perm_str), compare_perm_str);
  
  for(i = 0; i < n; i++)
    idx[i] = p_pr[i].ix;

  free(p_pr);
  
}






void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray
                 *prhs[])
{

   
  int n_points, n_intervals, n_trains;
  double *t, *t0, *t1, *oo;
  double *to;
  
  int i, i1, n;

  int nc;
  int f, g;
  

  int *shuffle_idx;
  
  int *ix_first, *ix_last;
  int n_sh = 2;
  
  mxArray  *T, *TO, *OO;
  const mxArray *C;


  if(nrhs != 3)
    mexErrMsgTxt("Requires three inputs");
  
  if(nlhs != 1 && nlhs != 2)
    mexErrMsgTxt("Requires one or two  output");
  
  
  
  /* unpack inputs */

  /* input 0 is t */
  if(!mxIsCell(prhs[0]))
    mexErrMsgTxt("C = must be a cell array");
  

  if(mxGetM(prhs[0]) != 1 && mxGetN(prhs[0]) != 1)
    mexErrMsgTxt("C must be a row or column vector");
  

  n_trains = mxGetM(prhs[0]) * mxGetN(prhs[0]);
  C = prhs[0];
  
  
  /* validate all spike trains */
  for(i = 0; i < n_trains; i++)
    {
      T = mxGetCell(C, i);
      if(mxGetM(T) != 1 && mxGetN(T) != 1)
	mexErrMsgTxt("Each spike train must be a row or column vector");
      
    }
  

  
  



  /* input 1 is t0 */

  if(mxGetM(prhs[1]) != 1 && mxGetN(prhs[1]) != 1)
    mexErrMsgTxt("t0 must be a row or column vector");
  
   n_intervals = mxGetM(prhs[1]) * mxGetN(prhs[1]);

  t0 = mxGetPr(prhs[1]);
  
  /* input 2 is t1 */

  if(mxGetM(prhs[2]) != 1 && mxGetN(prhs[2]) != 1)
    mexErrMsgTxt("t1 must be a row or column vector");

  if(mxGetM(prhs[2]) != mxGetM(prhs[2]) || mxGetN(prhs[2]) != mxGetN(prhs[2]))
    mexErrMsgTxt("t1 and t0 must have same size");
  
  t1 = mxGetPr(prhs[2]);
  


  /* sanity check on the intervals */

  for(i = 0; i < n_intervals; i++)
    if(t1[i] < t0[i])
      mexErrMsgTxt("t1 must be greater than t0");
  
  

  /* prepare output */
  {
    int dims[2];
    dims[0] = n_trains;
    dims[1] = 1;
    plhs[0] = mxCreateCellArray(2, dims);
    plhs[1] = mxCreateCellArray(2, dims);
  }
  


  
      


  /* do the computation */

  /* allocate working space */

  
  ix_first = mxCalloc(n_intervals, sizeof(int));
  ix_last = mxCalloc(n_intervals, sizeof(int));
  shuffle_idx = mxCalloc(n_intervals, sizeof(int));

	

  
  /* bail out if intervals vector is empty */
  if(n_intervals == 0)
    {  
      for(nc = 0; nc < n_trains; nc++)
	{
	  
	  TO = mxCreateDoubleMatrix(0, 1, mxREAL);
	  mxSetCell(plhs[0], nc, TO);
	  if(nlhs > 1)
	    {
	      TO = mxCreateDoubleMatrix(0, 1, mxREAL);
	      mxSetCell(plhs[1], nc, OO);
	    }
	}
      

      
      
      goto free_all;
    }


  


  /* span all trains in cell array */

  for(nc = 0; nc < n_trains; nc++)
    {
      /* prepare random permutation */
      random_perm(n_intervals, &shuffle_idx);  


      

      /* get data */
      T = mxGetCell(C, nc);
      n_points = mxGetM(T) * mxGetN(T);
      

      t = mxGetPr(T);

      /* prepare output */
      TO = mxCreateDoubleMatrix(n_points, 1, mxREAL);
      to = mxGetPr(TO);
      if(nlhs > 1)
	{
	  OO = mxCreateDoubleMatrix(n_points, 1, mxREAL);
	  oo = mxGetPr(OO);
	}

      

      
      /* initialize ix */
      for(i = 0; i < n_intervals; i++)
	{
	  ix_first[i] = 0;
	  ix_last[i] = 0;
	}
      
      /* align  spike trains with intervals */

      i = 0;
      i1 = 0;
      
      n = 0;
  
      while(i < n_points)
	{
	  i = i1; /* initialize search for new interval */
	  
	  while(i < n_points && t[i] < t0[n]) /* search beginning of interval */
	    i++;
	  i1 = i;
	  ix_first[n] = i;
	  
 
	  while(i < n_points && t[i] < t1[n])
	    {
	      i++;

	    }
	  ix_last[n] = i;
      

	  n++;
	  if(n >= n_intervals)
	    break;
      
	}

      
      for(; n < n_intervals; n++)
	{
	  ix_first[n] = n_points + 1;
	  ix_last[n] = n_points + 2;
	}
      
	    
	      

/* 	} */
      

      /* now do the actual shuffling */

      f = 0; /* first interval we're in at the moment */
      g = 0; /* one past the last interval we're in at the moment */
       

      for(i = 0; i < n_points; i++)
	{
	  
/* 	  mexPrintf("### 1\n"); /\* debug *\/ */
	  
	  while(g < n_intervals-2 && i >= ix_first[g])
	    g++;
	  

	  
	  
	  

	  while(f < n_intervals-2 && i >= ix_last[f])
	    f++;

	  
/* 	  mexPrintf("### 2\n"); /\* debug *\/ */
	  
	  
	  if(f == g) /* we're outside all intervals, so don't shuffle */
	    to[i] = t[i];
	  else
	    {
	      double t_r;
	      
	      int ix, ix1;

	      t_r = 10000 + t0[0] + (t0[n_intervals-1]-t0[0]) * drand48();
	      
	      ix = f + floor((g-f) * drand48());
/* 	      ix = binsearch_closest(t0, t[i]-100000, 0, n_intervals-1); */
	      
/* 	      ix1 = binsearch_closest(t0, t_r-100000, 0, n_intervals-1); */
	      ix1 = ix - n_sh + floor((2*n_sh+1) * drand48());
	      

	      to[i] = t[i] - t0[ix] + t0[ix1];
	      if(nlhs > 1)
		oo[i] = t[i] - t0[ix];
	      
	      
	      if(t[i] - t0[ix] < 0 || t[i] - t0[ix] > 200000)
		mexPrintf("i = %d t[i] = %g\nf = %d, ix_last[f]= %d, g = %d ix_first[g] = %d\nix = %d t0[ix] = %g\n\n", i, t[i], f, ix_last[f], g, ix_first[g], ix, t0[ix]);
	      

	    }
/* 	  mexPrintf("### 3\n"); /\* debug *\/ */
	  

	}
      
      qsort(to, n_points, sizeof(double), compare_double);
      


      mxSetCell(plhs[0], nc, TO);
      if(nlhs > 1)
	mxSetCell(plhs[1], nc, OO);
    }
  

 free_all:
  mxFree(shuffle_idx);
  mxFree(ix_first);
  mxFree(ix_last);
  
  
}
