/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "rtc_ip.h"
#include "xparameters.h"

#define RTC_BASEADDR       0x43C00000

unsigned char time[6]; //format: second/minute/hour/date/month/year


void print(char *str);

int main()
{
	u32 Delay,rtc_reg0,rtc_reg1;

	int i;

	unsigned char time_temp[6];

	unsigned char second_old=0;

    init_platform();

    //Write RTC Register3, Setting date, year=16, month=10, date=10
	RTC_IP_mWriteReg (RTC_BASEADDR, 12, 0x00160A0A);

    //Write RTC Register3, Setting time, hour=12, month=00, date=00
	RTC_IP_mWriteReg (RTC_BASEADDR, 8, 0x000C0000);

    //Write RTC Register3, enable time setting
	RTC_IP_mWriteReg (RTC_BASEADDR, 12, 0x80160A0A);

    for (Delay = 0; Delay < 10000000; Delay++);

    //Write RTC Register1, enable time setting
	RTC_IP_mWriteReg (RTC_BASEADDR, 12, 0x00160A0A);


	while(1) {

		//read RTC Register1
		rtc_reg1 = RTC_IP_mReadReg (RTC_BASEADDR, 4);

		//read RTC Register0
		rtc_reg0 = RTC_IP_mReadReg (RTC_BASEADDR, 0);

		second_old=time[0];

		time_temp[5] = (unsigned char)(rtc_reg1 >> 16);        //RTC year
		time_temp[4] = (unsigned char)(rtc_reg1 >> 8);         //RTC month
		time_temp[3] = (unsigned char)(rtc_reg1);              //RTC date


		time_temp[2] = (unsigned char)(rtc_reg0 >> 16);        //RTC Hour
		time_temp[1] = (unsigned char)(rtc_reg0 >> 8);         //RTC Munite
		time_temp[0] = (unsigned char)(rtc_reg0);              //RTC Second

		for (i=0;i<6;i++){

			time[i] = time_temp[i]/16*10+time_temp[i]%16;//格式为: 秒 分 时 日 月 星期 年
		}



		if (second_old!=time[0]){

			printf("current time is:20%d-%d-%d %d:%d:%d\n",time[5],time[4],time[3],time[2],time[1],time[0]);  //convert string

		}


	}


    cleanup_platform();
    return 0;
}
