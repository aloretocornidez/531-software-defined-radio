%% Set up the variables.
numFrames = 100;
frameSize = 2^10;

samplesPerSymbol = 4;
sampleRateHz = 1e6; 

numSamples = numFrames*frameSize;

modulationOrder = 2;
filterSymbolSpan = 4;

phaseOffset = 60;
delay = 0;

snr = 25;
timingOffset = samplesPerSymbol*delay;

%% Constellation Diagrams.
cdPre = comm.ConstellationDiagram('ReferenceConstellation', [-1 1], 'Name', 'Baseband');
cdPost = comm.ConstellationDiagram('ReferenceConstellation', [-1 1], 'Name', 'Baseband with Timing Offset');
cdPre.Position(1) = 50;
cdPost.Position(1) = cdPre.Position(1)+cdPre.Position(3)+10; % Place side by side


%% Generating the Data
data = randi([0 modulationOrder-1], numSamples*2, 1);
mod = comm.DBPSKModulator(); modulatedData = mod(data);

%% Add TX/RX Filters
TxFlt = comm.RaisedCosineTransmitFilter('OutputSamplesPerSymbol', samplesPerSymbol,'FilterSpanInSymbols', filterSymbolSpan);
RxFlt = comm.RaisedCosineReceiveFilter('InputSamplesPerSymbol', samplesPerSymbol,'FilterSpanInSymbols', filterSymbolSpan,'DecimationFactor', 1);

RxFltRef = clone(RxFlt);

%% Add noise source
chan = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (SNR)','SNR',snr,'SignalPower',1,'RandomStream', 'mt19937ar with seed');
pfo = comm.PhaseFrequencyOffset(PhaseOffset=phaseOffset);

%% Add delay
varDelay = dsp.VariableFractionalDelay;

symsync = comm.SymbolSynchronizer(TimingErrorDetector="Zero-Crossing (decision-directed)", ...
    SamplesPerSymbol=4, ...
    DampingFactor=1, ...
    DetectorGain=2.7, ...
    NormalizedLoopBandwidth=0.01);
carsync = comm.CarrierSynchronizer(Modulation="BPSK", SamplesPerSymbol=samplesPerSymbol);

evm = comm.EVM(ReferenceSignalSource="Estimated from reference constellation", ReferenceConstellation=[-1 1]);
decim = dsp.FIRDecimator(DecimationFactor=4);

%% Model of error
% Add timing offset to baseband signal
filteredData = [];
evmVec = [];
evmVec2 = [];

for k=1:frameSize:(numSamples - frameSize)
  timeIndex = (k:k+frameSize-1).';
  % Filter signal
  mdata = modulatedData(timeIndex);
  filteredTXData = TxFlt(mdata);
  % Pass through channel
  noisyData = pfo(chan(filteredTXData));
  % Time delay signal
  offsetData = varDelay(noisyData, k/frameSize*timingOffset);
  % Filter signal
  filteredData = RxFlt(offsetData);filteredDataRef = RxFltRef(noisyData);
  car_sync_data = carsync(filteredData);
  synced_data = symsync(car_sync_data);
  filteredData = decim(filteredData);
  filteredDataRef = decim(filteredDataRef);
  % Visualize Error
  cdPre(filteredData);cdPost(synced_data);pause(0.1); %#ok<*UNRCH>
  synced_data(numel(mdata)) = 0;
  evmVec = [evmVec evm(synced_data)];
  evmVec2 = [evmVec2 evm(filteredData)];
end

t = tiledlayout(1, 2);
title(t, 'Error Vector Magnitude w/ Phase Offset')
nexttile
plot(evmVec2)
title(['EVM | No Timing Correction | SNR: ' num2str(snr)]);
ylabel('Magnitude')
xlabel('Frame Number')

nexttile
plot(evmVec)
title(['EVM  | With Timing Correction | SNR: ' num2str(snr)]);
ylabel('Magnitude')
xlabel('Frame Number')

