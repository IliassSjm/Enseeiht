#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "readcmd.h"
#include "readcmd.c"
#include <sys/wait.h>
#include "liste.h"
#include "liste.c"

int main(int argc, char *argv[]) {
    List *liste;
    liste= malloc(500);
    pid_t fils; // Processus fils 
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

      if (commande->backgrounded == NULL) {
           int wstatut;
           waitpid(fils, &wstatut,WUNTRACED);
           if (!WIFSTOPPED(wstatut)) {
                 delete_proc(liste, fils);
            }
         }
  }
        
      
 }
   
}
