#include <stdio.h>


struct aa {
	int i;
	char c[1];
}__attribute__((packed)) a;

int main()
{
	strcpy(a);
	printf("%d\n", sizeof(a));
}
