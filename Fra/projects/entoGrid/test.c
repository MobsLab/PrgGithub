#include <stdio.h>

int main(int argc, char *argv[])
{
  int i;
  int j;
  
  int T = 10;
  printf("## %d\n", 10 % 10);
  


  for(j=0; j<T; j++)
    {
      for(i = (j)%T; i != j; i++, i %= T)
	printf("%d\n", i);
      printf("#########\n\n");
    }
  
}

