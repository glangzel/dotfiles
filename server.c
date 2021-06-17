#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define PORT 3000

int main(){
    int fd_socket, fd_accept;
    socklen_t len;
    struct  sockaddr_in addr;
    char buff[BUFSIZ]; 
    
    if((fd_socket = socket(AF_INET, SOCK_STREAM, 0)) == -1){
        perror("server: socket");
        return 1;
    }

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(PORT);
    
    if (bind(fd_socket, (struct sockaddr *)&addr, sizeof(addr)) == -1){
        perror("server: bind");
        return 1;
    }

    if(listen(fd_socket, 5) == -1){
        perror("server: listen");
        return 1;
    }

    if ((fd_accept = accept(fd_socket, (struct sockaddr *)&addr, &len)) == -1){
        perror("server: accept");
        return 1;
    }

    if (read(fd_accept, buff, BUFSIZ) == -1){
        perror("server: read");
        return 1;
    }

    strcat(buff, " is received message.");
    if (wtite(fd_accept, buff, strlen(buff) + 1) == -1){
        perror("server: write");
        return 1;
    }

    close(fd_accept);
    close(fd_socket);
    return 0;
}