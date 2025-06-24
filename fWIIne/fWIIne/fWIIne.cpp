/*
 *	fWIIne
 *
 *	Written By:
 *		William Alozy	< wiill >
 *		Email: < wiill.iam (--AT--) club-internet.fr >
 *
 *	Copyright 2008 - 2009
 *
 *	This file is part of fwiine.
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *	$Header$
 *
 */
//
// fwiine.cpp	v0.4	William Alozy	25-09-2009		Added : Wii Motion Plus
//
// fwiine.cpp	v0.3	William Alozy	04-01-2009		New wiimote library : wiiuse 0.12 (http://wiiuse.sourceforge.net/)
//
// fwiine.cpp	v0.2	William Alozy	10-05-2008		Added : roll,pitch determination (option nr 6)
//
// fwiine.cpp	v0.1	William Alozy	19-01-2008		Creation
//
#include "stdafx.h"
#include <Windows.h>
#include "mex.h"
#include "matrix.h"
#ifndef WIN32
	#include <unistd.h>
#endif
#include "wiiuse.h"

/*************** wiiuse includes end - fin des includes *********************/
#define MAX_WIIMOTES				4


/*
 *	These are some identifiers for wiimotes
 *
 *	See below in main() for what they are used for.
 */

#define WIIMOTE_ID_1		1
#define WIIMOTE_ID_2		2




/******* public definition (draft) - definitions publiques (brouillon) *******/

void StartDevice();
void UseDevice();

int iCase=0;
double dist1=0;
double dist2=0;
double aXPos=0;
double aYPos=0;
double aZPos=0;
double ir1XPos=0;
double ir1YPos=0;
double ir2XPos=0;
double ir2YPos=0;;
double IR1here=0;
double IR2here=0;
double ir3XPos=0;
double ir3YPos=0;
double ir4XPos=0;
double ir4YPos=0;;
double IR3here=0;
double IR4here=0;
double P1=0;
double P2=0;
double PA=0;
double PB=0;
double drx=0;
double dry=0;
double drz=0;
double EXPhere = 0;
double *data1;
int ids[] = { WIIMOTE_ID_1, WIIMOTE_ID_2 };
const char* version;
wiimote** wiimotes;
int found, connected;






/******************* private - prive ***************************************/

/**
 *	@brief Callback that handles an event. - Callback permettant de traiter les evenements voir bib. wiiuse pour plus d'info
 *
 *	@param wm		Pointer to a wiimote_t structure.
 *
 *	This function is called automatically by the wiiuse library when an
 *	event occurs on the specified wiimote.
 */
void handle_event(struct wiimote_t* wm) {
	
	//printf("\n\n--- EVENT [wiimote id %i] ---\n", wm->unid);
		/* if a button is pressed, report it */
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_A))		{PA=1;printf("A pressed\n");}
		else						{PA=0;}
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_B))		{PB=1;printf("B pressed\n");}
		else						{PB=0;}
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_UP))		printf("UP pressed\n");
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_DOWN))	printf("DOWN pressed\n");
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_LEFT))	printf("LEFT pressed\n");
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_RIGHT))	printf("RIGHT pressed\n");
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_MINUS))	printf("MINUS pressed\n");
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_PLUS))	printf("PLUS pressed\n");
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_ONE))		{P1=1;printf("ONE pressed\n");}
		else						{P1=0;}
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_TWO))		{P2=1;printf("TWO pressed\n");}
		else						{P2=0;}
		if (IS_PRESSED(wm, WIIMOTE_BUTTON_HOME))	printf("HOME pressed\n");

		/*
		 *	Pressing minus will tell the wiimote we are no longer interested in movement.
		 *	This is useful because it saves battery power.
		 */
		 if (IS_JUST_PRESSED(wm, WIIMOTE_BUTTON_MINUS))
		 	wiiuse_motion_sensing(wm, 0);
		 
		/*
		 *	Pressing plus will tell the wiimote we are interested in movement.
		 */
		 if (IS_JUST_PRESSED(wm, WIIMOTE_BUTTON_PLUS))
			wiiuse_motion_sensing(wm, 1);
		 	
		/*
		 *	Pressing B will toggle the rumble
		 *
		 *	if B is pressed but is not held, toggle the rumble
		 */
		 if (IS_JUST_PRESSED(wm, WIIMOTE_BUTTON_B))
		 	wiiuse_toggle_rumble(wm);
		 
		 if (IS_JUST_PRESSED(wm, WIIMOTE_BUTTON_UP))
			wiiuse_set_ir(wm, 1);
		if (IS_JUST_PRESSED(wm, WIIMOTE_BUTTON_DOWN))
			wiiuse_set_ir(wm, 0);
		
		if (IS_JUST_PRESSED(wm, WIIMOTE_BUTTON_ONE)) {
			if (wm->exp.type != EXP_MOTION_PLUS) {
				printf("Activating WiiMotionPlus com.\n");
				wiiuse_set_motion_plus(wm, 1);
			}
			EXPhere=1;
		}
		if (IS_JUST_PRESSED(wm, WIIMOTE_BUTTON_TWO)) {
			if (wm->exp.type == EXP_MOTION_PLUS) {
				printf("Deactivating WiiMotionPlus com.\n");
				wiiuse_set_motion_plus(wm, 0);
			}
			EXPhere=0;
		}
	

	/* motion plus test end */
	/* if the accelerometer is turned on then print angles */
	//if (WIIUSE_USING_ACC(wm)) {
	//	printf("wiimote roll  = %f\n", wm->orient.roll);
	//	printf("wiimote pitch = %f\n", wm->orient.pitch);
	//	printf("wiimote yaw   = %f\n", wm->orient.yaw);
	//}	
	 aXPos=(float)wm->gforce.x;
 	 aYPos=(float)wm->gforce.y;
  	 aZPos=(float)wm->gforce.z;
	 
	/*
	 *	If IR tracking is enabled then print the coordinates
	 *	on the virtual screen that the wiimote is pointing to.
	 *
	 *	Also make sure that we see at least 1 dot.
	 */
	//if (WIIUSE_USING_IR(wm)) {
		//int i = 0;
	
		/* go through each of the 4 possible IR sources */
		//for (; i < 4; ++i) {
			/* check if the source is visible */
		//	if (wm->ir.dot[i].visible)
		//		printf("IR source %i: (%u, %u)\n", i, wm->ir.dot[i].x, wm->ir.dot[i].y);
		//}

		//printf("IR cursor: (%u, %u)\n", wm->ir.x, wm->ir.y);
		//printf("IR z distance: %f\n", wm->ir.z);
	//}

	if (wm->ir.dot[0].visible)
		{
		IR1here	= 1; 
		ir1XPos=wm->ir.dot[0].x / 1024.f;;
		ir1YPos	=wm->ir.dot[0].y / 767.f;
		}
	else
		{
		IR1here = 0; ir1XPos = 0; ir1YPos = 0;
		}
	if (wm->ir.dot[1].visible)
		{
		IR2here	= 1; 
		ir2XPos=wm->ir.dot[1].x / 1024.f;;
		ir2YPos	=wm->ir.dot[1].y / 767.f;
		}
	else
		{
		IR2here = 0; ir2XPos = 0; ir2YPos = 0;
		}
	if (wm->ir.dot[2].visible)
		{
		IR3here	= 1; 
		ir3XPos=wm->ir.dot[2].x / 1024.f;;
		ir3YPos	=wm->ir.dot[2].y / 767.f;
		}
	else
		{
		IR3here = 0; ir3XPos = 0; ir3YPos = 0;
		}
	if (wm->ir.dot[3].visible)
		{
		IR4here	= 1; 
		ir4XPos=wm->ir.dot[3].x / 1024.f;;
		ir4YPos	=wm->ir.dot[3].y / 767.f;
		}
	else
		{
		IR4here = 0; ir4XPos = 0; ir4YPos = 0;
		}


	/* show events specific to supported expansions */
	if (wm->exp.type == EXP_NUNCHUK) {
		/* nunchuk */
		struct nunchuk_t* nc = (nunchuk_t*)&wm->exp.nunchuk;

		if (IS_PRESSED(nc, NUNCHUK_BUTTON_C))		printf("Nunchuk: C pressed\n");
		if (IS_PRESSED(nc, NUNCHUK_BUTTON_Z))		printf("Nunchuk: Z pressed\n");

		printf("nunchuk roll  = %f\n", nc->orient.roll);
		printf("nunchuk pitch = %f\n", nc->orient.pitch);
		printf("nunchuk yaw   = %f\n", nc->orient.yaw);

		printf("nunchuk joystick angle:     %f\n", nc->js.ang);
		printf("nunchuk joystick magnitude: %f\n", nc->js.mag);
	} else if (wm->exp.type == EXP_CLASSIC) {
		/* classic controller */
		struct classic_ctrl_t* cc = (classic_ctrl_t*)&wm->exp.classic;

		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_ZL))			printf("Classic: ZL pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_B))			printf("Classic: B pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_Y))			printf("Classic: Y pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_A))			printf("Classic: A pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_X))			printf("Classic: X pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_ZR))			printf("Classic: ZR pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_LEFT))		printf("Classic: LEFT pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_UP))			printf("Classic: UP pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_RIGHT))		printf("Classic: RIGHT pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_DOWN))		printf("Classic: DOWN pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_FULL_L))		printf("Classic: FULL L pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_MINUS))		printf("Classic: MINUS pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_HOME))		printf("Classic: HOME pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_PLUS))		printf("Classic: PLUS pressed\n");
		if (IS_PRESSED(cc, CLASSIC_CTRL_BUTTON_FULL_R))		printf("Classic: FULL R pressed\n");

		printf("classic L button pressed:         %f\n", cc->l_shoulder);
		printf("classic R button pressed:         %f\n", cc->r_shoulder);
		printf("classic left joystick angle:      %f\n", cc->ljs.ang);
		printf("classic left joystick magnitude:  %f\n", cc->ljs.mag);
		printf("classic right joystick angle:     %f\n", cc->rjs.ang);
		printf("classic right joystick magnitude: %f\n", cc->rjs.mag);
	} 
	if (wm->exp.type == EXP_MOTION_PLUS) {
		/* motion plus */
		struct motion_plus_t* mp = (motion_plus_t*)&wm->exp.mp;
		//printf("drx  = %u\n", mp->rx);
		//printf("dry = %u\n", mp->ry);
		//printf("drz   = %u\n", mp->rz);
		drx = (double) mp->rx;
		dry = (double) mp->ry;
		drz = (double) mp->rz;
		//printf("ext   = %u\n", mp->ext);
		//printf("byte_status   = %f\n", mp->status);
		if (EXPhere==1)	{
			wiiuse_motion_sensing(wm, 1);
			EXPhere=0;
		}
	} else {
		drx = 0;
		dry = 0;
		drz = 0;
	}


}


/**
 *	@brief Callback that handles a read event. - fonction issue de la bib. Wiiuse voir la bib. pour plus d'info
 *
 *	@param wm		Pointer to a wiimote_t structure.
 *	@param data		Pointer to the filled data block.
 *	@param len		Length in bytes of the data block.
 *
 *	This function is called automatically by the wiiuse library when
 *	the wiimote has returned the full data requested by a previous
 *	call to wiiuse_read_data().
 *
 *	You can read data on the wiimote, such as Mii data, if
 *	you know the offset address and the length.
 *
 *	The \a data pointer was specified on the call to wiiuse_read_data().
 *	At the time of this function being called, it is not safe to deallocate
 *	this buffer.
 */
void handle_read(struct wiimote_t* wm, byte* data, unsigned short len) {
	int i = 0;

	printf("\n\n--- DATA READ [wiimote id %i] ---\n", wm->unid);
	printf("finished read of size %i\n", len);
	for (; i < len; ++i) {
		if (!(i%16))
			printf("\n");
		printf("%x ", data[i]);
	}
	printf("\n\n");
}


/**
 *	@brief Callback that handles a controller status event.
 *
 *	@param wm				Pointer to a wiimote_t structure.
 *	@param attachment		Is there an attachment? (1 for yes, 0 for no)
 *	@param speaker			Is the speaker enabled? (1 for yes, 0 for no)
 *	@param ir				Is the IR support enabled? (1 for yes, 0 for no)
 *	@param led				What LEDs are lit.
 *	@param battery_level	Battery level, between 0.0 (0%) and 1.0 (100%).
 *
 *	This occurs when either the controller status changed
 *	or the controller status was requested explicitly by
 *	wiiuse_status().
 *
 *	One reason the status can change is if the nunchuk was
 *	inserted or removed from the expansion port.
 */
void handle_ctrl_status(struct wiimote_t* wm) {
	/*
	printf("\n\n--- CONTROLLER STATUS [wiimote id %i] ---\n", wm->unid);

	printf("attachment:      %i\n", wm->exp.type);
	printf("speaker:         %i\n", WIIUSE_USING_SPEAKER(wm));
	printf("ir:              %i\n", WIIUSE_USING_IR(wm));
	printf("leds:            %i %i %i %i\n", WIIUSE_IS_LED_SET(wm, 1), WIIUSE_IS_LED_SET(wm, 2), WIIUSE_IS_LED_SET(wm, 3), WIIUSE_IS_LED_SET(wm, 4));
	printf("battery:         %f %%\n", wm->battery_level);
	*/
}


/**
 *	@brief Callback that handles a disconnection event. - fonction issue de la bib. Wiiuse voir la bib. pour plus d'info
 *
 *	@param wm				Pointer to a wiimote_t structure.
 *
 *	This can happen if the POWER button is pressed, or
 *	if the connection is interrupted.
 */
void handle_disconnect(wiimote* wm) {
	printf("\n\n--- DISCONNECTED [wiimote id %i] ---\n", wm->unid);
}




/******* Fonctions principales *******************************************************/

/**
 *	@brief mex function is used by Scilab - fonction mex utilisee par Scilab
 *
 *	@param classical parameter definition for mex - definition standard des parametres pour une fonction mex
 *
 *	This function is called by Scilab each time to have a status of data acquisition. (The faster, the better is)
 *	Cette fonction est appelee par scilab a chaque fois pour avoir un status de l'acquisition de donnees
 *	(appeler cette fonction idealement toute les 10 ms)
 */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs>0)
		{
		data1 = mxGetPr(prhs[0]);
		iCase = (int)data1[0];
		}
	if (nrhs>1)
		{
		data1 = mxGetPr(prhs[1]);
		dist1 = data1[0];
		}
	if (nrhs>2)
		{
		data1 = mxGetPr(prhs[2]);
		dist2 = data1[0];
		}
	UseDevice();	// see inside this routine for more information about the parameter
					// voir dans cette routine pour plus d'infos au sujet des parametres
	if (iCase==3)
		{
		if (nlhs>=3)
			{
			plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
			data1 = mxGetPr(plhs[0]);
			data1[0] = aXPos;
			data1 = mxGetPr(plhs[1]);
			data1[0] = aYPos;
			data1 = mxGetPr(plhs[2]);
			data1[0] = aZPos;
			}
		}
	if (iCase==4)
		{
		if (nlhs>=9)
			{
			plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[5] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[6] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[7] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[8] = mxCreateDoubleMatrix(1, 1, mxREAL);
			data1 = mxGetPr(plhs[0]);
			data1[0] = aXPos;
			data1 = mxGetPr(plhs[1]);
			data1[0] = aYPos;
			data1 = mxGetPr(plhs[2]);
			data1[0] = aZPos;
			data1 = mxGetPr(plhs[3]);
			data1[0] = ir1XPos;
			data1 = mxGetPr(plhs[4]);
			data1[0] = ir1YPos;
			data1 = mxGetPr(plhs[5]);
			data1[0] = ir2XPos;
			data1 = mxGetPr(plhs[6]);
			data1[0] = ir2YPos;
			data1 = mxGetPr(plhs[7]);
			data1[0] = IR1here;
			data1 = mxGetPr(plhs[8]);
			data1[0] = IR2here;
			}
		}
	if (iCase==5)
		{
		if (nlhs>=13)
			{
			plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[5] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[6] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[7] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[8] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[9] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[10]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[11]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[12]= mxCreateDoubleMatrix(1, 1, mxREAL);
			data1 = mxGetPr(plhs[0]);
			data1[0] = aXPos;
			data1 = mxGetPr(plhs[1]);
			data1[0] = aYPos;
			data1 = mxGetPr(plhs[2]);
			data1[0] = aZPos;
			data1 = mxGetPr(plhs[3]);
			data1[0] = ir1XPos;
			data1 = mxGetPr(plhs[4]);
			data1[0] = ir1YPos;
			data1 = mxGetPr(plhs[5]);
			data1[0] = ir2XPos;
			data1 = mxGetPr(plhs[6]);
			data1[0] = ir2YPos;
			data1 = mxGetPr(plhs[7]);
			data1[0] = IR1here;
			data1 = mxGetPr(plhs[8]);
			data1[0] = IR2here;
			data1 = mxGetPr(plhs[9]);
			data1[0] = P1;
			data1 = mxGetPr(plhs[10]);
			data1[0] = P2;
			data1 = mxGetPr(plhs[11]);
			data1[0] = PA;
			data1 = mxGetPr(plhs[12]);
			data1[0] = PB;
			}
		}
	if (iCase==6)
		{
		if (nlhs>=5)
			{
			plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
			data1 = mxGetPr(plhs[0]);
			data1[0] = aXPos;
			data1 = mxGetPr(plhs[1]);
			data1[0] = aYPos;
			data1 = mxGetPr(plhs[2]);
			data1[0] = aZPos;
			data1 = mxGetPr(plhs[3]);
			data1[0] = (double) wiimotes[0]->orient.pitch;
			data1 = mxGetPr(plhs[4]);
			data1[0] = (double) wiimotes[0]->orient.roll;
			}
		}
	if (iCase==7)
		{
		if (nlhs>=19)
			{
			plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[5] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[6] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[7] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[8] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[9] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[10]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[11]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[12]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[13] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[14] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[15]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[16]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[17]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[18]= mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[19]= mxCreateDoubleMatrix(1, 1, mxREAL);
			data1 = mxGetPr(plhs[0]);
			data1[0] = aXPos;
			data1 = mxGetPr(plhs[1]);
			data1[0] = aYPos;
			data1 = mxGetPr(plhs[2]);
			data1[0] = aZPos;
			data1 = mxGetPr(plhs[3]);
			data1[0] = ir1XPos;
			data1 = mxGetPr(plhs[4]);
			data1[0] = ir1YPos;
			data1 = mxGetPr(plhs[5]);
			data1[0] = ir2XPos;
			data1 = mxGetPr(plhs[6]);
			data1[0] = ir2YPos;
			data1 = mxGetPr(plhs[7]);
			data1[0] = IR1here;
			data1 = mxGetPr(plhs[8]);
			data1[0] = IR2here;
			data1 = mxGetPr(plhs[9]);
			data1[0] = ir3XPos;
			data1 = mxGetPr(plhs[10]);
			data1[0] = ir3YPos;
			data1 = mxGetPr(plhs[11]);
			data1[0] = ir4XPos;
			data1 = mxGetPr(plhs[12]);
			data1[0] = ir4YPos;
			data1 = mxGetPr(plhs[13]);
			data1[0] = IR3here;
			data1 = mxGetPr(plhs[14]);
			data1[0] = IR4here;
			data1 = mxGetPr(plhs[15]);
			data1[0] = P1;
			data1 = mxGetPr(plhs[16]);
			data1[0] = P2;
			data1 = mxGetPr(plhs[17]);
			data1[0] = PA;
			data1 = mxGetPr(plhs[18]);
			data1[0] = PB;
			}
		}
	if (iCase==8)
		{
		if (nlhs>=6)
			{
			plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
			plhs[5] = mxCreateDoubleMatrix(1, 1, mxREAL);
			data1 = mxGetPr(plhs[0]);
			data1[0] = aXPos;
			data1 = mxGetPr(plhs[1]);
			data1[0] = aYPos;
			data1 = mxGetPr(plhs[2]);
			data1[0] = aZPos;
			data1 = mxGetPr(plhs[3]);
			data1[0] = drx;
			data1 = mxGetPr(plhs[4]);
			data1[0] = dry;
			data1 = mxGetPr(plhs[5]);
			data1[0] = drz;
			}
		}
	return;
}




/**
 *	@brief the function check and execute the requested action from scilab - la fonction controle et execute
 *	l'action venant de scilab
 *
 *	@param 
 *
 *	This function is called by the mex-function. Cette fonction est appellee par le mex fonction.
 */


void UseDevice()
{

	if (iCase==1)
		{
		printf("Initializing/Initialisation/Inicializacion Wiimote Com...");
		printf("\n");
		StartDevice(); 
		}
	else
		{
		switch (iCase)
			{
			case 0:
				// Exit activities / sortie / salida
				printf("Shutting/Fermeture/Cerrando Wiitmote Com...");
				printf("\n");
				/*
	 			*	Disconnect the wiimotes
	 			*/
				wiiuse_cleanup(wiimotes, MAX_WIIMOTES);
				break;
			case 2:
				// test
				printf("...");
					/*
				#ifndef WIN32
					usleep(100000);
				#else
					Sleep(100);
				#endif
				*/
				printf("\n");
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
				wiiuse_poll(wiimotes, MAX_WIIMOTES);
				handle_event(wiimotes[0]);
				break;
			case 9:
				if (wiiuse_poll(wiimotes, MAX_WIIMOTES)) {
				/*
			 	*	This happens if something happened on any wiimote.
			 	*	So go through each one and check if anything happened.
			 	*/
				int i = 0;
				/* for (; i < MAX_WIIMOTES; ++i) { */ 	//Only one wiimote managed
						switch (wiimotes[i]->event) {
						case WIIUSE_EVENT:
							/* a generic event occured */
							handle_event(wiimotes[i]);
							break;
	
						case WIIUSE_STATUS:
							/* a status event occured */
							handle_ctrl_status(wiimotes[i]);
							printf("Status...\n");
							break;
	
						case WIIUSE_DISCONNECT:
						case WIIUSE_UNEXPECTED_DISCONNECT:
							/* the wiimote disconnected */
							handle_disconnect(wiimotes[i]);
							break;
	
						case WIIUSE_READ_DATA:
							/*
						 	*	Data we requested to read was returned.
						 	*	Take a look at wiimotes[i]->read_req
						 	*	for the data.
						 	*/
							printf("Reading...\n");
							break;
	
						case WIIUSE_NUNCHUK_INSERTED:
							/*
						 	*	a nunchuk was inserted
						 	*	This is a good place to set any nunchuk specific
						 	*	threshold values.  By default they are the same
						 	*	as the wiimote.
						 	*/
						 	//wiiuse_set_nunchuk_orient_threshold((struct nunchuk_t*)&wiimotes[i]->exp.nunchuk, 90.0f);
						 	//wiiuse_set_nunchuk_accel_threshold((struct nunchuk_t*)&wiimotes[i]->exp.nunchuk, 100);
							printf("Nunchuk inserted.\n");
							break;
	
						case WIIUSE_CLASSIC_CTRL_INSERTED:
							printf("Classic controller inserted.\n");
							break;
	
						case WIIUSE_MOTION_PLUS_ACTIVATED:
							printf("Motion plus inserted.\n");
							break;

						case WIIUSE_GUITAR_HERO_3_CTRL_INSERTED:
							/* some expansion was inserted */
							handle_ctrl_status(wiimotes[i]);
							printf("Guitar Hero 3 controller inserted.\n");
							break;
	
						case WIIUSE_NUNCHUK_REMOVED:
						case WIIUSE_CLASSIC_CTRL_REMOVED:
						case WIIUSE_GUITAR_HERO_3_CTRL_REMOVED:
						case WIIUSE_MOTION_PLUS_REMOVED:
							/* some expansion was removed */
							handle_ctrl_status(wiimotes[i]);
							printf("An expansion was removed.\n");
							break;
	
						default:
							break;
							}
					}
				/* } */ 				//Only one wiimote managed
				
				break;
		}
	}
	//printf("\n");
	return;
}

/**
 *	@brief Load Wiiuse library and start com - charge la bib wiiuse et demarre la com.
 *
  *
 *	This needs to be done before anything else can happen
 *	StartDevice() will return the status of wiimote detection.
 */


void StartDevice()
{

	/*
	 *	Initialize an array of wiimote objects.
	 *
	 *	The parameter is the number of wiimotes I want to create.
	 */
	wiimotes =  wiiuse_init(MAX_WIIMOTES);

	/*
	 *	Find wiimote devices
	 *
	 *	Now we need to find some wiimotes.
	 *	Give the function the wiimote array we created, and tell it there
	 *	are MAX_WIIMOTES wiimotes we are interested in.
	 *
	 *	Set the timeout to be 5 seconds.
	 *
	 *	This will return the number of actual wiimotes that are in discovery mode.
	 */
	found = wiiuse_find(wiimotes, MAX_WIIMOTES, 5);
	if (!found) {
		printf ("No wiimotes found.");
	//	return 0;
	}
	#ifndef WIN32
		usleep(200000);
	#else
		Sleep(200);
	#endif
	/*
	 *	Connect to the wiimotes
	 *
	 *	Now that we found some wiimotes, connect to them.
	 *	Give the function the wiimote array and the number
	 *	of wiimote devices we found.
	 *
	 *	This will return the number of established connections to the found wiimotes.
	 */
	connected = wiiuse_connect(wiimotes, MAX_WIIMOTES);
	if (connected)
		{
		printf("Connected to %i wiimotes (of %i found).\n", connected, found);
		/* IR initialization sequence - Sequence initialisation IR            */
		wiiuse_set_ir(wiimotes[0],0);
		wiiuse_set_ir(wiimotes[1],0);
		wiiuse_set_ir(wiimotes[0],1);
		wiiuse_set_ir(wiimotes[1],1);
		}
	else {
		printf("Failed to connect to any wiimote.\n");
	//	return 0;
	}
#ifndef WIN32
		usleep(200000);
	#else
		Sleep(200);
	#endif
	//return;
	
}




