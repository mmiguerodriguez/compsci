/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
*/

#include "i386.h"
#include "game.h"
#include "task.h"
#include "defines.h"
#include "tss.h"

// True / False
#define IS_RICK(task_idx)         (task_idx == 0 || task_idx == 2)
#define IS_MORTY(task_idx)        (task_idx == 1 || task_idx == 3)
#define IS_CRONENBERG(task_idx)   (task_idx >= 4 && task_idx <= 23)

#define MORTY_OF_RICK(task_idx)   (task_idx + 1)
#define RICK_OF_MORTY(task_idx)   (task_idx - 1)
#define TASK_IDX(task_id)         (task_id - 15)

uint16_t* screen_mem = (uint16_t*) (VIDEO);
uint16_t screen_backup[SIZE_X * (SIZE_Y + 1)];

uint32_t* debug_info;

void game_init() {
  *debug_info = FALSE;

  screen_init();

  game_finished = FALSE;
  g.minds_rick_c137 = 2;
  g.minds_rick_d248 = 2;

  for (uint8_t i = 0; i < SIZE_X; i++) {
    for (uint8_t j = 0; j < SIZE_Y; j++) {
      g.has_cronenberg[i][j] = FALSE;
      g.cronenberg_idx[i][j] = 0;
    }
  }

  for (uint8_t i = 0; i < 24; i++) {
    uint8_t x, y;
    getRandomPosition(i, &x, &y);

    struct pos p;
    p.x = x;
    p.y = y;

    struct pos portal;
    portal.x = x;
    portal.y = y;

    struct task t;
    t.alive = TRUE;
    t.portal = portal;
    t.position = p;
    t.used_portal = FALSE; // Se usa solo para ricks
    t.count_portal = 0; // Se usa para comportamiento de mortys

    if (i == 0) {
      t.type = RickC137;
      t.cr3 = tss_init_task(TASK_RICK_C137, 15, x, y);
    } else if (i == 1) {
      t.type = MortyC137;
      t.cr3 = tss_init_task(TASK_MORTY_C137, 16, x, y);
    } else if (i == 2) {
      t.type = RickD248;
      t.cr3 = tss_init_task(TASK_RICK_D248, 17, x, y);
    } else if (i == 3) {
      t.type = MortyD248;
      t.cr3 = tss_init_task(TASK_MORTY_D248, 18, x, y);
    } else {
      t.type = Cronenberg;
      t.cr3 = tss_init_task(TASK_CRONENBERG, i + 15, x, y);
      g.has_cronenberg[x][y] = TRUE;
      g.cronenberg_idx[x][y] = i + 15;
    }

    g.task[i] = t;
  }
}

void game_enable_debug_mode() {
  debug_mode = TRUE;
}

void game_disable_debug_mode() {
  debug_mode = FALSE;
}

void game_backup_screen() {
  for (uint32_t i = 0; i < SIZE_X * (SIZE_Y + 1); i++) {
    screen_backup[i] = screen_mem[i];
  }
}

void game_restore_screen() {
  for (uint32_t i = 0; i < SIZE_X * (SIZE_Y + 1); i++) {
    screen_mem[i] = screen_backup[i];
  }
}

void game_save_exception_info(uint32_t* info) {
  debug_info = info;
}

void game_show_debug_info() {
  game_backup_screen();
  print_debug_info(debug_info);
  showing_exception = TRUE;
}

void game_hide_debug_info() {
  game_restore_screen();
  showing_exception = FALSE;
}


uint32_t game_usePortalGun(int32_t x, int32_t y, uint32_t cross, uint32_t withMorty) {
  uint32_t task_idx = TASK_IDX(current_task_idx);
  // Solo podemos usar el portal si no lo usamos en el anterior tick (ricks)
  if (g.task[task_idx].used_portal == FALSE) {
    // Si es una tarea rick entonces le seteamos que lo esta usando y le sumamos
    // al contador de cuantas veces lo uso (para saber cuando lo puede usar el morty)
    if (IS_RICK(task_idx) == 1) {
      g.task[task_idx].used_portal = TRUE;
      g.task[task_idx].count_portal++;
    } else if (IS_MORTY(task_idx)) {
      // Si es una tarea morty, comprobamos que su rick haya usado su portal al
      // menos 10 veces
      if (g.task[RICK_OF_MORTY(task_idx)].count_portal < 10) {
        return 0x0;
      } else {
        // Restauramos la cantidad de veces que uso el portal rick desde la
        // ultima llamada de un morty
        g.task[RICK_OF_MORTY(task_idx)].count_portal = 0;
      }
    } else {
      return 0x0;
    }

    uint32_t cr3 = rcr3();

    struct pos newPos = g.task[task_idx].position;
    print_game(" ", g.task[task_idx].portal.x, g.task[task_idx].portal.y, C_BG_GREEN);

    newPos = game_nextPos(newPos, x, y);
    uint32_t dest_phy = MAP_START + (newPos.x * TASK_SIZE) + (newPos.y * SIZE_X * TASK_SIZE);

    if (cross == 0x1) {
      mmu_copyPage((uint32_t*)(0x08000000), dest_phy);
      mmu_copyPage((uint32_t*)(0x08000000 + PAGE_SIZE), dest_phy + PAGE_SIZE);

      mmu_unmapPage(cr3, 0x08000000);
      mmu_unmapPage(cr3, 0x08001000);

      mmu_mapPage(cr3, 0x08000000, dest_phy, PAG_P | PAG_RW | PAG_US);
      mmu_mapPage(cr3, 0x08001000, dest_phy + PAGE_SIZE, PAG_P | PAG_RW | PAG_US);

      print_game(" ", g.task[task_idx].position.x, g.task[task_idx].position.y, C_BG_GREEN);

/*
      if (g.has_cronenberg[newPos.x][newPos.y] == TRUE) {
        g.has_cronenberg[newPos.x][newPos.y] = FALSE;
        g.task[TASK_IDX(g.cronenberg_idx[newPos.x][newPos.y])].alive = FALSE;
      }
*/
      g.task[task_idx].position = newPos;
      g.task[task_idx].portal = newPos;
    } else {
      g.task[task_idx].portal = game_nextPos(g.task[task_idx].position, x, y);
      dest_phy = MAP_START + (g.task[task_idx].portal.x * TASK_SIZE) + (g.task[task_idx].portal.y * SIZE_X * TASK_SIZE);

      mmu_mapPage(cr3, 0x08002000, dest_phy, PAG_P | PAG_RW | PAG_US);
      mmu_mapPage(cr3, 0x08002000 + PAGE_SIZE, dest_phy + PAGE_SIZE, PAG_P | PAG_RW | PAG_US);
    }

    if (IS_RICK(task_idx) && withMorty) {
      uint32_t morty_idx = MORTY_OF_RICK(task_idx);
      uint32_t morty_cr3 = g.task[morty_idx].cr3;

      // g.task.position => siempre tiene x e y correctos
      struct pos newPosMorty = game_nextPos(g.task[morty_idx].position, x, y);
      uint32_t dest_morty_phy = MAP_START + (newPosMorty.x * TASK_SIZE) + (newPosMorty.y * SIZE_X * TASK_SIZE);
      print_game(" ", g.task[morty_idx].portal.x, g.task[morty_idx].portal.y, C_BG_GREEN);

      lcr3(morty_cr3);

      if (cross == 0x1) {
        mmu_copyPage((uint32_t*)(0x08000000), dest_morty_phy);
        mmu_copyPage((uint32_t*)(0x08000000 + PAGE_SIZE), dest_morty_phy + PAGE_SIZE);

        mmu_unmapPage(morty_cr3, 0x08000000);
        mmu_unmapPage(morty_cr3, 0x08001000);

        mmu_mapPage(morty_cr3, 0x08000000, dest_morty_phy, PAG_P | PAG_RW | PAG_US);
        mmu_mapPage(morty_cr3, 0x08001000, dest_morty_phy + PAGE_SIZE, PAG_P | PAG_RW | PAG_US);

        // borramos la antigue
        print_game(" ", g.task[morty_idx].position.x, g.task[morty_idx].position.y, C_BG_GREEN);

/*        if (g.has_cronenberg[newPosMorty.x][newPosMorty.y] == TRUE) {
          g.has_cronenberg[newPosMorty.x][newPosMorty.y] = FALSE;
          g.task[TASK_IDX(g.cronenberg_idx[newPosMorty.x][newPosMorty.y])].alive = FALSE;
        }
*/
        g.task[morty_idx].position = newPosMorty;
        g.task[morty_idx].portal = newPosMorty;
      } else {
        struct pos newPosFromRickPortal = game_nextPos(g.task[MORTY_OF_RICK(task_idx)].position, x, y);
        dest_morty_phy = MAP_START + (newPosFromRickPortal.x * TASK_SIZE) + (newPosFromRickPortal.y * SIZE_X * TASK_SIZE);

        mmu_mapPage(morty_cr3, 0x08002000, dest_morty_phy, PAG_P | PAG_RW | PAG_US);
        mmu_mapPage(morty_cr3, 0x08002000 + PAGE_SIZE, dest_morty_phy + PAGE_SIZE, PAG_P | PAG_RW | PAG_US);
      }

      lcr3(cr3);
    }

    return 0x1;
  }

  return 0x0;
}

struct pos game_nextPos(struct pos p, int32_t x, int32_t y) {
  struct pos new_pos;
  uint8_t newX = (uint8_t)((int32_t)p.x + x);
  uint8_t newY = (uint8_t)((int32_t)p.y + y);

  if (newX >= SIZE_X) {
    newX = 0;
  }

  if (newY >= SIZE_Y) {
    newY = newY%SIZE_Y;
  }

  new_pos.x = newX;
  new_pos.y = newY;

  return new_pos;
}

void game_whereIsMorty(int32_t* pos) {
  // [0] = x => eax
  // [1] = y => ebx
  uint32_t task_idx = TASK_IDX(current_task_idx);

  if (IS_MORTY(task_idx) || IS_CRONENBERG(task_idx)) return;

  int32_t xRick = g.task[task_idx].position.x;
  int32_t yRick = g.task[task_idx].position.y;
  int32_t xMorty = g.task[MORTY_OF_RICK(task_idx)].position.x;
  int32_t yMorty = g.task[MORTY_OF_RICK(task_idx)].position.y;

  if (xRick > xMorty) {
    pos[0] = xRick - xMorty;
  } else {
    pos[0] = xMorty - xRick;
  }

  pos[1] = yMorty - yRick;
}

void game_enablePortalGuns() {
  g.task[0].used_portal = FALSE;
  g.task[2].used_portal = FALSE;
}

void game_IamRick(uint16_t code) {
  uint32_t task_idx = TASK_IDX(current_task_idx);

  if (code == 0xC137) {
    if (g.task[task_idx].type == RickD248 || g.task[task_idx].type == MortyD248) {
      g.task[task_idx].alive = FALSE;
    }
    if (g.task[task_idx].type == RickC137 || g.task[task_idx].type == MortyC137){
        return;
    }

    if (g.task[task_idx].type != CronenbergC137 && g.task[task_idx].alive == TRUE) {
      if (g.task[task_idx].type == CronenbergD248 && g.task[task_idx].alive == TRUE){
        g.minds_rick_d248--;
      }

      g.minds_rick_c137++;
      g.task[task_idx].type = CronenbergC137;
    }
  } else if (code == 0xD248) {
    if (g.task[task_idx].type == RickC137 || g.task[task_idx].type == MortyC137) {
      g.task[task_idx].alive = FALSE;
    }
    if (g.task[task_idx].type == RickD248 || g.task[task_idx].type == MortyD248){
        return;
    }

    if (g.task[task_idx].type != CronenbergD248 && g.task[task_idx].alive == TRUE) {
      if (g.task[task_idx].type == CronenbergC137 && g.task[task_idx].alive == TRUE) {
        g.minds_rick_c137--;
      }

      g.minds_rick_d248++;
      g.task[task_idx].type = CronenbergD248;
    }
  }
}

void game_kill_current_task() {
  uint32_t task_idx = TASK_IDX(current_task_idx);

  if (IS_CRONENBERG(task_idx)) {
    g.task[task_idx].alive = FALSE;
    struct pos p = g.task[task_idx].position;
    g.has_cronenberg[p.x][p.y] = FALSE;

    if (g.task[task_idx].type == CronenbergC137) {
      g.minds_rick_c137--;
    } else if (g.task[task_idx].type == CronenbergD248) {
      g.minds_rick_d248--;
    }
  }
}

uint32_t game_checkEndOfGame() {
  uint32_t gameFinished = TRUE;

  for (uint8_t i = 4; i < 24; i++) {
    if (g.task[i].alive && g.task[i].type == Cronenberg) {
      gameFinished = FALSE;
    }
  }

  for (uint8_t i = 0; i < 4; i++) {
    if (!g.task[i].alive) {
      gameFinished = TRUE;
    }
  }

  if (gameFinished == TRUE) {
    screen_print_winners();
    game_finished = gameFinished;
  }

  return gameFinished;
}
