# ECE 531 | Lab 2 - Getting Started on PlutoSDR

## 2 | Required Software


### Matlab

I can run one of the example programs on my linux computer with matlab installed:

![[Pasted image 20240215095532.png]]

This is actually surprising because getting Matlab installed on my computer was difficult (I don't use Ubuntu). 


### GNU Radio

GNU radio was working fine last lab.

#### IIO-Scope

IIO-Scope was installed and is working fine. 

![[Pasted image 20240215105324.png]]


### SSH Connection

The ssh connection to the pluto was working fine as well:

![[Pasted image 20240215105843.png]]



## 3 | Industrial Input/Output (IIO)

Here is my `iio_info -s` output on my local computer.

![[Pasted image 20240215112357.png]]

And here is my oupput on the pluto:

![[Pasted image 20240215112650.png]]

We can see that the iio on my laptop outputs the USB Pluto as well as the local ip for the Pluto (in addition to the local laptop) whereas the output on my Pluto outputs the local host to the ssh server as well as the system on the Pluto itself (and all of the iio devices on the Pluto).


We can use 

```sh
 iio_attr -d --uri ip:192.168.2.1
```

To display the attributes of the device.

![[Pasted image 20240215113433.png]]



After catting the name we can see the following output (in addition to all of the contents in this directory)


![[Pasted image 20240215114017.png]]

All of those file, I assume, are used to control the values of the outputs of components. We can use IIO Oscilloscope for debugging these values as well.

## 4 | Radio Setup and Environmental Noise Observations



Entering the command into MATLAB

![[Pasted image 20240215115126.png]]

Pulling up the documentation for the pluto:

SDRR:
![[Pasted image 20240215115257.png]]

SDRT:
![[Pasted image 20240215115351.png]]


