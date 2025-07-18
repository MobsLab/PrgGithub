/*
 * @(#)mex.h    generated by: makeheader 5.1.3  Thu Jan 11 15:15:54 2007
 *
 *		built from:	../../src/include/copyright.h
 *				../../src/include/pragma_interface.h
 *				mex_typedefs.h
 *				./fmexapi.cpp
 *				./fmexapi_stdcall.cpp
 *				./fmexapiv5.cpp
 *				./globals.cpp
 *				./mexapi.cpp
 *				./mexapiv4.cpp
 *				./mexapiv5.cpp
 *				./mexcbk.cpp
 *				./mexdispatch.cpp
 *				./mexintrf.cpp
 *				mexdbg.h
 */

#if defined(_MSC_VER) || __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ > 3)
#pragma once
#endif

#ifndef mex_h
#define mex_h


/*
 * Copyright 1984-2003 The MathWorks, Inc.
 * All Rights Reserved.
 */



/* Copyright 2003-2004 The MathWorks, Inc. */

/* Only define EXTERN_C if it hasn't been defined already. This allows
 * individual modules to have more control over managing their exports.
 */
#ifndef EXTERN_C

#ifdef __cplusplus
  #define EXTERN_C extern "C"
#else
  #define EXTERN_C extern
#endif

#endif


/* Copyright 1999-2001 The MathWorks, Inc. */

/* $Revision: 1.7.4.1 $ */
#ifndef mex_typedefs_h
#define mex_typedefs_h
typedef struct impl_info_tag *MEX_impl_info;

#include "matrix.h"

typedef struct mexGlobalTableEntry_Tag
{
    const char *name;             /* The name of the global */
    mxArray    **variable;        /* A pointer to the variable */ 
} mexGlobalTableEntry, *mexGlobalTable;

#if defined(MSWIND)
#define cicompare(s1,s2) utStrcmpi((s1),(s2))
#else
#define cicompare(s1,s2) strcmp((s1),(s2))
#endif
#define cscompare(s1,s2) strcmp((s1),(s2))

typedef struct mexFunctionTableEntry_tag {
  const char *  name;
  mxFunctionPtr f;
  int           nargin;
  int           nargout;
  struct _mexLocalFunctionTable *local_function_table;
} mexFunctionTableEntry, *mexFunctionTable;

typedef struct _mexLocalFunctionTable {
  size_t           length;
  mexFunctionTable entries;
} _mexLocalFunctionTable, *mexLocalFunctionTable;

typedef struct {
  void (*initialize)(void);
  void (*terminate)(void);
} _mexInitTermTableEntry, *mexInitTermTableEntry;

#define MEX_INFORMATION_VERSION 1

typedef struct {
  int                   version;
  int                   file_function_table_length;
  mexFunctionTable      file_function_table;
  int                   global_variable_table_length;
  mexGlobalTable        global_variable_table;
  int                   npaths;
  const char **         paths;
  int                   init_term_table_length;
  mexInitTermTableEntry init_term_table;
} _mex_information, *mex_information;

typedef mex_information(*fn_mex_file)(void);

typedef void (*fn_clean_up_after_error)(void);
typedef const char *(*fn_simple_function_to_string)(mxFunctionPtr f);

typedef void (*fn_mex_enter_mex_library)(mex_information x);
typedef fn_mex_enter_mex_library fn_mex_exit_mex_library;

typedef mexLocalFunctionTable (*fn_mex_get_local_function_table)(void);
typedef mexLocalFunctionTable (*fn_mex_set_local_function_table)(mexLocalFunctionTable);

#endif


/*
 * This header file "mex.h" declares all the types, macros and
 * functions necessary to interface mex files with the current
 * version of MATLAB.  See the release notes for information on 
 * supporting syntax from earlier versions.
 */  
#include "matrix.h"

#include <stdio.h>



/*
 * mexFunction is the user-defined C routine that is called upon invocation
 * of a MEX-function.
 */
EXTERN_C void mexFunction(
    int           nlhs,           /* number of expected outputs */
    mxArray       *plhs[],        /* array of pointers to output arguments */
    int           nrhs,           /* number of inputs */
    const mxArray *prhs[]         /* array of pointers to input arguments */
);


/*
 * Issue error message and return to MATLAB prompt
 */
EXTERN_C void mexErrMsgTxt(
    const char	*error_msg	/* string with error message */
    );


/*
 * Issue formatted error message with corresponding error identifier and return to MATLAB
 * prompt.
 */
EXTERN_C void mexErrMsgIdAndTxt(
    const char * identifier, /* string with error message identifier */
    const char * err_msg,    /* string with error message printf-style format */
    ...                      /* any additional arguments */
    );


/*
 * Invoke an unidentified warning. Such warnings can only be affected by the M-code
 * 'warning * all', since they have no specific identifier. See also mexWarnMsgIdAndTxt.
 */
EXTERN_C void mexWarnMsgTxt(
    const char	*warn_msg	/* string with warning message */
    );


/*
 * Invoke a warning with message identifier 'identifier' and message derived from 'fmt' and
 * subsequent arguments. The warning may either get printed as is (if it is set to 'on'), or
 * not actually get printed (if set to 'off'). See 'help warning' in MATLAB for more
 * details.
 */
EXTERN_C void mexWarnMsgIdAndTxt(
    const char * identifier,    /* string with warning message identifer */
    const char * warn_msg,	/* string with warning message printf-style format */
    ...                         /* any additional arguments */
    );


/*
 * mex equivalent to MATLAB's "disp" function
 */
EXTERN_C int mexPrintf(
    const char	*fmt,	/* printf style format */
    ...				/* any additional arguments */
    );


#define printf mexPrintf


/*
 * Remove all components of an array plus the array header itself
 * from MATLAB's memory allocation list.  The array will now
 * persist between calls to the mex function.  To destroy this
 * array, you will need to explicitly call mxDestroyArray().
 */
EXTERN_C void mexMakeArrayPersistent(
    mxArray *pa              /* pointer to array */
    );


/*
 * Remove memory previously allocated via mxCalloc from MATLAB's
 * memory allocation list.  To free this memory, you will need to
 * explicitly call mxFree().
 */
EXTERN_C void mexMakeMemoryPersistent(void *ptr);


/*
 * mex equivalent to MATLAB's "set" function
 */
EXTERN_C int mexSet(double handle, const char *property, mxArray *value);


/* API interface which mimics the "get" function */
EXTERN_C const mxArray *mexGet(double handle, const char *property);


/*
 * call MATLAB function
 */
EXTERN_C int mexCallMATLAB(
    int		nlhs,			/* number of expected outputs */
    mxArray	*plhs[],		/* pointer array to outputs */
    int		nrhs,			/* number of inputs */
    mxArray	*prhs[],		/* pointer array to inputs */
    const char	*fcn_name		/* name of function to execute */
    );


/*
 * set or clear mexCallMATLAB trap flag (if set then an error in  
 * mexCallMATLAB is caught and mexCallMATLAB will return a status value, 
 * if not set an error will cause control to revert to MATLAB)
 */
EXTERN_C void mexSetTrapFlag(int flag);


/*
 * Print an assertion-style error message and return control to the
 * MATLAB command line.
 */ 
EXTERN_C void mexPrintAssertion(
		const char *test, 
		const char *fname, 
		int linenum, 
		const char *message);


/*
 * Tell whether or not a mxArray is in MATLAB's global workspace.
 */
EXTERN_C bool mexIsGlobal(const mxArray *pA);


#define mexGetGlobal()    mexGetGlobal_is_obsolete
#define mxSetString()     mxSetString_is_obsolete
#define mxSetDispMode()   mxSetDispMode_is_obsolete
#define mexGetMatrixPtr() mexGetMatrixPtr_is_obsolete
#define mexGetMatrix()    mexGetMatrix_is_obsolete
#define mexPutMatrix()    mexPutMatrix_is_obsolete
#define mexPutFull()      mexPutFull_is_obsolete
#define mexGetFull()      mexGetFull_is_obsolete
#define mexGetEps()       mexGetEps_is_obsolete
#define mexGetInf()       mexGetInf_is_obsolete
#define mexGetNaN()       mexGetNaN_is_obsolete
#define mexIsFinite()     mexIsFinite_is_obsolete
#define mexIsInf()        mexIsInf_is_obsolete
#define mexIsNaN()        mexIsNaN_is_obsolete


/*
 * mexAddFlops is no longer allowed.  
 */
#define mexAddFlops(x) mexAddFlops_is_obsolete

#if defined(V5_COMPAT)
#define mexPutArray(parray, workspace) mexPutVariable(workspace, mxGetName(parray), parray)
#define mexGetArray(name, workspace) mexGetVariable(workspace, name)
#define mexGetArrayPtr(name, workspace) mexGetVariablePtr(workspace, name)
#else
#define mexPutArray() mexPutArray_is_obsolete
#define mexGetArray() mexGetArray_is_obsolete
#define mexGetArrayPtr() mexGetArrayPtr_is_obsolete
#endif /* defined(V5_COMPAT) */


/*
 * Place a copy of the array value into the specified workspace with the
 * specified name
 */
EXTERN_C int mexPutVariable(
    const char *workspace,
    const char *name,
    const mxArray *parray		/* matrix to copy */
    );


/*
 * return a pointer to the array value with the specified variable
 * name in the specified workspace
 */
EXTERN_C const mxArray *mexGetVariablePtr(
    const char *workspace,
    const char *name		/* name of symbol */
    );


/*
 * return a copy of the array value with the specified variable
 * name in the specified workspace
 */
EXTERN_C mxArray *mexGetVariable(
    const char	*workspace,		
    const char  *name                /* name of variable in question */
    );


/*
 * Lock a MEX-function so that it cannot be cleared from memory.
 */
EXTERN_C void mexLock(void);


/*
 * Unlock a locked MEX-function so that it can be cleared from memory.
 */
EXTERN_C void mexUnlock(void);


/*
 * Return true if the MEX-function is currently locked, false otherwise.
 */
EXTERN_C bool mexIsLocked(void);


/*
 * Return the name of a the MEXfunction currently executing.
 */
EXTERN_C const char *mexFunctionName(void);


/*
 * Parse and execute MATLAB syntax in string.  Returns zero if successful,
 * and a non zero value if an error occurs.
 */
EXTERN_C int mexEvalString(
   const char *str	   /* matlab command string */
);


/*
 * Register Mex-file's At-Exit function (accessed via MEX callback)
 */
EXTERN_C int mexAtExit(
    void	(*exit_fcn)(void)
    );


/* Copyright 1996-2006 The MathWorks, Inc. */

/* $Revision: 1.9.4.3 $ */

/*
 * Revisit.  Conflicts with 32-bit compatibility API.  XXX
 */
#if 0

#ifdef ARGCHECK

#include "mwdebug.h" /* Prototype _d versions of API functions */

#define mexAtExit(exitfcn) 				mexAtExit_d(exitfcn, __FILE__, __LINE__)
#define mexCallMATLAB(nlhs, plhs, nrhs, prhs, fcn) mexCallMATLAB_d(nlhs, plhs, nrhs, prhs, fcn, __FILE__, __LINE__)
#define mexErrMsgTxt(errmsg)			mexErrMsgTxt_d(errmsg, __FILE__, __LINE__)
#define mexEvalString(str) 				mexEvalString_d(str, __FILE__, __LINE__)
#define mexGet(handle, property) 		mexGet_d(handle, property, __FILE__, __LINE__)
#define mexGetVariable(workspace, name) 	mexGetVariable_d(workspace, name, __FILE__, __LINE__)
#define mexGetVariablePtr(workspace, name)      mexGetVariablePtr_d(workspace, name, __FILE__, __LINE__)
#define mexIsGlobal(pa)                 mexIsGlobal_d(pa, __FILE__, __LINE__)
#define mexMakeArrayPersistent(pa) 		mexMakeArrayPersistent_d(pa, __FILE__, __LINE__)              
#define mexMakeMemoryPersistent(ptr) 	mexMakeMemoryPersistent_d(ptr, __FILE__, __LINE__)
#define mexPutVariable(workspace, name, pa) 	mexPutVariable_d(workspace, name, pa, __FILE__, __LINE__)
#define mexSet(handle, property, value) mexSet_d(handle, property, value, __FILE__, __LINE__)
#define mexSetTrapFlag(value)           mexSetTrapFlag_d(value, __FILE__, __LINE__)
#define mexSubsAssign(plhs, sub, nsubs, rhs)    mexSubsAssign_d(plhs, sub, nsubs, rhs, __FILE__, __LINE__)
#define mexSubsReference(prhs, sub, nsubs)    mexSubsReference_d(prhs, sub, nsubs, __FILE__, __LINE__)
#define mexWarnMsgTxt(str)		 		mexWarnMsgTxt_d(str, __FILE__, __LINE__)
#endif

#endif

#endif /* mex_h */
