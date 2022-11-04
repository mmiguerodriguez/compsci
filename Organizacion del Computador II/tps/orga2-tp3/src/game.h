/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#ifndef __GAME_H__
#define __GAME_H__

#include "stdint.h"
#include "defines.h"
#include "screen.h"
#include "mmu.h"
#include "sched.h"

typedef enum e_taskType {
    RickC137       = 1,
    MortyC137      = 2,
    RickD248       = 3,
    MortyD248      = 4,
    Cronenberg     = 5,
    CronenbergC137 = 6,
    CronenbergD248 = 7,
} e_taskType_t;

struct game g;

struct pos {
  uint8_t x;
  uint8_t y;
};

struct task {
  struct pos portal;
  struct pos position;
  e_taskType_t type;
  uint32_t cr3;
  char alive;
  char used_portal;
  uint8_t count_portal;
};

struct game {
  struct task task[25];
  char has_cronenberg[SIZE_X][SIZE_Y];
  int16_t cronenberg_idx[SIZE_X][SIZE_Y];
  uint32_t minds_rick_c137;
  uint32_t minds_rick_d248;
};

char game_finished;

void game_init();
void game_backup_screen();
void game_restore_screen();

void game_save_exception_info();
void game_enable_debug_mode();
void game_disable_debug_mode();

void game_show_debug_info();
void game_hide_debug_info();
void game_kill_current_task();

uint32_t game_usePortalGun(int32_t x, int32_t y, uint32_t cross, uint32_t withMorty);
// void game_whereIsMorty();
void game_whereIsMorty(int32_t* pos);
void game_IamRick(uint16_t code);

void game_enablePortalGuns();
struct pos game_nextPos(struct pos p, int32_t x, int32_t y);

#endif  /* !__GAME_H__ */
