// clockres.c - get clock resolution of clock_gettime(2)
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <stdint.h>
#include <inttypes.h>

#ifdef USE_CLOCK_CYCLES
#include <sys/neutrino.h>
#include <sys/syspage.h>
#endif

#define CLOCKRES_VER_STR "0.2"

/* time measurement macros - Linux */

#define MY_CLK_TIMING_ID CLOCK_MONOTONIC

#ifdef USE_CLOCK_CYCLES
#define MY_TIME_DECL(var)  uint64_t var##_start, var##_end
#define MY_TIME_START(var) var##_start = ClockCycles()
#define MY_TIME_END(var)   var##_end = ClockCycles()
#define MY_TIME_GET_NS(var) ( (var##_end - var##_start)*1000000000/SYSPAGE_ENTRY(qtime)->cycles_per_sec  )
#else
#define MY_TIME_DECL(var)  struct timespec var##_start, var##_end
#define MY_TIME_START(var) clock_gettime(MY_CLK_TIMING_ID,&var##_start)
#define MY_TIME_END(var)   clock_gettime(MY_CLK_TIMING_ID,&var##_end)
#define MY_TIME_GET_NS(var) (  (var##_end.tv_sec * (uint64_t)(1000000000) + var##_end.tv_nsec) \
                                   -(var##_start.tv_sec * (uint64_t)(1000000000) + var##_start.tv_nsec) )
#endif

typedef struct {
	clockid_t clock_id;
	const char *clock_name;
} clock_table_t;

#define CLKRES_INIT_PAIR(CLK_NAME) { CLK_NAME, #CLK_NAME}

const clock_table_t MY_CLK_TABLE[] = {
		CLKRES_INIT_PAIR(CLOCK_REALTIME),
		CLKRES_INIT_PAIR(CLOCK_MONOTONIC)
#ifdef CLOCK_PROCESS_CPUTIME_ID
		,CLKRES_INIT_PAIR(CLOCK_PROCESS_CPUTIME_ID)
#endif
#ifdef CLOCK_THREAD_CPUTIME_ID
		,CLKRES_INIT_PAIR(CLOCK_THREAD_CPUTIME_ID)
#endif
#ifdef CLOCK_MONOTONIC_RAW
		,CLKRES_INIT_PAIR(CLOCK_MONOTONIC_RAW)
#endif
#ifdef CLOCK_REALTIME_COARSE
		,CLKRES_INIT_PAIR(CLOCK_REALTIME_COARSE)
#endif
#ifdef CLOCK_MONOTONIC_COARSE
		,CLKRES_INIT_PAIR(CLOCK_MONOTONIC_COARSE)
#endif
#ifdef CLOCK_BOOTTIME
		,CLKRES_INIT_PAIR(CLOCK_BOOTTIME)
#endif
#ifdef CLOCK_REALTIME_ALARM
		,CLKRES_INIT_PAIR(CLOCK_REALTIME_ALARM)
#endif
#ifdef CLOCK_BOOTTIME_ALARM
		,CLKRES_INIT_PAIR(CLOCK_BOOTTIME_ALARM)
#endif
#ifdef CLOCK_SOFTTIME
		,CLKRES_INIT_PAIR(CLOCK_SOFTTIME)
#endif
};

const int N_MY_CLK_TABLE = (int)(sizeof(MY_CLK_TABLE)/sizeof(clock_table_t));

#define MY_PI4         0.78539816339744830962  /* pi/4 */

static void bench_sine()
{
	MY_TIME_DECL(t1);
	double sine_value;

	MY_TIME_START(t1);
	sine_value = sin(MY_PI4);
	MY_TIME_END(t1);
	printf("sin(%f)=%f  Computation took %" PRIu64 " [ns]\n",MY_PI4,sine_value,MY_TIME_GET_NS(t1));
}

int main(int argc, char **argv)
{
	int ret = EXIT_SUCCESS;
	int i;

	printf("Clockres utility Version: %s", CLOCKRES_VER_STR );
#ifdef __GNUC__
	printf(" GCC: %d.%d.%d", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
#endif
	printf(" Build time: %s %s", __DATE__, __TIME__);
	printf("\n\n");
#ifdef USE_CLOCK_CYCLES
	
	printf("This OS Supports ClockCycles():\n");
	printf("\tCycles per second: %" PRIu64 "\n",
		(uint64_t)SYSPAGE_ENTRY(qtime)->cycles_per_sec);
	printf("\tWrap occurs on every %" PRIu64 " [s]\n",
		(~(uint64_t)0)/SYSPAGE_ENTRY(qtime)->cycles_per_sec);
	if (ThreadCtl(_NTO_TCTL_RUNMASK, (void*)0x1)){
		perror("ThreadCtl(_NTO_TCTL_RUNMASK,...)");
	}
#endif

	for(i=0;i<N_MY_CLK_TABLE;i++){
		struct timespec rs;
		if (clock_getres(MY_CLK_TABLE[i].clock_id,&rs)){
			printf("%s: ERROR: %s\n",MY_CLK_TABLE[i].clock_name,strerror(errno));
			ret = EXIT_FAILURE;
		} else {
			uint64_t ns;
			ns = rs.tv_sec * (uint64_t)(1000000000) + rs.tv_nsec;
			printf("%-32s => %16" PRIu64 " [ns]\n",MY_CLK_TABLE[i].clock_name,ns);
		}
	}
	printf("\nSimple benchmark to test clock resolution:\n");
	bench_sine();
	return ret;
}
