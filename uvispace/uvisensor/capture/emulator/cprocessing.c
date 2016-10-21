
/* DLL export for Windows */
#ifdef BUILD_DLL
__declspec(dllexport) void cbinarize(unsigned char *image_in, unsigned char *image_out, int size,
                                     unsigned char *thr_min, unsigned char *thr_max);

__declspec(dllexport) void cerosion(unsigned char *image_in, unsigned char *image_out,
		                            int width, int height);

__declspec(dllexport) void clocation(unsigned char *image_in, int width, int height,
		                             int *corners_x, int *corners_y);
#endif

void cbinarize(unsigned char *image_in, unsigned char *image_out, int size,
               unsigned char *thr_min, unsigned char *thr_max)
{
    int i, j;
    for (i = 0, j = 0; j < size; i += 3, j++) {
        if ((image_in[i] >= thr_min[0]) && (image_in[i] <= thr_max[0]) &&
            (image_in[i+1] >= thr_min[1]) && (image_in[i+1] <= thr_max[1]) &&
            (image_in[i+2] >= thr_min[2]) && (image_in[i+2] <= thr_max[2])) {
            image_out[j] = 255;
        }  
    }
}

void cerosion(unsigned char *image_in, unsigned char *image_out, int width, int height)
{
	int x, y;
	int i0, i1, i2;
	for (y = 0; y < (height - 2); y++) {
		for (x = 0; x < (width - 2); x++) {
			i0 = y * width + x;
			i1 = i0 + width;
			i2 = i1 + width;
			if (image_in[i0] && image_in[i0+1] && image_in[i0+2] &&
				image_in[i1] && image_in[i1+1] && image_in[i1+2] &&
				image_in[i2] && image_in[i2+1] && image_in[i2+2]) {
				image_out[i0] = 255;
			}
		}
	}
}

void cdilation(unsigned char *image_in, unsigned char *image_out, int width, int height)
{
	int x, y;
	int i0, i1, i2;
	for (y = 0; y < (height - 2); y++) {
		for (x = 0; x < (width - 2); x++) {
			i0 = y * width + x;
			i1 = i0 + width;
			i2 = i1 + width;
			if (image_in[i0] || image_in[i0+1] || image_in[i0+2] ||
				image_in[i1] || image_in[i1+1] || image_in[i1+2] ||
				image_in[i2] || image_in[i2+1] || image_in[i2+2]) {
				image_out[i0] = 255;
			}
		}
	}
}

void clocation(unsigned char *image_in, int width, int height,
		       int *corners_x, int *corners_y)
{
	int x, y;
	int k = 0;
	int size = 0;
	int left1_x = width;
	int left1_y = height;
	int left2_x = width;
	int left2_y = height;
	int top1_x = width;
	int top1_y = height;
	int top2_x = width;
	int top2_y = height;
	int right1_x = 0;
	int right1_y = 0;
	int right2_x = 0;
	int right2_y = 0;
	int bottom1_x = 0;
	int bottom1_y = 0;
	int bottom2_x = 0;
	int bottom2_y = 0;
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			if (image_in[k] == 255) {
                size ++;
                if (left1_x > x) {
                	left1_x = x;
                	left1_y = y;
                }
                if (left2_x >= x) {
                	left2_x = x;
                	left2_y = y;
                }
                if (top1_y > y) {
                	top1_x = x;
                	top1_y = y;
                }
                if (top2_y >= y) {
                	top2_x = x;
                	top2_y = y;
                }
                if (right1_x < x) {
                	right1_x = x;
                	right1_y = y;
                }
                if (right2_x <= x) {
                	right2_x = x;
                	right2_y = y;
                }
                if (bottom1_y < y) {
                	bottom1_x = x;
                	bottom1_y = y;
                }
                if (bottom2_y <= y) {
                	bottom2_x = x;
                	bottom2_y = y;
                }
			}
			k++;
		}
		if (size) {
			corners_x[0] = left2_x;
			corners_x[1] = left1_x;
			corners_x[2] = top1_x;
			corners_x[3] = top2_x;
			corners_x[4] = right1_x;
			corners_x[5] = right2_x;
			corners_x[6] = bottom2_x;
			corners_x[7] = bottom1_x;
			corners_y[0] = left2_y;
			corners_y[1] = left1_y;
			corners_y[2] = top1_y;
			corners_y[3] = top2_y;
			corners_y[4] = right1_y;
			corners_y[5] = right2_y;
			corners_y[6] = bottom2_y;
			corners_y[7] = bottom1_y;
		}
		else {
			corners_x[0] = 0;
			corners_x[1] = 0;
			corners_x[2] = 0;
			corners_x[3] = 0;
			corners_x[4] = 0;
			corners_x[5] = 0;
			corners_x[6] = 0;
			corners_x[7] = 0;
			corners_y[0] = 0;
			corners_y[1] = 0;
			corners_y[2] = 0;
			corners_y[3] = 0;
			corners_y[4] = 0;
			corners_y[5] = 0;
			corners_y[6] = 0;
			corners_y[7] = 0;
		}
	}
}
