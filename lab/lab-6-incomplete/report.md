---
title: ECE 531 | Lab 6
author: Alan Manuel Loreto Cornídez
output: pdf
---

\newpage

\thispagestyle{empty} \clearpage \tableofcontents \pagenumbering{roman}
\clearpage \pagenumbering{arabic} \setcounter{page}{1}

# Expossitory Approach to The Lab

Being told the formula for the carrier offset and the internal LO rating for the
Pluto, I went ahead and calculated the carrier offset frequency for the Pluto.

$$f_{\Delta} = \frac{f_{c} PPM}{10^{6}}$$

When $PPM$ is $25$, means that:

$$f_{\Delta} = \frac{25f_{c}} {10^{6}}$$




# Questions

## 2.1 Questions

1. Change `filterUpsample` in `lab6part1.m` to 1 and observe the spectrum.
   Explain what you observe.
2. With the original `lab6part1.m` script increase the frequency offset in unit
   steps of $0.1F_{s}$ where $F_{s}$ is the sample rate, from $0.1 F_{s}$ to
   $1.0F_{s}$. Explain the observed effect.

3. When applying the frequency offset in `lab6part1.m`what is the reasoning
   behind incrementing the time vector?

4. Besides LO mismatches between transmitter and receiver, what are other
   possible sources of frequency offset?

## 3.4 Questions

1. Based on Section 3.3 implement a $FFC$ in `MATLAB`. Utilize `lab6part1.m`to
   help generate the necessary source signals with frequency offsets. You may
   also use `comm.CarrierSynchronizer` if you choose.

2. With your constructed $FFC$, evaluate the effect on convergence times for
   significant offsets with different damping factors and loop bandwidths.
   Illustrate scenarios of interest with plots. (Note: Phase error estimate is
   an available output if using `MATLAB` object)

3. With your constructed $FFC$, generate phase corrected estimates and check
   them against your chosen offset with $MSE$ and/or $EVM$ evaluations.

4. Ignoring timing correction what is the maximum frequency offset your $FFC$
   can handle? Describe how you determined this conceptually.

5. What would be an appropriate $PED$ for $QPSK$?
