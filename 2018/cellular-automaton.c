

	#include <windows.h> 
	#define DLL_EXPORT __declspec(dllexport)  
	
	DLL_EXPORT int cellular_automaton (int *a, int la, int *r, int lr, int col, int width) {
		int i, j;
		for (i=0; i<(la-(width+3)); i=i+1) {
		for (j=0; j<lr; j=j+3) {
			if (a[i] == r[j] && a[i+1] == r[j+1] && a[i+2] == r[j+2]) {
				a[i+width+1] = col ; //0x00ffffff;
			}
		}}
		return a;
	}
