#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <maps.h>

extern int createMappingMemory();

int main() {
    int fd;
    if(fd = createMappingMemory() > 0){
        printf("Ok");
    }else{
        printf("Fail");
    }
}
