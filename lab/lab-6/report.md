---
title: ECE 531 | Lab 6 Carrier Synchronization
author: Alan Manuel Loreto Cornídez
---

\newpage

\thispagestyle{empty} \clearpage \tableofcontents \pagenumbering{roman}
\clearpage \pagenumbering{arabic} \setcounter{page}{1}

# Objective of Lab 6

This laboratory will introduce the concept of carrier frequency offset between
transmitting and receiving nodes. Specifically, a simplified error model will be
discussed along with two recovery methods which can operate jointly or
independently, based on their implementation.

## Section 2 | System and Error Models

Carrier Recovery and carrier frequency offset blocks (CFO and CFC blocks), being
told that they are used either for transmitting or receiving.

Being told the formula for the carrier offset and the internal LO rating for the
Pluto, I went ahead and calculated the carrier offset frequency for the Pluto
(without plugging in the cutoff frequency).

$$f_{\Delta} = \frac{f_{c} PPM}{10^{6}}$$

When $PPM$ is $25$, means that:

$$f_{\Delta} = \frac{25f_{c}} {10^{6}}$$

Modeling a corrupted signal can be done in the following way:

$$
f(k) = s(k)e^{(j 2 \pi f_{0} k T + \Theta)} + n(k) = s(k) e^{(j \omega_{0} k
T + \Theta)} + n(k)
$$

Where:

- $n(k)$ is a zero-mean Gaussian random process.
- $T$ is the symbol period.
- $\Theta$ is the carrier phase.

Running the following `lab6part1.m` script:

We can look at the output of the `lab6part1` script when `filterUpsample=4` by
looking at Figure \ref{filterUpsample4}.

![PSD when `filterUpsample` is at a value of 4.\label{filterUpsample4}](./images/filterUpsample-val-4.png){width=256px}

We can change the `filterUpsample` variable to 1 to examine the changes in the
PSD frequency spectrum.

We can look at the output of the `lab6part1` script when `filterUpsample=1` by
looking at Figure \ref{filterUpsample1}.

![PSD when `filterUpsample` is at a value of 1.\label{filterUpsample1}](./images/filterUpsample-val-1.png){width=256px}

Out of curiosity, I also tried changing the `filterUpsample` to 8. We can see
the output of the script in Figure \ref{filterUpsample8}.

![PSD when `filterUpsample` is at a value of 8.\label{filterUpsample8}](./images/filterUpsample-val-8.png){width=256px}

Changing the values of the sample rate renders the following outputs Keep in
mind, that $F_{s}$ is set to $10^{6} Hz$:

- Figure \ref{sampleRateHz01} for $0.1F_{s}$
- Figure \ref{sampleRateHz02} for $0.2F_{s}$
- Figure \ref{sampleRateHz03} for $0.3F_{s}$
- Figure \ref{sampleRateHz04} for $0.4F_{s}$
- Figure \ref{sampleRateHz05} for $0.5F_{s}$
- Figure \ref{sampleRateHz06} for $0.6F_{s}$
- Figure \ref{sampleRateHz07} for $0.7F_{s}$
- Figure \ref{sampleRateHz08} for $0.8F_{s}$
- Figure \ref{sampleRateHz09} for $0.9F_{s}$
- Figure \ref{sampleRateHz10} for $F_{s}$

![PSD when `sampleRateHz` is at a value of $0.1 F_{s}$.\label{sampleRateHz01}](./images/sample-rate-val-01.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.2 F_{s}$.\label{sampleRateHz02}](./images/sample-rate-val-02.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.3 F_{s}$.\label{sampleRateHz03}](./images/sample-rate-val-03.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.4 F_{s}$.\label{sampleRateHz04}](./images/sample-rate-val-04.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.5 F_{s}$.\label{sampleRateHz05}](./images/sample-rate-val-05.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.6 F_{s}$.\label{sampleRateHz06}](./images/sample-rate-val-06.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.7 F_{s}$.\label{sampleRateHz07}](./images/sample-rate-val-07.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.8 F_{s}$.\label{sampleRateHz08}](./images/sample-rate-val-08.png){width=256px}

![PSD when `sampleRateHz` is at a value of $0.9 F_{s}$.\label{sampleRateHz09}](./images/sample-rate-val-09.png){width=256px}

![PSD when `sampleRateHz` is at a value of $F_{s}$.\label{sampleRateHz10}](./images/sample-rate-val-10.png){width=256px}

## Section 3 | frequency Offset Compensation

The definition of for the coarse compensation:

$\hat{f_{0}} = \frac{1}{2 T K} \text{argmax} |\sum_{k=0}^{K-1} r^{2} (k) e^{-
\frac{j 2 \pi k T} {K}}|$

The frequency resolution of each FFT bin is:

$$f_{r} = \frac{1}{T K}$$

The modulation order of a signal is dependent on how many symbols can be
represented using a communication protocol. In this case, BSK uses 2, and QPSK
uses 4. This allows us to use a similar filter with different parameters to
implement a correction method.

# Questions

## 2.1 Questions

### 1. Change `filterUpsample` in `lab6part1.m` to 1 and observe the spectrum. Explain what you observe.

Examining Figure \ref{filterUpsample4} and Figure \ref{filterUpsample1},
decreasing the value of `filterUpsample` from 4 to 1 causes the PSD of the
system spread more evenly across the frequency bins. Increasing the value of
`filterUpsample` to 8 increased the amount of samples that were done in the data
processing step as well, so it took a bit longer to see the results. However, I
didn't notice much benefit to upsampling at a value of 8. Looking at Figure
\ref{filterUpsample8} we can see that even though there is more resolution in
the image, there doesn't appear to be any noticeable change in the PSD when
compared to Figure \ref{filterUpsample4} at a value of 4. However, considering
that we would like to have the PSD be focused around our transmission range, we
do desire the effects that upsampling causes when setting it to a value of 4.

### 2. With the original `lab6part1.m` script increase the frequency offset in unit steps of $0.1F_{s}$ where $F_{s}$ is the sample rate, from $0.1 F_{s}$ to $1.0F_{s}$. Explain the observed effect.

Examining Figures \ref{sampleRateHz01} - \ref{sampleRateHz10}, we can see that
the offset of the PSD shifts across the frequency range by a large margin, that
is, within the rage of at least 50kHz. We can see that at a sample rate of about
$0.2 F_{s}$, we get the mirroring that occurs when using sample rates that are
near integer multiples of the Nyquist frequency. However, as we approach a
higher sample rate, we begin to see that the offset PSD and the original PSD
approach each other.

### 3. When applying the frequency offset in `lab6part1.m` what is the reasoning behind incrementing the time vector?

The time shift is doing an error correction operation. In this case, the error
correction is fixing the phase shift due to (assumed) Doppler error. More
specifically, the script is correcting for phase shift by applying a shift of
the time by $e^{\text{normalized offset} * \text{time index} + phase offset}$.

### 4. Besides LO mismatches between transmitter and receiver, what are other possible sources of frequency offset?

In addition to local oscillator mismatches between transmitter and receiver,
other sources of frequency offset can be:

- Doppler effects from moving transmitters/receivers.
- Multiple paths to the receiver from the transmitter. (Reflection of the signal
  in the air)

## 3.2 Questions

### 1. Based on Equation (3) implement a coarse frequency correction function in MATLAB using the fft function. Utilize `lab6part1.m` to help generate the necessary source signals.

### 2. Modify Equation (3) to handle a Quadrature Phase Shift Keying (QPSK) signal instead of DBPSK, and provide a MATLAB function for coarse frequency correction of such a signal.

![This is an image of the signal after it has been shifted. As you can see, both
of the PSD for the signals are the same.](./attachments/Pasted image
20240422152026.png)

In order to allow QPSK to be used in this function, all we do is add a parameter
for the modulation order (since more symbols can be represented in QPSK than
DSPSK).

We can change $$e^{\frac{-j 2 \pi f_{0}}{sampleRate}}$$

to

$$e^{\frac{-j 2 \pi f_{0} / M}{sampleRate}}$$

where M is the modulation order.

Function:

```MATLAB
function new_sig_fraction = courseFreqCorrection(inputSignal, timeIndex, modulationOrder, sampleRate, frameSize, numFrames, filterUpsample)

% Find the change in frequency
df = sampleRate/(frameSize*numFrames);

% Generate the Array of the
frequencies = -sampleRate / 2 : df / filterUpsample : sampleRate/2 - df/filterUpsample;

% Get the abolute values of the frequency components in the signal.
a = abs(fftshift(fft(inputSignal .^ modulationOrder)));

%% Get the index of the max value
[~, idx] = max(a);

% Use the maximum frequency to calculate the offset.
% (Modulation order is used as a parameter to allow
% the user to pick what modulation scheme is being used)
fo = frequencies(idx) / modulationOrder;

% Get the expontent value using the offset.
offset = -1i.*2*pi*fo./sampleRate;

% Conduct the frequency shift.
freqShift = exp(offset*timeIndex);

% Multiply the input signal by the offset.
new_sig_fraction = inputSignal(timeIndex) .* freqShift;

plot(frequencies, a);

end
```

### 3. Evaluate the effective range of this FFT method for DBPSK and QPSK. How would you parameterize this estimator for two talking Plutos with these modulation schemes?

Making sure that two plutos (or any two sources of Tx and Rx for example) would
require a few setup steps to allow proper exeuction of filtering/communcation.

Many parameters of the system must be the same: the modulation scheme, the
sample rates, and a matched filtering technique, that is, the sender and
receiver must use symmetric filters or the receiver uses a filter that undoes
the operation of a sender filter.

Once those communication parameters have been established, the receiver may
process the signal in ways that are most convenient to them, such as the symbols
per frame and the symbol size, this will allow the receiver to correct the
signal.

### 4. At what angular frequency offset would we still recovery DBPSK without additional frequency correction and for how many symbols?

Calculating the toleration of a symbol of DBPSK (using $\pi/4$ since 4 symols
can be represented):

$$\Delta \theta \le \frac{\pi}{4}$$

$$2 \pi \frac{\Delta f}{f_{s}} \le \frac{\pi}{4}$$

$$\frac{\Delta f}{f_{s}} \le \frac{1}{8}$$

$$\Delta f \le \frac{f_{s} }{8}$$

This means that the frequency shift must be at most, $\frac{1}{8}$ of the sample
rate.

Calculating the amount of symbols:

$$n \times \Delta \theta = n \times 2 \frac{\Delta f}{f_s} \le \frac{\pi}{2}$$

Plugging in our calculated $\Delta f$, we get:

$$n \times \frac{\pi}{4} \le \frac{\pi}{2}$$

$$n \le 2$$

This means that when the frequency offset is at $\frac{1}{8}$ of the sample
rate, we can only receive, at most, 2 symbols (after correction) before we are
unable to recover symbols.

## 3.4 Questions

### 1. Based on Section 3.3 implement a $FFC$ in `MATLAB`. Utilize `lab6part1.m`to help generate the necessary source signals with frequency offsets. You may also use `comm.CarrierSynchronizer` if you choose.

<!-- TODO -->

I used the `comm.CarrierSynchronizer` object in `MATLAB` and used the following
statements to do carrier synchronization:

```MATLAB
% Making the filter.
carsync = comm.CarrierSynchronizer(Modulation="BPSK", ...
    SamplesPerSymbol=samplesPerSymbol, ...
    DampingFactor=dampingFactor, ...
    NormalizedLoopBandwidth=loopBandwidth);

% Creating the data using the filter.
[correctedData, est] = carsync(offsetData);
```

### 2. With your constructed $FFC$, evaluate the effect on convergence times for significant offsets with different damping factors and loop bandwidths. Illustrate scenarios of interest with plots. (Note: Phase error estimate is an available output if using `MATLAB` object)

- Damping Factor 0.707: Figure \ref{dampingFactor707}
- Damping Factor 0.10: Figure \ref{dampingFactor01}
- Damping Factor 0.20: Figure \ref{dampingFactor02}
- Damping Factor 0.50: Figure \ref{dampingFactor05}
- Damping Factor 0.90: Figure \ref{dampingFactor09}
- Damping Factor 0.01: Figure \ref{loopBW10}

![Damping Factor = 0.707 | Loop Bandwidth =
0.01.\label{dampingFactor707}](./attachments/Pasted image 20240422200747.png)

![Damping Factor = 0.1 | Loop Bandwidth =
0.01.\label{dampingFactor01}](./attachments/Pasted image
20240423143155.png){width=256px}

![Damping Factor = 0.2 | Loop Bandwidth =
0.01\label{dampingFactor02}](./attachments/Pasted image
20240422195117.png){width=256px}

![Damping Factor = 0.5 | Loop Bandwidth =
0.01\label{dampingFactor05}](./attachments/Pasted image
20240422195138.png){width=256px}

![Damping Factor = 0.9 | Loop Bandwidth =
0.01\label{dampingFactor09}](./attachments/Pasted image
20240422195155.png){width=256px}

Changing the Loop BW by a factor of 10 (0.01 -> 0.10) had a large effect on the
transient time it took to congerge to the correct values.

![Damping Factor = 0.707 | Loop Bandwidth =
0.10\label{loopBW10}](./attachments/Pasted image
20240422195259.png){width=256px}

When the loop BW was set to 0.03, the first occurrence of an underdamped system
happened, meaning that the signal never stabilized to an actual value.

This is shown in figure \ref{loopBW03}

![](path)

![Loop Bandwidth = 0.03\label{loopBW03}](./attachments/Pasted image
20240423161134.png)

- Loop BW Set to 0.03: Figure \ref{loopBW03}

### 3. With your constructed $FFC$, generate phase corrected estimates and check them against your chosen offset with $MSE$ and/or $EVM$ evaluations.

<!-- TODO -->

In thi spart of the lab, I used the following statistics for the offset:

| SNR | Original Signal EVM (RMS%) | Offset Signal EVM (RMS%) | Corrected Signal EVM (RMS%) |
| --- | -------------------------- | ------------------------ | --------------------------- |
| 5   | 56.5                       | 98.88                    | 56.36                       |
| 10  | 34.52                      | 91.92                    | 35.29                       |
| 15  | 18.57                      | 88.25                    | 19.14                       |
| 20  | 10.49                      | 89.74                    | 11.9                        |
| 25  | 6.43                       | 88.64                    | 8.57                        |

As you can see, the original EVM rms values are greatly hindered when the signal
is offset, howeve,r after error correction, most of the signal can be retrieved
(although, it is not perfect, we are still able to get most of the clarity back)

### 4. Ignoring timing correction what is the maximum frequency offset your $FFC$ can handle? Describe how you determined this conceptually.

The frequency offset that the FFC can be is dependent on the modulation scheme,
if we are using BPSK, then the phase offset can be up to $90 ^{\circ}$, however,
if we are using QPSK, we have 4 possible symbols, so we can only correct up to
$45 ^{\circ}$ from the point that we are trying to correct for. This is because
we can divide the constellation diagram into the number of symbols that can be
transmitted on one data line.

### 5. What would be an appropriate $PED$ for $QPSK$?

A phase error detector for a QPSK modulation scheme has to have error detection
for 4 symbols (instead of 2 symbol types as in BPSK). Therefore, we can modify
the error signal to take into account the real and imaginary axes as they are
interpreted in the constellation diagram.

If we want to check the error for QPSK, we know that we will have 4 symbols (and
it takes in both the real and imaginary axis), as such, the equation for a PED
for QPSK may look something like the following:

$$e(k) = sgn(Re(f(k))) \times Im(f(k)) - sgn(Im(f(k))) \times Re(f(k))$$

Where $f(k)$ is the discrete QI sampled signal.

In QPSK, the symbols should have the same magnitude in both the real and
imaginary components of the signal, if this is not the case in the received
signal, then the $e(k)$ function will catch that error and allow $FFC$ to occur.

# Conclusion

This lab built on the concepts learned in lab five. However, lab six focused on
the carrier synchronization whereas lab five focused on symbol synchronization.

Regardless, the fact that there can be so much noise in a signal yet we are
still able to recover most (if not all) of the original information contained
within the signal is an impressive feat. Especially considering that the
algorithms used do not have to have any prior assistance (in terms of Data Aided
Correction) to correct the error in the received signals. Throughout the course
of the past two labs I have gained a new respect for signals engineers after
discovering how robust the methods are that allow us to transfer as much
information as we do in such a small bandwidth.
