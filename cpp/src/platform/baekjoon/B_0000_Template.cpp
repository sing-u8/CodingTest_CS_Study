#include "../../lib/io.hpp"

int main() {
    IO io;
    int a = io.readInt(), b = io.readInt();
    printf("%d\n", a + b);
}
