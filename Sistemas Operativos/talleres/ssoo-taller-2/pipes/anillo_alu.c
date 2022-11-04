#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdbool.h>

/*
funcion/proceso inicial
crear n/n-1 procesos
conectar con el antecesor y con el sucesor para cada proceso
cada proceso tiene su pipe[2]

soy un proceso con un id:
write(pipe_procesos[id+1])
read(pipe_procesos[id-1])


*/


int main(int argc, char **argv) {	
	// srand(time(NULL));
		
	int start_number, start_pid, n;
	int buffer[1];
	if (argc != 4){ printf("Uso: anillo <n> <c> <s> \n"); exit(0);}
  
  n = atoi(argv[1]);
  start_number = atoi(argv[2]);
  start_pid = atoi(argv[3]);
  
  int pipes[n][2];
	
	// Creamos los pipes
	for (int i = 0; i < n; i++) {
		if (pipe(pipes[i]) == -1) {
			perror("pipe");
			exit(1);
		}
	}

	int proceso_actual = 0;

	for(int i = 1; i < n; i++) {
	  int child_pid = fork();
	  if (child_pid == 0) {
	  	// Cierro pipes que no me interesan para cada hijo
	  	close(pipes[i][0]); // read del mio
	  	close(pipes[i - 1][1]); // write del anterior
	  	
	  	for (int j = 0; j < n; j++) {
				if (j != i - 1 && j != i) {
					close(pipes[j][0]);
					close(pipes[j][1]);
				}
			}
			
	    proceso_actual = i;
	    break;
	  }
	}
	
	// proceso 1 
	// read pipe[0][0]
	// write pipe[1][1]
	// proceso 2
	// read pipe[1][0]
	// write pipe[2][1]
	
	// Solo cierro pipes del padre
	if (proceso_actual == 0) {
		close(pipes[0][0]); // read del actual
		close(pipes[n - 1][1]); // write del anterior
		
		for (int j = 0; j < n; j++) {
			if (j != n - 1 && j != 0) {
				close(pipes[j][0]);
				close(pipes[j][1]);
			}
		}
	}
	
	
	bool empezo = false;
	bool termino = false;
	int i = 0;
	int secreto = -1;
	
	// Loop se hace para cada proceso
	while (i < n && !termino) {	
    if (i == proceso_actual) {
		  int num_leido = 0;
		  int num_a_escribir = 0;
		 
			if (empezo || start_pid != proceso_actual) {
				if (i == 0) {
					if (read(pipes[n - 1][0], &num_leido, sizeof(int)) != sizeof(int)) {
						perror("read");
						exit(1);
					}
				} else {
					if (read(pipes[i - 1][0], &num_leido, sizeof(int)) != sizeof(int)) {
						perror("read");
						exit(1);
					}
				}
			}
			
		  if (start_pid == proceso_actual && !empezo) {
		  	secreto = 100;
		    num_a_escribir = start_number;
		    empezo = true;
		  } else {
		    num_a_escribir = num_leido + 1;
		  }
		  
		  if (start_pid == proceso_actual) {
		  	if (num_leido >= secreto) {
		  		int menosuno = -1;
		  		printf("Llegamos al nodo %i, con numero %i que es >= al secreto %i. FINALIZAMOS\n", i, num_leido, secreto);
		  		if (write(pipes[i][1], &menosuno, sizeof(int)) != sizeof(int)) {
						perror("write");
						exit(1);
					}
		  		termino = true;
		  		break;
		  	}
		  }
			
			if (num_leido == -1) {
				if (write(pipes[i][1], &num_leido, sizeof(int)) != sizeof(int)) {
					perror("write");
					exit(1);
				}
				termino = true;
			} else {
				if (write(pipes[i][1], &num_a_escribir, sizeof(int)) != sizeof(int)) {
					perror("write");
					exit(1);
				}
			}
	  }
		
		i += 1;
		i %= n;
	}
	
	// printf("termino: %i\n", termino);
	
	return 0;
}
