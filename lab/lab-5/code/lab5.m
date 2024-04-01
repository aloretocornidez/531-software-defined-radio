% ECE 531 Lab 5 | Digital Modulation: Symbol Synchronization
% Name: Alan Manuel Loreto Cornidez
% Date: March 31st, 2024


% %% Part 1 | Filter With Different Parameters
% % set up filter parameters 
% beta = 0.1
% span = 6;
% sps= 4;
% shape = "sqrt";
%
% h = rcosdesign(beta, span, sps, "sqrt");
%
% freqz(h);

%% Part 2 | Transmit and Receive Plots with Varying Beta Values

% User tunable (samplesPerSymbol>=decimation)
samplesPerSymbol = 12; decimation = 4;
% Set up radio
tx = sdrtx('Pluto','Gain',-20);
rx = sdrrx('Pluto','SamplesPerFrame',1e6,'OutputDataType','double');

% Create binary data
data = randi([0 1],2^15,1);
transmitedData = data;

% Create a QPSK modulator System object and modulate data
qpskMod = comm.QPSKModulator('BitInput',true);
modData = qpskMod(data);

% Set up filters
rctFilt = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol', samplesPerSymbol, 'RolloffFactor', p2_beta);
rcrFilt = comm.RaisedCosineReceiveFilter( 'InputSamplesPerSymbol',  samplesPerSymbol, 'DecimationFactor', decimation, 'RolloffFactor', p2_beta);


% Pass data through radio
tx.transmitRepeat(rctFilt(modData)); 
data = rcrFilt(rx());


% Process received data for timing offset
remainingSPS = samplesPerSymbol/decimation;


transmitedData = transmitedData(end - remainingSPS*1000+1:end);
% rdata = data(end-remainingSPS*1000+1:end);
rdata = data;

% Creating the Figures 
compPlot = figure('Name', 'Transmit and Receive Analysis');
ax1 = axes('Parent', compPlot);
plot(ax1, transmitedData, 'Color', 'blue');
hold on
plot(ax1, rdata, 'Color', 'red');
hold off
xlabel('Sample');
ylabel('Amplitude');
title(ax1, 'Transmit and Receive Analysis');

