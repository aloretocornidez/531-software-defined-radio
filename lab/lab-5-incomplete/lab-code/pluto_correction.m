% User tunable (samplesPerSymbol>=decimation)
samplesPerSymbol = 12; decimation = 6;

% Set up radio
tx = sdrtx('Pluto','Gain',-20);
rx = sdrrx('Pluto','SamplesPerFrame',1e6,'OutputDataType','double');

% Create binary data
data = randi([0 1],2^15,1);

% Create a QPSK modulator System object and modulate data
qpskMod = comm.QPSKModulator('BitInput',true); modData = qpskMod(data);

% Set up filters
rctFilt = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol', samplesPerSymbol);
rcrFilt = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol',  samplesPerSymbol,'DecimationFactor',decimation);
symsync = comm.SymbolSynchronizer(TimingErrorDetector="Zero-Crossing (decision-directed)",SamplesPerSymbol=2, DampingFactor=1, DetectorGain=2.7, NormalizedLoopBandwidth=0.01);
carsync = comm.CarrierSynchronizer(Modulation="QPSK", SamplesPerSymbol=2);
evm = comm.EVM(ReferenceSignalSource="Estimated from reference constellation");

% Pass data through radio
tx.transmitRepeat(rctFilt(modData)); 

% Set up visualization and delay objects
VFD = dsp.VariableFractionalDelay; 
cd = comm.ConstellationDiagram;

% Process received data for timing offset
remainingSPS = samplesPerSymbol/decimation;

% Grab end of data where AGC has converged
evmVec = [];
for index = 0:50
  % Recive data
  data = rcrFilt(rx());

  % Cut off data to required size.
  data = data(end-remainingSPS*1000+1:end);


  carData = carsync(data);
  symData = symsync(carData);

  % Constellation Diagram
  cd(symData);

  % Time look at updates.
  pause(0.1);

  % Plot the vector data.
  evmVec = [evmVec evm(data)];
end

figure
plot(evmVec)
title('EVM')
xlim([0 50])
xlabel('Iteration')
ylabel('Magnitude')

