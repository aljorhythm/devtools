#include <iostream>

struct Parent {
    int i;
};

int main() {
    Parent* p = new Parent();
    p->i = 1;
    Parent q = *p;
    std::cout << p->i;
    p->i = 2;
    std::cout << (&q)->i;
}