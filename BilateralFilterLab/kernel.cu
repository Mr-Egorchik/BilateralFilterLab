
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#include "EasyBMP.h"

void writefile(float* image, int height, int width, bool gpu = false) {
    BMP output;
    output.SetSize(width, height);

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            RGBApixel pixel;
            pixel.Red = image[i * width + j];
            pixel.Green = image[i * width + j];
            pixel.Blue = image[i * width + j];
            output.SetPixel(j, i, pixel);
        }
    }
    output.WriteToFile(gpu ? "output_gpu.bmp" : "output_cpu.bmp");
}

int main()
{
    BMP Image;
    Image.ReadFromFile("input.bmp");
    int height = Image.TellHeight();
    int width = Image.TellWidth();

    float* imageArray = new float[height * width];
    float* outputCPU = new float[height * width];
    float* outputGPU = new float[height * width];

    for (int j = 0; j < Image.TellHeight(); j++) {
        for (int i = 0; i < Image.TellWidth(); i++) {
            imageArray[j * width + i] = Image(i, j)->Red;
        }
    }

    writefile(imageArray, height, width);

    delete[] imageArray;
    delete[] outputCPU;
    delete[] outputGPU;

    return 0;
}