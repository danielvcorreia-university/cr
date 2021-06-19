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

#include <stdlib.h>
#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "xtmrctr_l.h"
#include "xil_printf.h"

/****************************** Definitions **********************************/

typedef int bool;

#define min(a, b)		((a < b) ? a : b)

#define N				4095 //up to 4095

#define DMA_DEVICE_ID	XPAR_AXIDMA_0_DEVICE_ID

int DMAConfig(u16 dmaDeviceId, XAxiDma* pDMAInstDefs)
{
	XAxiDma_Config* pDMAConfig;
	int status;

	// Initialize the XAxiDma device
	pDMAConfig = XAxiDma_LookupConfig(dmaDeviceId);
	if (!pDMAConfig)
	{
		xil_printf("No DMA configuration found for %d.\r\n", dmaDeviceId);
		return XST_FAILURE;
	}

	status = XAxiDma_CfgInitialize(pDMAInstDefs, pDMAConfig);
	if (status != XST_SUCCESS)
	{
		xil_printf("DMA Initialization failed %d.\r\n", status);
		return XST_FAILURE;
	}

	if (XAxiDma_HasSg(pDMAInstDefs))
	{
		xil_printf("Device configured as SG mode.\r\n");
		return XST_FAILURE;
	}

	// Disable interrupts, we use polling mode
	XAxiDma_IntrDisable(pDMAInstDefs, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(pDMAInstDefs, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

	return XST_SUCCESS;
}

void EncodeDataSw(int* pDst, int* pSrc, unsigned int size, int* polynomial, int degree_data_out, int degree_polynomial)
{
	int* p;
	int aa[degree_data_out + 1];
	int i, j, s, qq;

	// For each int value (32bit) in memory
	for (p = pSrc; p < pSrc + size; p++, pDst++)
	{
		// Copy word to be processed to pDst and put remainder (2 ls bytes) to 0
		*pDst = (*p) & 0xFFFFFF00;

		// 8 bit ls (remainder) initialize 0
		for(i = 0; i < 8; i++)
		{
			aa[i] = 0;
		}

		s = 0x00000100;
		// Copy 23 to 8 (16 bits) into local array of ints
		for(i = 8; i < degree_data_out + 1; i++)
		{
			aa[i] = (((*p) & s) >> i);
			s = s << 1;
		}

		// Divide 16 ms of 24 bits with polynomial (remainder is in 8 ls bits)
		for(i = degree_data_out - degree_polynomial; i >= 0; i--)
		{
			qq = aa[i + degree_polynomial];
			if (qq != 0)	// Why does if (qq != NULL) gives a warning?
			{
				for(j = 0; j <= degree_polynomial; j++)
				{
					aa[i + j] ^= polynomial[j];
				}
			}
		}

		// Save remainder in 8 ls bits of pDst
		for(i = 0; i < degree_polynomial; i++)
		{
			*pDst = ((*pDst) | (aa[i] << i));
		}
	}
}

void PrintDataArray(int* pData, unsigned int size)
{
	int* p;

	xil_printf("\n\r");
	for (p = pData; p < pData + size; p++)
	{
		xil_printf("%08x  ", *p);
	}
}

void ResetPerformanceTimer()
{
	XTmrCtr_Disable(XPAR_TMRCTR_0_BASEADDR, 0);
	XTmrCtr_SetLoadReg(XPAR_TMRCTR_0_BASEADDR, 0, 0x00000001);
	XTmrCtr_LoadTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, 0);
	XTmrCtr_SetControlStatusReg(XPAR_TMRCTR_0_BASEADDR, 0, 0x00000000);
}

void RestartPerformanceTimer()
{
	ResetPerformanceTimer();
	XTmrCtr_Enable(XPAR_TMRCTR_0_BASEADDR, 0);
}

unsigned int GetPerformanceTimer()
{
	return XTmrCtr_GetTimerCounterReg(XPAR_TMRCTR_0_BASEADDR, 0);
}

unsigned int StopAndGetPerformanceTimer()
{
	XTmrCtr_Disable(XPAR_TMRCTR_0_BASEADDR, 0);
	return GetPerformanceTimer();
}

/******************************  Main Functions ******************************/

int main()
{
	int status;
	XAxiDma dmaInstDefs;

	int srcData[N], dstData[N], polynomial[9];
	unsigned int timeElapsed;

	polynomial[8] = 1; // x^8
	polynomial[7] = 0;
	polynomial[6] = 0;
	polynomial[5] = 1; // x^5
	polynomial[4] = 0;
	polynomial[3] = 1; // x^3
	polynomial[2] = 1; // x^2
	polynomial[1] = 1; // x
	polynomial[0] = 1; // 1

	xil_printf("\r\n16-bit CRC computation using polynomial (x^8+x^5+x^3+x^2+x+1) and DMA");
	init_platform();

	xil_printf("\r\nFilling memory with pseudo-random data...");
	RestartPerformanceTimer();
	srand(0);
	for (int i = 0; i < N; i++)
	{
		srcData[i] = rand();
	}
	timeElapsed = StopAndGetPerformanceTimer();
	xil_printf("\n\rMemory initialization time: %d microseconds\n\r",
			   timeElapsed / (XPAR_CPU_M_AXI_DP_FREQ_HZ / 1000000));
	PrintDataArray(srcData, min(8, N));
	xil_printf("\n\r");

	// Software only
	RestartPerformanceTimer();
	EncodeDataSw(dstData, srcData, N, polynomial, 23, 8);
	timeElapsed = StopAndGetPerformanceTimer();
	xil_printf("\n\rSoftware only cyclic redundancy check time: %d microseconds",
			   timeElapsed / (XPAR_CPU_M_AXI_DP_FREQ_HZ / 1000000));
	PrintDataArray(dstData, min(8, N));

	xil_printf("\r\nConfiguring DMA...");
	status = DMAConfig(DMA_DEVICE_ID, &dmaInstDefs);
	if (status != XST_SUCCESS)
	{
		xil_printf("\r\nConfiguration failed.");
		return XST_FAILURE;
	}
	xil_printf("\r\nDMA running...");

	xil_printf("\rMax transfer length in bytes = %d", dmaInstDefs.TxBdRing.MaxTransferLen); // = to (2^^Width of buffer length register in DMA)-1
	//if Width of buffer length register=14, then Max transfer length in bytes = 16383
	// DMA and Hardware assisted
	RestartPerformanceTimer();
	//Xil_DCacheFlushRange((u32) srcData, N * sizeof(int));
	status = XAxiDma_SimpleTransfer(&dmaInstDefs,(UINTPTR) srcData, N * sizeof(int), XAXIDMA_DMA_TO_DEVICE);
	if (status == XST_INVALID_PARAM)
		xil_printf("\r\nParam   %d", N * sizeof(int));
	if (status != XST_SUCCESS)
	{
		xil_printf("\r\nDMA transfer2 failed.");
		return XST_FAILURE;
	}

	status = XAxiDma_SimpleTransfer(&dmaInstDefs,(UINTPTR) dstData, N * sizeof(int), XAXIDMA_DEVICE_TO_DMA);
	if (status != XST_SUCCESS)
	{
		xil_printf("\r\nDMA transfer1 failed.");
		return XST_FAILURE;
	}

	while ((XAxiDma_Busy(&dmaInstDefs, XAXIDMA_DEVICE_TO_DMA)) ||
		   (XAxiDma_Busy(&dmaInstDefs, XAXIDMA_DMA_TO_DEVICE)))
	{
		/* Wait */
	}
	timeElapsed = StopAndGetPerformanceTimer();
	xil_printf("\n\rDMA Hardware assisted cyclic redundancy check time: %d microseconds",
			   timeElapsed / (XPAR_CPU_M_AXI_DP_FREQ_HZ / 1000000));
	PrintDataArray(dstData, min(8, N));

	cleanup_platform();
	return XST_SUCCESS;
}
