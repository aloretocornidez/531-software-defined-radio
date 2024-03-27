# ECE 531 | Digital Modulation: Symbol Synchronization

Name: Alan Manuel Loreto Cornidez

Course: ECE 531 | Software Defined Radio

Due Date: 02/19/2024

<!-- \newpage -->
<!-- \thispagestyle{empty} \clearpage \tableofcontents \pagenumbering{roman} -->
<!-- \clearpage \pagenumbering{arabic} \setcounter{page}{1} -->

## 1 | Overview and Objectives

## 2 | Pulse Shaping and Matched Filtering

### Section 2 | Questions

1. Explain the difference between type I and type II Nyquist filters.
2. Generate frequency response plots for SRRC filter realizations with $\beta \in [0, 0.1, 0.25, 0.5, 1]$
3. Generate transmit and receive plots similar to Figure 3 with $\beta \in [0.1, 0.5, 0.9]$ and discuss the time domain effect

## 3 | Timing Error

### Section 3 | Questions

1. Regenerate Figure 6 with data from your Pluto SDR and explain why the
   constellation appears rotated. It may be helpful to start with
   `plutoLoopback.m`

## 4 | Symbol Timing Compensation

### 4.1 | Gardener

### 4.2 | Müller Mueller

### Section 4 | Questions

1. Starting with `TimingError.m`, which demonstrates a slowly changing timing
   offset, implement in MATLAB either the ZC, MM, or Gardner timing correction
   algorithm.
2. Provide error vector magnitude (EVM) measurements of the signal before an
   after your timing correction at different noise levels. (You may use the
   comm.EVM object in MATLAB.)
3. Introduce a fixed phase offset and repeat your EVM measurements from
   Question 1.

## 5 | Adding Pieces Together

### 5.1 | Questions

1. Provide your chosen arrangement of recovery blocks and reasoning behind their
   selected placement.
2. With your new receive chain, generate a received signal (before the receive
   filter in Figure 3) under the following conditions and provide EVM
   measurements after timing recovery:

- No offsets
- A fixed timing offset
- A fixed phase offset

Provide results over a small range of SNRs.

## 6 | Automatic Timing Compensation with Pluto

### 6.1 | Objective

### 6.2 | Testing on Hardware
