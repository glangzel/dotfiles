#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define PORT 3000

int main(int argc, char *argv[]){
    int fd_socket;
    struct sockaddr_in addr;
    char buff[BUFSIZ];

    if((fd_socket = socket(AF_INET, SOCK_STREAM, 0)) == -1){
        perror("client: socket");
        return 1;
    }
    
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    addr.sin_port = htons(PORT);
    
    if (connect(fd_socket, (struct sockaddr *)&addr, sizeof(addr)) == -1){
        perror("client: connect");
        return 1;
    }

    if (wtite(fd_socket, argv[1], strlen(argv[1]) + 1) == -1){
        perror("client: write");
        return 1;
    }

    if (read(fd_socket, buff, BUFSIZ) == -1){
        perror("client: read");
        return 1;
    }

    printf("message from server: %s\n, buff");
    close(fd_socket);

    return 0;
}