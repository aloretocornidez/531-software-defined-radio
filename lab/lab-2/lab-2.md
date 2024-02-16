# ECE 531 | Lab 2 - Getting Started on PlutoSDR

## 2 | Required Software

### Matlab

I can run one of the example programs on my linux computer with matlab
installed:

![[Pasted image 20240215095532.png]]

This is actually surprising because getting Matlab installed on my computer was
difficult (I don't use Ubuntu).

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

We can see that the iio on my laptop outputs the USB Pluto as well as the local
ip for the Pluto (in addition to the local laptop) whereas the output on my
Pluto outputs the local host to the ssh server as well as the system on the
Pluto itself (and all of the iio devices on the Pluto).

We can use

```sh
iio_attr -d --uri ip:192.168.2.1
```

To display the attributes of the device.

![[Pasted image 20240215113433.png]]

After catting the name we can see the following output (in addition to all of
the contents in this directory)

![[Pasted image 20240215114017.png]]

All of those file, I assume, are used to control the values of the outputs of
components. We can use IIO Oscilloscope for debugging these values as well.

## 4 | Radio Setup and Environmental Noise Observations

Entering the command into MATLAB

![[Pasted image 20240215115126.png]]

Pulling up the documentation for the pluto:

SDRR: ![[Pasted image 20240215115257.png]]

SDRT: ![[Pasted image 20240215115351.png]]

### loopback.m

After connecting the coaxial cable, I was able to run the provided `loopback.m`
script and recieved the following output:

![[Pasted image 20240215145502.png]]

Zooming in on the waveform we can see this:

![[Pasted image 20240215145554.png]]

#### Modifying the Script

1. Modifying the samplitude of the sine wave

Slow Attack: ![[Pasted image 20240215153712.png]]

Fast Attack: ![[Pasted image 20240215153744.png]]

Manual: ![[Pasted image 20240215153845.png]]

The gain value must be set at this point.

Setting the gain value to 70 causes this square-wave looking output output:

![[Pasted image 20240215162522.png]]

The square-wave-like signal likely happens because of railing on the
output/input hardware.

Here is the output when gain is 32. ![[Pasted image 20240215162726.png]]

Breakdown begins to occur at about 34 for the gain value.

![[Pasted image 20240215163339.png]]

### GNU Radio Loopback

Here is the output when generating the SFG and running the generated python
scripts:

![[Pasted image 20240215165111.png]]

1. I added the pluto by searching for the module on the right.
2. I control the gain of the signal by using the gui variable (assigned it
   inside the pluto block by changing the gain mode, similar to the matlab
   method)

Adding a frequency sink (so that it matches the document while also including
the time sink gives this output):

![[Pasted image 20240215165505.png]]

Here is the SFG from gnuradio:

![[Pasted image 20240215165547.png]]

#### Double-click on each PlutoSDR block (source and sink) to look at the block properties.

- What is the RF Bandwidth? What does this property control in the PlutoSDR?

  - **RD bandwidth is the total frequency range that the SDR (in this case, the
    Pluto) is able to receive at any given time.**

- What is the “Cyclic” boolean selection for in the PlutoSDR Sink block?

  - **The Cyclic boolean selection for the PlutoSDR is used for turning on
    cyclic mode. This allows the first buffer of samples to be repreated on the
    program until the program is stopped. This allows the rest of the program to
    execute while the PlutoSDR blocks stop.**

- What does the Manual Gain control in the PlutoSDR source? What other
  strategies are available?

  - **The manual gain value controls the gain of the transmitter output.**

#### Adjust the RX gain. At what value does the received signal begin to distort or clip?

Run the flowgraph. Note: you may have to enter change the Device URI. On some
operating systems libIIO finds the first available device when this field is
left blank.

In my case there was no need to configure the URI. Linux did that for me.

![[Pasted image 20240215172100.png]]

As you can see in the image above, the signal starts to distort at about 14 for the Rx gain value.

#### Replace the “QT Time Sink” block with a “QT GUI Sink”. Explore the options provided by the new sink block. What happens if you increase the number of averages? Why does the frequency response change when you change the window function?

Changing the number of averages takes an average of the past number of calculated data points for that field which allows the wave forms to look cleaner. If I'm not mistaken, this is behaving like a lo-pass filter on the data points.

The reason for the frequency response changing when I change the windows is because each window has different spectral leakage parameters that affect the value that is sampled from the ADC.


#### What is the transmitted RF frequency of the sinusoid? 

The transmiitted RF frequency of the sinusoid is 10k. This is becuase that is the settin on the GUI slider. However when I change the GUI slider the frequency changes to the corresponding frequency.