/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "sched.h"

#define SCHED_TASK_IDX(task_id) (task_id - 14)

char debug_mode = FALSE;
char showing_exception = FALSE;

int16_t idle_task_idx = 14;
int16_t init_task_idx = 15;
int16_t max_task_idx = 38;
int16_t current_task_idx = 0;

char task_alive[25]; // son 25 tareas. 24 objetos + idle

void sched_init() {
  current_task_idx = idle_task_idx;

  for (uint8_t i = 0; i < 25; i++) {
    task_alive[i] = TRUE;
  }
}

int16_t sched_nextTask() {
  if (showing_exception == FALSE && game_finished == FALSE) {
    current_task_idx++;

    if (current_task_idx > max_task_idx) {
      current_task_idx = init_task_idx;
    }

    if (task_alive[SCHED_TASK_IDX(current_task_idx)] == FALSE) {
      return sched_nextTask();
    }

    return (current_task_idx << 3);
  }

  return (idle_task_idx << 3);
}

void sched_kill_current_task() {
  task_alive[SCHED_TASK_IDX(current_task_idx)] = FALSE;
  current_task_idx = idle_task_idx;

  __asm __volatile("ljmp $0x70, $0" : : );
}
