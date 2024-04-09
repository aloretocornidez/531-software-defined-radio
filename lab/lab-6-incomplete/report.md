---
title: ECE 531 | Lab 6
subtitle: Digital Modulation | Carrier Synchronization
author:
  name: Alan Manuel Loreto Cornídez
  affiliation: University of Arizona
  location: Tucson, Arizona
  email: aloretocornidez@arizona.edu
<!-- numbersections: yes -->
<!-- output: pdf -->
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

# Questions

## 2.1 Questions

1. Change `filterUpsample` in `lab6part1.m` to 1 and observe the spectrum.
   Explain what you observe.

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

2. With the original `lab6part1.m` script increase the frequency offset in unit
   steps of $0.1F_{s}$ where $F_{s}$ is the sample rate, from $0.1 F_{s}$ to
   $1.0F_{s}$. Explain the observed effect.

Examining Figures \ref{sampleRateHz01} - \ref{sampleRateHz10}, we can see that
the offset of the PSD shifts across the frequency range by a large margin, that
is, within the rage of at least 50kHz. We can see that at a sample rate of about
$0.2 F_{s}$, we get the mirroring that occurs when using sample rates that are
near integer multiples of the Nyquist frequency. However, as we approach a
higher sample rate, we begin to see that the offset PSD and the original PSD
approach each other.

3. When applying the frequency offset in `lab6part1.m` what is the reasoning
   behind incrementing the time vector?

The time shift is doing an error correction operation. In this case, the error
correction is fixing the phase shift due to (assumed) Doppler error. More
specifically, the script is correcting for phase shift by applying a shift of
the time by $e^{\text{normalized offset} * \text{time index} + phase offset}$.

4. Besides LO mismatches between transmitter and receiver, what are other
   possible sources of frequency offset?

In addition to local oscillator mismatches between transmitter and receiver,
other sources of frequency offset can be:

- Doppler effects from moving transmitters/receivers.
- Multiple paths to the receiver from the transmitter. (Reflection of the signal
  in the air)

## 3.2 Questions

1. Based on Equation (3) implement a coarse frequency correction function in
   MATLAB using the fft function. Utilize `lab6part1.m` to help generate the

<!-- TODO -->

-

2. Modify Equation (3) to handle a Quadrature Phase Shift Keying (QPSK) signal
   instead of DBPSK, and provide a MATLAB function for coarse frequency
   correction of such a signal.

<!-- TODO -->

3. Evaluate the effective range of this FFT method for DBPSK and QPSK. How would
   you parameterize this estimator for two talking Plutos with these modulation
   schemes?

<!-- TODO -->

4. At what angular frequency offset would we still recovery DBPSK without
   additional frequency correction and for how many symbols?

<!-- TODO -->

<!-- ## 3.4 Questions -->
<!---->
<!-- TODO -->
<!-- 1. Based on Section 3.3 implement a $FFC$ in `MATLAB`. Utilize `lab6part1.m`to -->
<!--    help generate the necessary source signals with frequency offsets. You may -->
<!--    also use `comm.CarrierSynchronizer` if you choose. -->
<!-- TODO -->
<!---->
<!-- 2. With your constructed $FFC$, evaluate the effect on convergence times for -->
<!--    significant offsets with different damping factors and loop bandwidths. -->
<!--    Illustrate scenarios of interest with plots. (Note: Phase error estimate is -->
<!--    an available output if using `MATLAB` object) -->
<!-- TODO -->
<!---->
<!-- 3. With your constructed $FFC$, generate phase corrected estimates and check -->
<!--    them against your chosen offset with $MSE$ and/or $EVM$ evaluations. -->
<!-- TODO -->
<!---->
<!-- 4. Ignoring timing correction what is the maximum frequency offset your $FFC$ -->
<!--    can handle? Describe how you determined this conceptually. -->
<!-- TODO -->
<!---->
<!-- 5. What would be an appropriate $PED$ for $QPSK$? -->
<!-- TODO -->
