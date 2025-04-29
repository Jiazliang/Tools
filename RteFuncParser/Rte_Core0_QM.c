/**
 * @file Rte_Core0_QM.c
 * @brief RTE Generated Source File for Core 0 QM Partition
 * @details This file contains the RTE function implementations for the QM partition on Core 0.
 *          文件包含了 Core 0 QM 分区的 RTE 函数实现。
 */

#ifndef RTE_CORE0_QM_C
#define RTE_CORE0_QM_C

#include "Rte_Type.h"
#include "Rte_Core0_QM.h" /* 假设存在对应的头文件 | Assuming corresponding header file exists */

/* --- RTE Internal Data Buffer (Simulation) --- */
/* 用于模拟 RTE 内部数据缓冲的静态全局变量 | Static global variable to simulate RTE internal data buffer */
static VAR(uint32, RTE_VAR) Rte_Buffer_DataElement_Data = 0; 


FUNC(Std_ReturnType, RTE_CODE) Rte_Write_P_DataElement_Data(VAR(uint32, AUTOMATIC) data);
FUNC(Std_ReturnType, RTE_CODE) Rte_Write_P_DataElement_Data(VAR(uint32, AUTOMATIC) data)

/* --- Sender-Receiver (SR) Interface Functions --- */

/**
 * @brief Writes data to a PPort.
 * @param data The data to be written.
 * @return Std_ReturnType E_OK if successful, E_NOT_OK otherwise.
 * @details SR 接口函数示例：写入数据 | Example SR interface function: Write data.
 */
FUNC(Std_ReturnType, RTE_CODE) Rte_Write_P_DataElement_Data(VAR(uint32, AUTOMATIC) data)
{
    /* 将数据写入内部缓冲区 | Write data to internal buffer */
    Rte_Buffer_DataElement_Data = data;
    return E_OK;
}

/**
 * @brief Reads data from an RPort.
 * @param data Pointer to store the read data.
 * @return Std_ReturnType E_OK if successful, E_NOT_OK otherwise.
 * @details SR 接口函数示例：读取数据 | Example SR interface function: Read data.
 */
FUNC(Std_ReturnType, RTE_CODE) Rte_Read_R_DataElement_Data(P2VAR(uint32, AUTOMATIC, RTE_APPL_DATA) data)
{
    /* 从内部缓冲区读取数据 | Read data from internal buffer */
    if (data != NULL) {
        *data = Rte_Buffer_DataElement_Data;
        return E_OK;
    }
    return E_NOT_OK;
}


/* --- Client-Server (CS) Interface Functions --- */

/**
 * @brief Calls a server operation.
 * @param request The request data for the operation.
 * @param response Pointer to store the response data.
 * @return Std_ReturnType E_OK if successful, E_NOT_OK otherwise.
 * @details CS 接口函数示例：调用服务器操作 | Example CS interface function: Call server operation.
 */
FUNC(Std_ReturnType, RTE_CODE) Rte_Call_R_Operation_Operation(VAR(uint16, AUTOMATIC) request, P2VAR(uint16, AUTOMATIC, RTE_APPL_DATA) response)
{
    /* 具体的实现会由 RTE 生成器填充 | Specific implementation will be filled by RTE generator */
    /* 这里仅为示例 | This is just an example */
    printf("Rte_Call_R_Operation_Operation called with request: %u\n", request);
    if (response != NULL) {
        *response = request * 2; /* 示例响应逻辑 | Example response logic */
        printf("Rte_Call_R_Operation_Operation returning response: %u\n", *response);
        return E_OK;
    }
    return E_NOT_OK;
}

#endif /* RTE_CORE0_QM_C */