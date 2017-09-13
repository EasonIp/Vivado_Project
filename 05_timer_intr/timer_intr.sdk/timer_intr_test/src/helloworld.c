#include <stdio.h>
#include "xadcps.h"
#include "xil_types.h"
#include "Xscugic.h"
#include "Xil_exception.h"
#include "xscutimer.h"

//timer info

#define TIMER_DEVICE_ID     XPAR_XSCUTIMER_0_DEVICE_ID
#define INTC_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID
#define TIMER_IRPT_INTR     XPAR_SCUTIMER_INTR

//#define TIMER_LOAD_VALUE  0x0FFFFFFF

#define TIMER_LOAD_VALUE    0x13D92D3F

//static XAdcPs  XADCMonInst; //XADC

static XScuGic Intc; //GIC

static XScuTimer Timer;//timer

static void SetupInterruptSystem(XScuGic *GicInstancePtr,

        XScuTimer *TimerInstancePtr, u16 TimerIntrId);

static void TimerIntrHandler(void *CallBackRef);

int main()

{

     XScuTimer_Config *TMRConfigPtr;     //timer config

     printf("------------START-------------\n");

     //私有定时器初始化

     TMRConfigPtr = XScuTimer_LookupConfig(TIMER_DEVICE_ID);

     XScuTimer_CfgInitialize(&Timer, TMRConfigPtr,TMRConfigPtr->BaseAddr);

     XScuTimer_SelfTest(&Timer);

     //加载计数周期，私有定时器的时钟为CPU的一般，为333MHZ,如果计数1S,加载值为1sx(333x1000x1000)(1/s)-1=0x13D92D3F

     XScuTimer_LoadTimer(&Timer, TIMER_LOAD_VALUE);

     //自动装载

     XScuTimer_EnableAutoReload(&Timer);

     //启动定时器

     XScuTimer_Start(&Timer);

     //set up the interrupts

     SetupInterruptSystem(&Intc,&Timer,TIMER_IRPT_INTR);

     while(1){

     }

     return 0;

}

void SetupInterruptSystem(XScuGic *GicInstancePtr,

        XScuTimer *TimerInstancePtr, u16 TimerIntrId)

{

        XScuGic_Config *IntcConfig; //GIC config

        Xil_ExceptionInit();

        //initialise the GIC

        IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);

        XScuGic_CfgInitialize(GicInstancePtr, IntcConfig,

                        IntcConfig->CpuBaseAddress);

        //connect to the hardware

        Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,

                    (Xil_ExceptionHandler)XScuGic_InterruptHandler,

                    GicInstancePtr);

        //set up the timer interrupt

        XScuGic_Connect(GicInstancePtr, TimerIntrId,

                        (Xil_ExceptionHandler)TimerIntrHandler,

                        (void *)TimerInstancePtr);

        //enable the interrupt for the Timer at GIC

        XScuGic_Enable(GicInstancePtr, TimerIntrId);

        //enable interrupt on the timer

        XScuTimer_EnableInterrupt(TimerInstancePtr);

        // Enable interrupts in the Processor.

        Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);

    }

static void TimerIntrHandler(void *CallBackRef)

{

    static int sec = 0;   //计数

    XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;

    XScuTimer_ClearInterruptStatus(TimerInstancePtr);

    sec++;

    printf(" %d Second\n\r",sec);  //每秒打印输出一次

}
