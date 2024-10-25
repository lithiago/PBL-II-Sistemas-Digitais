int main(void) {
  // --------------------- TESTE DA MUDANÇA DE TELA COM OS BOTÕES -------------------------------------
  volatile u64_t *KEY_ptr;
  u64_t fd = -1;
  void *LW_virtual;

  fd = open("/dev/mem", (O_RDWR | O_SYNC));
  if (fd == -1) {
    return -1;
  }

  LW_virtual = mmap(NULL, LW_BRIDGE_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, LW_BRIDGE_BASE);

  if (LW_virtual == MAP_FAILED) {
    close(fd);
    return -1;
  }

  KEY_ptr = (u64_t *)(LW_virtual + KEY_BASE);

  u64_t state_game;

  state_game = 0;

  while (1) {
    if (*KEY_ptr == 0b1111) {
      // state_game = 0;
      // Mantem o estado anterior
    } else if (*KEY_ptr == 0b1110) {
      state_game = 1;
      change_state(state_game);
    } else if (*KEY_ptr == 0b1101) {
      state_game = 2;
      change_state(state_game);
    } else if (*KEY_ptr == 0b1011) {
      state_game = 3;
      change_state(state_game);
    }
  }

  if (munmap(LW_virtual, LW_BRIDGE_SPAN) != 0) {
    return -1;
  }

  close(fd);
