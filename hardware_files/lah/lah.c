#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>

int main()
{
	int fd;
	int sound = 0;
	int vib = 0;
	int t, s, v;
	int count = 0;
	int super_count = 0;
	int temp_sum = 0;
	int temp_min = 100;
	int temp_max = 0;
	int sound_1 = 0;
	int vibs_1 = 0;
	fd = open("sleep_well", O_TRUNC | O_CREAT);
	FILE *file;
	file = fopen("/dev/cu.usbmodem1411", "r");
	char *line = NULL;
	int len = 0;
	int read;
	while(super_count < 25000000){
		count = 0;
		sound_1 = 0;
		vibs_1 = 0;
		while(count < 850){
			count++;
			read = getline(&line, &len, file);
			printf("%s", line);
			t = 10 * atoi(&line[0]) + atoi(&line[1]);
			s = atoi(&line[3]);
			v = atoi(&line[5]);
			s = (s - 0.5)*(-1) + 0.5;
			sound_1 += s;
			vibs_1 += v;
			temp_sum += t;
		}
		if(vibs_1 > 25)
			vib++;
		if(sound_1 > 50)
			sound++;
	}
	int temp_avg = temp_sum/25000000;
	dprintf(fd, "%d,%d,%d,%d,%d\n", temp_max, temp_min, temp_avg, sound, vib);
	
	/*while(read = getline(&line, &len, file)){
		
		printf("%s", line);
		
	}*/

return 0;

}