/*---------------------------------
* ReadCR_nt    
* Read a CR file from Cheetah (NT Version only)
*
* Sept 2000: Updated to handle automatically the new header in Cheetah_NT versions greater 
* or equal than 1.3
*
* MEX file
*
*
* input:
*    fn = file name string
* 
* output:
*    [t, cr, SampFreq]
*    t = n x 1: timestamp of each CR Record in file
*    cr = n x 512   one CR record of 512 ADC samples
*    SampFreq = 1 x 1 common Sampling Freqency of CR data (Hz) 
*
* version 2.1
* PL Sept 2000
--------------------------------*/

#include "mex.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <matrix.h>


#ifdef __GNUC__
#define __int64 long long 
#endif


//___________________________________________________________________________________
int SkipCheetahNTHeader(FILE *fp)
{
	// Cheetah NT versions 1.3 or greater have a standard Neuralynx header of ascii strings of total
	// length of 16384 bytes in the beginning of the binary file. 
	// Check if Cheetah header present (in versions > 1.3) and skip header
	//
	// returns 1 if new Neuralynx header is present and was skipped
	//         0 if NO  header is present

    char headerflag[8];   // if first 8 bytes of AnyCheetahfile.dat contain "########" there is a header 
                          // of length 16,384 bytes to skip (from the very beginning including the eight '#') 
    const int NHEADERBYTES = 16384;	
	
	fread(headerflag, sizeof(char), 8, fp);  
	//mexPrintf("Headerflag =  %8s \n", headerflag);
    fseek(fp,0,0);       // reset filepointer to the beginning of file
	if (strncmp(headerflag,"########",8) == 0){
		fseek(fp,NHEADERBYTES,0);  // set filepointer after byte NHEADERBYTES
	    mexPrintf("NT-Header skipped (%d bytes)\n",NHEADERBYTES);
		return 1;
	} 
	return 0;
}

//___________________________________________________________________________________
int SkipHeader(FILE *fp)
{
	/* returns 0 if header present and skipped  (success) 
	**         1 if NO header present in file (indicates a new NT_cheetah TT file) */
	long curpos = ftell(fp);
	char headerline[81];

	fgets(headerline, 80, fp);
	if (strncmp(headerline, "%%BEGINHEADER", 13) == 0){
		while (strncmp(headerline, "%%ENDHEADER",11) != 0)
			fgets(headerline, 80, fp);
		return 0;
	} else {
		fseek(fp, curpos, SEEK_SET);
		return 1;
	}
}

//___________________________________________________________________________________
int bigendianMachine(void)
{
	/* returns 0 if is a littleendian machine, else returns nonzero */
	/* key is that it looks to see if short's second byte is the low order bits */
	short fullLoByte = 0xFF;
	char *byteOrder = (char *) &fullLoByte;
	return (byteOrder[1]);	
}


//___________________________________________________________________________________
inline short swapbytes(short ii)
// swap byte order of a short: (0,1) -> (1,0)
{
	union {
		short s;
		char c[2];
	} tmp0,tmp;
	
	tmp.s = ii;
	tmp0.c[0] = tmp.c[1];					
	tmp0.c[1] = tmp.c[0];

	return tmp0.s;
}

//___________________________________________________________________________________
inline unsigned long swapbytes(unsigned long ii)
// swap byte order of an unsigned long: (0,1,2,3) -> (3,2,1,0)
{
	union {
		unsigned long ul;
		char c[4];
	} tmp0,tmp;
	
	tmp.ul = ii;
	tmp0.c[0] = tmp.c[3];					
	tmp0.c[1] = tmp.c[2];
	tmp0.c[2] = tmp.c[1];					
	tmp0.c[3] = tmp.c[0];

	return tmp0.ul;
}

//___________________________________________________________________________________
inline long swapbytes(long ii)
// swap byte order of a long: (0,1,2,3) -> (3,2,1,0)
{
	union {
		long l;
		char c[4];
	} tmp0,tmp;
	
	tmp.l = ii;
	tmp0.c[0] = tmp.c[3];					
	tmp0.c[1] = tmp.c[2];
	tmp0.c[2] = tmp.c[1];					
	tmp0.c[3] = tmp.c[0];

	return tmp0.l;
}

//___________________________________________________________________________________
inline __int64 swapbytes(__int64 ii)
// swap byte order of a long long: (0,1,2,3,4,5,6,7) -> (7,6,5,4,3,2,1,0)
{
	union {
		__int64 ll;
		char c[8];
	} tmp0,tmp;
	
	tmp.ll = ii;
	tmp0.c[0] = tmp.c[7];					
	tmp0.c[1] = tmp.c[6];
	tmp0.c[2] = tmp.c[5];					
	tmp0.c[3] = tmp.c[4];
	tmp0.c[4] = tmp.c[3];					
	tmp0.c[5] = tmp.c[2];
	tmp0.c[6] = tmp.c[1];					
	tmp0.c[7] = tmp.c[0];

	return tmp0.ll;
}


//___________________________________________________________________________________
void mexFunction(int nOUT, mxArray *pOUT[],
					  int nINP, const mxArray *pINP[])
{
#ifdef __GNUC__
	const long long  TIMESTAMP_MAX = 0x00FFFFFFFFFFFFFFLL;  //( = 2^52-1; the largest integer fitting
#else
	const __int64 TIMESTAMP_MAX = 0x00FFFFFFFFFFFFFF;  //( = 2^52-1; the largest integer fitting
#endif
	int errorstatus;
	int bigendianFlag = bigendianMachine();
	long postHeaderPos, endPos;
	int fnlen;
	int new_NT_format;     /* flag for new NT_format TT files (0=old SUN, 1=new NT)  */
	char *fn;
	FILE *fp;
	int nSamples = 0;      /* to be implemented later */
	int nRecords;
	const int NEW_CR_RECSIZE = 8+sizeof(int)+2*sizeof(long)+512*sizeof(short);
	__int64 qwTimeStamp;
	unsigned long dwChannelNum;
	unsigned long dwSampleFreq;
	unsigned long dwNumValidSamples;
	signed short snSamples[512];
	unsigned long junk = 0; 
	double *t;
	double *cr;
	double sampFreq, sampFreq0 = 0.0; 
   double *crptr;
   int crDims[] = {nSamples, 512};
	int subs[] = {0, 0};
	int index; 
	int i,j,k;  /* counters */
	
			
			
	/* check number of arguments: expects 1 input */
	if (nINP != 1)
		mexErrMsgTxt("Call with fn as inputs.");
	if (nOUT != 3)
		mexErrMsgTxt("Requires three outputs (t, cr, SampFreq).");
	
	/* read inputs */
	fnlen = (mxGetM(pINP[0]) * mxGetN(pINP[0])) + 1;
	fn = (char *) mxCalloc(fnlen, sizeof(char)); 
	if (!fn)
		mexErrMsgTxt("Not enough heap space to hold converted string.");
	errorstatus = mxGetString(pINP[0], fn,fnlen);    
	if (errorstatus)
		mexErrMsgTxt("Could not convert string data.");
	
	/* open file */
	fp = fopen(fn, "rb");
	if (!fp)
		mexErrMsgTxt("Could not open file.");
	
	/* skip header */
	new_NT_format = SkipHeader(fp);
	SkipCheetahNTHeader(fp);     // Skip standard Neuralynx header if present (Cheetah versions >= 1.3)
	postHeaderPos = ftell(fp);
	
	if (new_NT_format){ 
		
		/* count number of Records */
		fseek(fp, 0, SEEK_END);	
		endPos = ftell(fp);
		nRecords = (int)floor((endPos - postHeaderPos) / NEW_CR_RECSIZE);
		nRecords = nRecords;    /* skip last record since it may be incomplete */
		printf("nRecords = %d\n", nRecords);
		if (nSamples == 0 || nSamples > nRecords) nSamples = nRecords;
		mexPrintf("Reading %d CR records.\n", nSamples);
		t = (double *) mxCalloc(nSamples, sizeof(double));
		cr = (double *) mxCalloc(nSamples * 512, sizeof(double));
		if (!t || !cr)
			mexErrMsgTxt("Not enough heap space for TT components.");
		
		/* read records and convert all to double*/
		fseek(fp, postHeaderPos, SEEK_SET);
		for (i = 0; i < nSamples; i++)
		{
	
			fread(&qwTimeStamp,  sizeof(__int64),   1, fp);
			fread(&dwChannelNum, sizeof(long),   1, fp);
			fread(&dwSampleFreq, sizeof(long),   1, fp);
			fread(&dwNumValidSamples, sizeof(long), 1, fp);
			fread(snSamples, sizeof(short), 512, fp);
			/* fread(&junk,sizeof(long),1,fp); */
			
			if(bigendianFlag){
			// convert from NT(little endian) to Sun (big endian)
				qwTimeStamp = swapbytes(qwTimeStamp);
				if(qwTimeStamp > TIMESTAMP_MAX){
					mexPrintf(" ERROR: timestamp %d in file %s is too large to fit in a double!\n",i,fn);
					mexPrintf(" Converted timestamps MAY or MAY NOT be valid - proceed with care! \n");
				}
				dwChannelNum = swapbytes(dwChannelNum);
				dwSampleFreq = swapbytes(dwSampleFreq);
				dwNumValidSamples = swapbytes(dwNumValidSamples);
				for (j = 0; j<512; j++)
					snSamples[j] = swapbytes(snSamples[j]);
			}

			sampFreq = (double) dwSampleFreq;
			if (i>0 && sampFreq != sampFreq0){ 
			   mexPrintf("New Warning: Sampling Frequency changed from %e to %e within file!!\n", 
			   sampFreq0,sampFreq);   
				sampFreq0 = sampFreq;
			}
			if (i<1) {
				sampFreq0 = sampFreq;
				mexPrintf("ts[%d]= %g \n", i,(double)qwTimeStamp/100.0);  
				mexPrintf("ChanNum[%d]= %d \n", i,dwChannelNum);  
				mexPrintf("sampFreq[%d]= %d \n", i,dwSampleFreq);  
				mexPrintf("dwNumValid[%d] = %d\n", i,dwNumValidSamples);  
				/* mexPrintf("junk[%d] = %d\n", i,junk);  */
				mexPrintf("Sampling Frequency in %s is %g !!\n", 
					fn,sampFreq);  
				/* for (j=0;j<32;j++){
				     mexPrintf("dd[%d*16]=",j);
					  for(k=0;k<16;k++) mexPrintf(" %d",snSamples[j*16+k]);
					  mexPrintf("\n");
				 } */
			}

			t[i] = (double) qwTimeStamp/100.0;
			for (j = 0; j<512; j++)
				if(j < (int)dwNumValidSamples)
					cr[j + 512 * i] = (double) snSamples[j];
				else
					cr[j + 512 * i] = 0.0;
		}
		
		
	} else {    /*  OLD sun cheetah format */
		
		mexErrMsgTxt("ReadCR_nt can't read old SUN Cheetah EEG files (yet)!!");
		
	}
	
	/* create outputs */
	pOUT[0] = mxCreateDoubleMatrix(nSamples, 1, mxREAL);
	memcpy(mxGetPr(pOUT[0]), t, nSamples * sizeof(double));
	mxFree(t);
	
	crDims[0]= nSamples;
	crDims[1]= 512;
	pOUT[1] = mxCreateNumericArray(2, crDims, mxDOUBLE_CLASS, mxREAL);
	crptr = mxGetPr(pOUT[1]);
	for ( k =0, i = 0; i<nSamples; i++){
		for (j = 0; j < 512; j++, k++){
			subs[0] = i; subs[1] = j;
			index = mxCalcSingleSubscript(pOUT[1], 2, subs);  
			crptr[index] = cr[k];
		}
	}
	mxFree(cr);
	
	pOUT[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
	memcpy(mxGetPr(pOUT[2]), &sampFreq, sizeof(double));
	
	mxFree(fn);
	
	fclose(fp);
	
}