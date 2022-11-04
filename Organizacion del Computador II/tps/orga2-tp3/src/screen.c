/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del scheduler
*/

#include "screen.h"

void print(const char* text, uint32_t x, uint32_t y, uint16_t attr) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO; // magia
    int32_t i;
    for (i = 0; text[i] != 0; i++) {
        p[y][x].c = (uint8_t) text[i];
        p[y][x].a = (uint8_t) attr;
        x++;
        if (x == VIDEO_COLS) {
            x = 0;
            y++;
        }
    }
}

void print_dec(uint32_t numero, uint32_t size, uint32_t x, uint32_t y, uint16_t attr) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO; // magia
    uint32_t i;
    uint8_t letras[16] = "0123456789";

    for(i = 0; i < size; i++) {
        uint32_t resto  = numero % 10;
        numero = numero / 10;
        p[y][x + size - i - 1].c = letras[resto];
        p[y][x + size - i - 1].a = attr;
    }
}

void print_hex(uint32_t numero, int32_t size, uint32_t x, uint32_t y, uint16_t attr) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO; // magia
    int32_t i;
    uint8_t hexa[8];
    uint8_t letras[16] = "0123456789ABCDEF";
    hexa[0] = letras[ ( numero & 0x0000000F ) >> 0  ];
    hexa[1] = letras[ ( numero & 0x000000F0 ) >> 4  ];
    hexa[2] = letras[ ( numero & 0x00000F00 ) >> 8  ];
    hexa[3] = letras[ ( numero & 0x0000F000 ) >> 12 ];
    hexa[4] = letras[ ( numero & 0x000F0000 ) >> 16 ];
    hexa[5] = letras[ ( numero & 0x00F00000 ) >> 20 ];
    hexa[6] = letras[ ( numero & 0x0F000000 ) >> 24 ];
    hexa[7] = letras[ ( numero & 0xF0000000 ) >> 28 ];
    for(i = 0; i < size; i++) {
        p[y][x + size - i - 1].c = hexa[i];
        p[y][x + size - i - 1].a = attr;
    }
}

void screen_drawBox(uint32_t fInit,
                    uint32_t cInit,
                    uint32_t fSize,
                    uint32_t cSize,
                    uint8_t character,
                    uint8_t attr ) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) VIDEO;
    uint32_t f;
    uint32_t c;
    for (f = fInit; f < fInit+fSize; f++) {
    for (c = cInit; c < cInit+cSize; c++) {
          p[f][c].c = character;
          p[f][c].a = attr;
    }}
}

void print_scancode(uint8_t scancode) {
  if (!(scancode & 0x80)) {
    scancode = scancode & 0x7F;
    if (scancode >= 0x02 && scancode <= 0x0B) {
      if (scancode == 0x0B) {
        scancode = 0;
      } else {
        scancode -= 1;
      }
      print_hex(scancode, 2, 78, 0, C_FG_WHITE | C_BG_BLACK);
    }

    // Letra "y", toggle debug
    if (scancode == 0x15) {
      if (!debug_mode) {
        game_enable_debug_mode();
      } else {
        if (showing_exception) {
          game_hide_debug_info();
        } else {
          game_disable_debug_mode();
        }
      }

    }
  }
}

// Esto se puede hacer mas lindo?
void print_debug_info(uint32_t* info) {
  uint32_t x = 26;
  uint32_t y = 2;
  uint16_t attr = C_FG_WHITE | C_BG_RED;

  // Codigo para dibujar caja para excepciones
  screen_drawBox(0, 25, 41, 30, 0, C_BG_BLACK);
  screen_drawBox(2, 26, 1, 28, 0, C_BG_RED);
  screen_drawBox(4, 26, 36, 28, 0, C_BG_LIGHT_GREY);

  print("MODO DEBUG", 35, 0, C_FG_WHITE | C_BG_BLACK);

  uint16_t attr_name = C_FG_BLACK | C_BG_LIGHT_GREY;
  uint16_t attr_value = C_FG_WHITE | C_BG_LIGHT_GREY;

  print("eax", 27, 6, attr_name);
  print("ebx", 27, 8, attr_name);
  print("ecx", 27, 10, attr_name);
  print("edx", 27, 12, attr_name);
  print("esi", 27, 14, attr_name);
  print("edi", 27, 16, attr_name);
  print("ebp", 27, 18, attr_name);
  print("esp", 27, 20, attr_name);
  print("eip", 27, 22, attr_name);

  print("cs", 28, 24, attr_name);
  print("ds", 28, 26, attr_name);
  print("es", 28, 28, attr_name);
  print("fs", 28, 30, attr_name);
  print("gs", 28, 32, attr_name);
  print("ss", 28, 34, attr_name);
  print("eflags", 28, 37, attr_name);

  print("cr0", 40, 7, attr_name);
  print("cr2", 40, 9, attr_name);
  print("cr3", 40, 11, attr_name);
  print("cr4", 40, 13, attr_name);
  print("stack", 40, 27, attr_name);

  if (info == 0) {
    print("Sin excepciones", x, y, attr);
    print_hex(0, 8, 31, 6, attr_value); // eax
    print_hex(0, 8, 31, 8, attr_value); // ebx
    print_hex(0, 8, 31, 10, attr_value); // ecx
    print_hex(0, 8, 31, 12, attr_value); // edx
    print_hex(0, 8, 31, 14, attr_value); // esi
    print_hex(0, 8, 31, 16, attr_value); // edi
    print_hex(0, 8, 31, 18, attr_value); // ebp
    print_hex(0, 8, 31, 20, attr_value); // esp
    print_hex(0, 8, 31, 22, attr_value); // eip

    print_hex(0, 4, 31, 24, attr_value); // cs
    print_hex(0, 4, 31, 26, attr_value); // ds
    print_hex(0, 4, 31, 28, attr_value); // es
    print_hex(0, 4, 31, 30, attr_value); // fs
    print_hex(0, 4, 31, 32, attr_value); // gs
    print_hex(0, 4, 31, 34, attr_value); // ss
    print_hex(0, 8, 35, 37, attr_value); // eflags

    print_hex(0, 8, 44, 7, attr_value); // cr0
    print_hex(0, 8, 44, 9, attr_value); // cr2
    print_hex(0, 8, 44, 11, attr_value); // cr3
    print_hex(0, 8, 44, 13, attr_value); // cr4

    for (uint8_t i = 29; i < 34; i++) {
      print_hex(0, 8, 40, i, attr_value);
    }
  } else {
    if (info[0] == 0) {
      print(EXCEPTION_0, x, y, attr);
    } else if (info[0] == 1) {
      print(EXCEPTION_1, x, y, attr);
    } else if (info[0] == 2) {
      print(EXCEPTION_2, x, y, attr);
    } else if (info[0] == 3) {
      print(EXCEPTION_3, x, y, attr);
    } else if (info[0] == 4) {
      print(EXCEPTION_4, x, y, attr);
    } else if (info[0] == 5) {
      print(EXCEPTION_5, x, y, attr);
    } else if (info[0] == 6) {
      print(EXCEPTION_6, x, y, attr);
    } else if (info[0] == 7) {
      print(EXCEPTION_7, x, y, attr);
    } else if (info[0] == 8) {
      print(EXCEPTION_8, x, y, attr);
    } else if (info[0] == 9) {
      print(EXCEPTION_9, x, y, attr);
    } else if (info[0] == 10) {
      print(EXCEPTION_10, x, y, attr);
    } else if (info[0] == 11) {
      print(EXCEPTION_11, x, y, attr);
    } else if (info[0] == 12) {
      print(EXCEPTION_12, x, y, attr);
    } else if (info[0] == 13) {
      print(EXCEPTION_13, x, y, attr);
    } else if (info[0] == 14) {
      print(EXCEPTION_14, x, y, attr);
    } else if (info[0] == 15) {
      print(EXCEPTION_15, x, y, attr);
    } else if (info[0] == 16) {
      print(EXCEPTION_16, x, y, attr);
    } else if (info[0] == 17) {
      print(EXCEPTION_17, x, y, attr);
    } else if (info[0] == 18) {
      print(EXCEPTION_18, x, y, attr);
    } else if (info[0] == 19) {
      print(EXCEPTION_19, x, y, attr);
    }
    // exception opcode [0]
    // cr4 [1]
    // cr3 [2]
    // cr2 [3]
    // cr0 [4]
    // fs [5]
    // ss [6]
    // gs [7]
    // es [8]
    // ds [9]
    // cs [10]
    // eflags [11]
    // eip [12]
    // edi [13]
    // esi [14]
    // ebp [15]
    // esp [16]
    // ebx [17]
    // edx  [18]
    // ecx [19]
    // eax [20]

    print_hex(info[20], 8, 31, 6, attr_value); // eax
    print_hex(info[17], 8, 31, 8, attr_value); // ebx
    print_hex(info[19], 8, 31, 10, attr_value); // ecx
    print_hex(info[18], 8, 31, 12, attr_value); // edx
    print_hex(info[14], 8, 31, 14, attr_value); // esi
    print_hex(info[13], 8, 31, 16, attr_value); // edi
    print_hex(info[15], 8, 31, 18, attr_value); // ebp
    print_hex(info[16], 8, 31, 20, attr_value); // esp
    print_hex(info[12], 8, 31, 22, attr_value); // eip

    print_hex(info[10], 4, 31, 24, attr_value); // cs
    print_hex(info[9], 4, 31, 26, attr_value); // ds
    print_hex(info[8], 4, 31, 28, attr_value); // es
    print_hex(info[5], 4, 31, 30, attr_value); // fs
    print_hex(info[7], 4, 31, 32, attr_value); // gs
    print_hex(info[6], 4, 31, 34, attr_value); // ss
    print_hex(info[11], 8, 35, 37, attr_value); // eflags

    print_hex(info[4], 8, 44, 7, attr_value); // cr0
    print_hex(info[3], 8, 44, 9, attr_value); // cr2
    print_hex(info[2], 8, 44, 11, attr_value); // cr3
    print_hex(info[1], 8, 44, 13, attr_value); // cr4

    uint32_t* stack = (uint32_t*) info[16];
    for (uint8_t i = 29; i < 34; i++) {
      print_hex(*stack, 8, 40, i, attr_value);
      stack++;
    }
  }
}

void print_game(const char* text, uint32_t x, uint32_t y, uint16_t attr) {
    ca (*p)[VIDEO_COLS] = (ca (*)[VIDEO_COLS]) (VIDEO + 80 * 2); // magia
    int32_t i;
    for (i = 0; text[i] != 0; i++) {
        p[y][x].c = (uint8_t) text[i];
        p[y][x].a = (uint8_t) attr;
        x++;
        if (x == VIDEO_COLS) {
            x = 0;
            y++;
        }
    }
}

void screen_drawTasks() {
  // print_hex(debug_mode, 1, 70, 0, C_FG_WHITE | C_BG_BLACK);
  // print_hex(showing_exception, 1, 72, 0, C_FG_WHITE | C_BG_BLACK);
  if (showing_exception == TRUE || game_finished == TRUE) return;

  for (uint8_t i = 0; i < 24; i++) {
    struct pos p = g.task[i].position;
    struct pos portal = g.task[i].portal;
    e_taskType_t type = g.task[i].type;
    char alive = g.task[i].alive;

    uint16_t color_bg = C_FG_WHITE;

    print_dec(g.minds_rick_c137, 7, 4, 45, C_FG_WHITE | C_BG_BLUE);
    print_dec(g.minds_rick_d248, 7, 69, 45, C_FG_WHITE | C_BG_RED);

    if (alive == TRUE) {
      if (type == RickC137) {
        color_bg |= C_BG_BLUE;
        print_game("R", p.x, p.y, color_bg);

        if (portal.x != p.x || portal.y != p.y) {
          color_bg = C_FG_LIGHT_CYAN | C_BG_GREEN;
          print_game("*", portal.x, portal.y, color_bg);
        }
      } else if (type == MortyC137) {
        color_bg |= C_BG_BLUE;
        print_game("M", p.x, p.y, color_bg);

        if (portal.x != p.x || portal.y != p.y) {
          color_bg = C_FG_LIGHT_CYAN | C_BG_GREEN;
          print_game("*", portal.x, portal.y, color_bg);
        }
      } else if (type == RickD248) {
        color_bg |= C_BG_RED;
        print_game("R", p.x, p.y, color_bg);

        if (portal.x != p.x || portal.y != p.y) {
          color_bg = C_FG_LIGHT_CYAN | C_BG_GREEN;
          print_game("*", portal.x, portal.y, color_bg);
        }
      } else if (type == MortyD248) {
        color_bg |= C_BG_RED;
        print_game("M", p.x, p.y, color_bg);

        if (portal.x != p.x || portal.y != p.y) {
          color_bg = C_FG_LIGHT_CYAN | C_BG_GREEN;
          print_game("*", portal.x, portal.y, color_bg);
        }
      } else if (type == Cronenberg) {
        color_bg |= C_BG_BROWN;
        print_game("+", p.x, p.y, color_bg);
      } else if (type == CronenbergC137) {
        color_bg |= C_BG_BLUE;
        print_game("+", p.x, p.y, color_bg);
      } else if (type == CronenbergD248) {
        color_bg |= C_BG_RED;
        print_game("+", p.x, p.y, color_bg);
      }
    } else {
      if (type == RickC137 || type == RickD248 || type == MortyC137 || type == MortyD248) {
        print_game(" ", portal.x, portal.y, C_BG_GREEN);
      }
      print_game(" ", p.x, p.y, C_BG_GREEN);
    }
  }
}

void screen_init() {
  uint8_t i = 0x00;
  uint8_t x = 20;
  uint8_t y = 43;
  uint16_t attrs = C_FG_DARK_GREY | C_BG_BLACK;

  while (i < 20) {
    if (i == 10) {
      x = 20;
      y += 3;
    }

    print_dec(i, 2, x, y, attrs);

    i++;
    x += 4;
  }
}

char clock[] = {'|','/','-','\\'};
int clockIdx = 0;

void screen_incTaskClocks() {
  if (showing_exception == TRUE || game_finished == TRUE) return;

  clockIdx++;
  if (clockIdx == 4) {
    clockIdx = 0;
  }

  char c[] = {0, 0};

  uint8_t x = 20;
  uint8_t y = 44;
  uint16_t attrs = C_FG_MAGENTA | C_BG_BLACK;

  for (uint8_t i = 0; i < 20; i++) {
    if (i == 10) {
      x = 20;
      y += 3;
    }

    struct task cronenberg = g.task[i + 4];
    if (cronenberg.alive == TRUE) {
      if (cronenberg.type == Cronenberg) {
         c[0] = clock[clockIdx];
         attrs = C_FG_WHITE | C_BG_BLACK;
      } else if (cronenberg.type == CronenbergC137) {
        c[0] = 219; // black square
        attrs = C_FG_BLUE | C_BG_BLACK;
      } else if (cronenberg.type == CronenbergD248) {
        c[0] = 219; // black square
        attrs = C_FG_RED | C_BG_BLACK;
      }
    } else if (cronenberg.alive == FALSE) {
      c[0] = 'X';
      attrs = C_FG_RED | C_BG_BLACK;
    }

    print(c, x, y, attrs);


    x += 4;
  }
}

void screen_print_winners() {
  uint32_t rick_c137_idx = 0;
  uint32_t morty_c137_idx = 1;
  uint32_t rick_d248_idx = 2;
  uint32_t morty_d248_idx = 3;

  uint16_t winner = 0x0000;

  if (g.task[rick_c137_idx].alive == FALSE || g.task[morty_c137_idx].alive == FALSE) {
    winner = 0xD248;
  }

  if (g.task[rick_d248_idx].alive == FALSE || g.task[morty_d248_idx].alive == FALSE) {
    winner = 0xC137;
  }

  if (winner == 0x0000) {
    if (g.minds_rick_c137 > g.minds_rick_d248) {
      winner = 0xC137;
    } else if (g.minds_rick_c137 < g.minds_rick_d248) {
      winner = 0xD248;
    }
  }

  screen_drawBox(10, 20, 20, 40, 0, C_BG_BLACK);

  if (winner == 0x0000) {
    print("EMPATE", 33, 20, C_FG_WHITE | C_BG_BLACK);
  } else {
    print("GANADOR:", 33, 20, C_FG_WHITE | C_BG_BLACK);
    if (winner == 0xC137) {
      print("C-137", 42, 20, C_FG_WHITE | C_BG_BLACK);
    } else if (winner == 0xD248) {
      print("C-248", 42, 20, C_FG_WHITE | C_BG_BLACK);
    }
  }
}
