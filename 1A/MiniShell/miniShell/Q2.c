#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "readcmd.h"
#include "readcmd.c"


int main(int argc, char *argv[]) {
    pid_t fils;
    while (1){
     struct cmdline *commande;
     /* Lire la commande. */
      do {
        commande = readcmd();
   
         } while (commande->seq[0] == NULL);
      fils = fork();
   // Si le fork échoue
      if ( fils < 0 ) {
         printf("Erreur fork failed\n");
         exit(1); 
   // SI le fork fonctionne 
    } else if (fils ==0) { 
            /* Execution de la commande */
	      execvp(commande ->seq[0][0],commande -> seq[0]);	
           exit(0);

    } else { // Père
         }
  }
        
      
 
   
}
