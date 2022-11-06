# Programming Exercises for Mathematical Image Processing

This repository contains programming exercises corresponding to the lectures "Mathematical Foundations of Image Processing" and "Variational Methods in Image Processing" held by [Prof. Berkels](https://www.aices.rwth-aachen.de/en/people/berkels) at RWTH Aachen University. The corresponding assignments can be found in the following article:

    [1] http://davidstutz.de/programming-exercises-for-mathematical-image-processing/

The assignments have been completed together with [Tobias Pohlen](http://geekstack.net/).

The examples have been tested using MatLab 2014b on Ubuntu 12.04 with OpenCV 2.4.

## Building

The C++ examples are built using CMake and based on OpenCV:

    cd mathematical-image-processing
    cd filters
    mkdir build
    cd build
    cmake ..
    make
    ./filters_cli ../lenaTest3.jpg

## License

For license details of the various variants of the Lenna image, see [here](http://en.wikipedia.org/wiki/Lenna#mediaviewer/File:Lenna.png).

Copyright (c) 2016, David Stutz and Tobias Pohlen. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
