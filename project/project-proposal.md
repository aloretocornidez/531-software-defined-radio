---
title: Project Proposal | Software Defined Radio
date: April 8th, 2024
author: Alan Manuel Loreto Cornídez, Jeremy Sharp
output: pdf_document
---

<!-- \newpage \thispagestyle{empty} \clearpage \tableofcontents \pagenumbering{roman} -->
<!-- \clearpage \pagenumbering{arabic} \setcounter{page}{1} -->

# Project Synopsis

The most common method for aircraft to report their system state involves the
use of the Automatic Dependent Surveillance-Broadcast (ADS-B) transmission
method. An open transmission method used to broadcast an aircraft's position,
enabling the ability to track the aircraft.

Throughout the Spring 2024 semester, we have worked with the ADA Pluto Software
Defined Radio (SDR) to receive and transmit signals in multiple ranges of
frequency bands. We have implemented pre-made signal processing blocks in
GNURadio signal flow graphs and then implemented them on the ADA Pluto for
applications such as FM Radio and AM radio. Our project would like to work on
solving the "1090 MHz Riddle".

What is the 1090 MHz Riddle you may ask? For many Software Defined Radio (SDR)
enthusiasts, being able to capture, decode, interpret, and transmit ADS-B
signals involves an understanding of how signals are are manipulated in the RF
spectrum, both for transmission and modulation.

In our particular case, we would like to implement the use of the 1090 MHz
frequency band to communicate with public aircraft information.

We have found pre-made GNURadio block that implement ADS-B communication
protocols, however, we would like to explore a custom implementation using only
a GNURadio signal flow graph and the QT GUI elements.

After implementing a simple receiver and transmitter, we would like to expand
the project scope to receive real ADS-B signals transmitted by aircraft. If this
project goal is met, we would like to decode and interpret the data by plotting
received data on a map.

## Project Goal Summary

- Build a custom antenna for use in the proper frequency band.
- Transmit ADS-B signals for testing.
- Receive and decode the signals that have been transmitted
- Receive actual signals from ADS-B transponders (aircraft)
- A table containing real received data. (Tail Number, Latitude, Longitude,
  Direction, Speed)
- Plot the data on a map
