// clockres.c - get clock resolution of clock_gettime(2)
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <stdint.h>
#include <inttypes.h>

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
};

const int N_MY_CLK_TABLE = (int)(sizeof(MY_CLK_TABLE)/sizeof(clock_table_t));

int main(int argc, char **argv)
{
	int ret = EXIT_SUCCESS;
	int i;

	for(i=0;i<N_MY_CLK_TABLE;i++){
		struct timespec rs;
		if (clock_getres(MY_CLK_TABLE[i].clock_id,&rs)){
			printf("%s: ERROR: %s\n",MY_CLK_TABLE[i].clock_name,strerror(errno));
			ret = EXIT_FAILURE;
		} else {
			uint64_t ns;
			ns = rs.tv_sec * (uint64_t)(1000000) + rs.tv_nsec;
			printf("%-32s => %16" PRIu64 " [ns]\n",MY_CLK_TABLE[i].clock_name,ns);
		}
	}

	return ret;
}
