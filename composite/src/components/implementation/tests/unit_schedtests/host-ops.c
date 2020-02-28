#include <assert.h>
#include <cos_types.h>

//TODO: Ask gabe what we should use
static void print(const char *str, int len)
{
  assert(0);
}

static void panic(void)
{
  assert(0);
}

struct lkl_sem {
  unsigned int size;
  unsigned int read;
  unsigned write;
  CAP_THD * threads;
}

  


static struct lkl_sem *sem_alloc(int count)
{

  lkl_sem* semPtr;
  
  cos_meminfo_alloc(struct cos_compinfo *ci, semPtr, sizeof(lkl_sem));

  cos_meminfo_alloc(struct cos_compinfo *ci, semPtr->threads, sizeof(CAP_THD)*count);

  
  return semPtr;

}



