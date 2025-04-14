

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 6.00.0366 */
/* at Fri Jan 12 17:42:20 2007
 */
/* Compiler settings for mwcomutil.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#pragma warning( disable: 4049 )  /* more than 64k source lines */


#ifdef __cplusplus
extern "C"{
#endif 


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, IID_IMWUtil,0xC47EA90E,0x56D1,0x11d5,0xB1,0x59,0x00,0xD0,0xB7,0xBA,0x75,0x44);


MIDL_DEFINE_GUID(IID, LIBID_MWComUtil,0x5E2FF5BF,0x3F81,0x4B7D,0xBD,0x9C,0x15,0xBE,0x20,0x3E,0x6C,0xD0);


MIDL_DEFINE_GUID(CLSID, CLSID_MWField,0xB03AF6CC,0xF209,0x4A2E,0xB0,0xD6,0x95,0x59,0x15,0x03,0x68,0xB4);


MIDL_DEFINE_GUID(CLSID, CLSID_MWStruct,0x372535BB,0xF609,0x48F0,0x83,0xB3,0x96,0x22,0xBF,0x40,0x4F,0x16);


MIDL_DEFINE_GUID(CLSID, CLSID_MWComplex,0x18CC173B,0xD483,0x4796,0xB0,0xEC,0x48,0x36,0x01,0x24,0x63,0xBC);


MIDL_DEFINE_GUID(CLSID, CLSID_MWSparse,0x3DF30B5E,0x8B4B,0x43F5,0xB7,0xEF,0x00,0x92,0xAE,0xE5,0x45,0xAD);


MIDL_DEFINE_GUID(CLSID, CLSID_MWArg,0x0A120E79,0x8CDA,0x440F,0x8B,0x4E,0x79,0x0A,0xDB,0xE1,0x85,0x6C);


MIDL_DEFINE_GUID(CLSID, CLSID_MWArrayFormatFlags,0xFE28E025,0x6692,0x42E3,0xA7,0xE8,0xCC,0xC4,0x4F,0x1B,0x87,0x40);


MIDL_DEFINE_GUID(CLSID, CLSID_MWDataConversionFlags,0x4650AD4F,0xDE11,0x49E5,0xAE,0x2E,0x63,0x97,0xC1,0x9C,0x17,0x9E);


MIDL_DEFINE_GUID(CLSID, CLSID_MWUtil,0x45A19F94,0xD29E,0x4F64,0x99,0x11,0x8A,0x99,0x70,0xF6,0xCD,0xC8);


MIDL_DEFINE_GUID(CLSID, CLSID_MWFlags,0xA7D8E474,0x9440,0x409F,0x98,0xD9,0x42,0x46,0xE3,0xEC,0xFF,0xC7);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



