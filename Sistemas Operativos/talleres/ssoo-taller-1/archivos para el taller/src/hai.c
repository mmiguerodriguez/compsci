#include <signal.h> /* constantes como SIGINT*/
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/reg.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

// modificar hijo

int contador = 0;

void handler_hijo() {
  contador++;
	printf("ya va!\n");
}

void handler_padre() {
	exit(0);
}

int main(int argc, char* argv[]) {
	pid_t pid_hijo = fork();
	if (pid_hijo == 0) { // codigo del hijo
	  
	  signal(SIGURG, handler_hijo);
	  while(1) {
  		if (contador == 5) {
	  		kill(getppid(), SIGINT);
	  		execvp(argv[1], argv+1);
			}
   	} // mantener al hijo con vida
	} else { // codigo del padre
		signal(SIGINT, handler_padre);
  	for (int i = 0; i < 5; i++) { // llamar al hijo...
  		printf("sup!\n");
  		kill(pid_hijo, SIGURG);
  		sleep(1);
  	}
	}
	return 0;
}
