#include <sys/socket.h>
#include <netinet/in.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <stdio.h>

// gcc -shared -fPIC -o $GUROBI_HOME/lib/redirect.so redirect.c -ldl -D_GNU_SOURCE

int (*orig_connect)(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen) {
    struct sockaddr_in *sa = (struct sockaddr_in *) addr;
    char *redirect;
    int port, to_port;
    if (!orig_connect) {
        orig_connect = dlsym(RTLD_NEXT, "connect");
    }
    redirect = getenv("REDIRECT");
    if (redirect != NULL) {
        if (sa->sin_addr.s_addr == htonl(INADDR_LOOPBACK)) {
            if (sscanf(redirect, "%d:%d", &port, &to_port) == 2) {
                if (ntohs(sa->sin_port) == port) {
                    sa->sin_port = htons(to_port);
                }
            }
        }
    }
    return orig_connect(sockfd, addr, addrlen);
}

