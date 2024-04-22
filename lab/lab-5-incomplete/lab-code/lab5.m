% ECE 531 Lab 5 | Digital Modulation: Symbol Synchronization
% Name: Alan Manuel Loreto Cornidez
% Date: March 31st, 2024


%% Part 1 | Filter With Different Parameters
% set up filter parameters 
beta = 0.1;
span = 6;
sps= 4;
shape = "sqrt";

h = rcosdesign(beta, span, sps, "sqrt");

freqz(h);

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
p2_beta = 0.1;
rctFilt = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol', samplesPerSymbol, 'RolloffFactor', p2_beta);
rcrFilt = comm.RaisedCosineReceiveFilter( 'InputSamplesPerSymbol',  samplesPerSymbol, 'DecimationFactor', decimation, 'RolloffFactor', p2_beta);


% Pass data through radio
tx.transmitRepeat(rctFilt(modData)); 
data = rcrFilt(rx());


transmitedData = transmitedData(end - remainingSPS*1000+1:end);
rdata = data(end-remainingSPS*1000+1:end);
% rdata = data;


% Creating the Figures 
compPlot = figure('Name', 'Transmit and Receive Analysis');
ax1 = axes('Parent', compPlot);
plot(ax1, transmitedData, 'Color', 'blue');
hold on
% plot(ax1, rdata, 'Color', 'red');
hold off
xlabel('Sample');
ylabel('Amplitude');
title(ax1, 'Transmit and Receive Analysis');





Nsym = 6;           % Filter span in symbol durations
beta = 0.5;         % Roll-off factor
sampsPerSym = 8;    % Upsampling factor



% Filter
rctFilt = comm.RaisedCosineTransmitFilter(Shape='Normal', RolloffFactor=0.1, FilterSpanInSymbols=Nsym, OutputSamplesPerSymbol=sampsPerSym);



% Generate random data
DataL = 20; R = 1000; Fs = R * sampsPerSym;
hStr = RandStream('mt19937ar',Seed=0);
x = 2*randi(hStr,[0 1],DataL,1)-1;
tx = 1000 * (0: DataL - 1) / R;

yo = rctFilt([x; zeros(Nsym/2,1)]);
to = 1000 * (0: (DataL+Nsym/2)*sampsPerSym - 1) / Fs;

% Condition data
fltDelay = Nsym / (2*R);
yo = yo(fltDelay*Fs+1:end);
to = 1000 * (0: DataL*sampsPerSym - 1) / Fs;


% Set roll-off factor to 0.2
rctFilt2 = comm.RaisedCosineTransmitFilter( Shape='Normal', RolloffFactor=0.5, FilterSpanInSymbols=Nsym, OutputSamplesPerSymbol=sampsPerSym);
% Normalize filter
b = coeffs(rctFilt2);
rctFilt2.Gain = 1/max(b.Numerator);
yo1 = rctFilt2([x; zeros(Nsym/2,1)]); % Filter

yo1 = yo1(fltDelay*Fs+1:end); % Correct for propagation delay by removing filter transients


% Set roll-off factor to 0.9
rctFilt3 = comm.RaisedCosineTransmitFilter( Shape='Normal', RolloffFactor=0.9, FilterSpanInSymbols=Nsym, OutputSamplesPerSymbol=sampsPerSym);
% Normalize filter
b = coeffs(rctFilt3);
rctFilt3.Gain = 1/max(b.Numerator);
yo2 = rctFilt3([x; zeros(Nsym/2,1)]); % Filter
yo2 = yo2(fltDelay*Fs+1:end); % Correct for propagation delay by removing filter transients



% Plot data
stem(tx, x, 'kx'); hold on; 
plot(to, yo, 'g-');
plot(to, yo1, 'r-');
plot(to, yo2, 'b-');
hold off; 

% Set axes and labels
axis([0 25 -2 2]);  xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data','beta = 0.5', 'beta = 0.2', 'beta=0.9','Location','southeast')




