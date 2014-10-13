#include <stdio.h>

__attribute__((constructor))
static void thingInit() {
    printf("Init!\n");
}

int main() {
    printf("Main!\n");
    return 0;
}
