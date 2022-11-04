/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#ifndef __SCHED_H__
#define __SCHED_H__

#include "stdint.h"
#include "screen.h"
#include "tss.h"

char debug_mode;
char showing_exception;
int16_t current_task_idx;

void sched_init();
int16_t sched_nextTask();

void sched_toggle_debug();
void sched_kill_current_task();

#endif	/* !__SCHED_H__ */
