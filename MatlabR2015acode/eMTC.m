clear all;clc;

enb = struct();
enb.NDLRB = 25;                       % LTE carrier BW
enb.NCellID = 1;                      % The cell ID
enb.CellRefP = 1;                     % Number of cell-specific ports
enb.CFI = 3;                          % CFI indicator
enb.DuplexMode = 'FDD';               % Duplex mode
enb.TDDConfig = 1;                    % Uplink/Downlink configuration (TDD)
enb.CyclicPrefix = 'Normal';          % Cyclic prefix duration
enb.NSubframe = 0;                    % Subframe number
enb.NFrame = 0;                       % Frame number
enb.CSIRSPeriod = 'Off';              % CSI-RS period control
enb.CSIRSConfig = 0;                  % CSI-RS configuration
enb.CSIRefP = enb.CellRefP;           % Number of CSI-RS antenna ports
enb.ZeroPowerCSIRSPeriod = 'Off';     % Zero power CSI-RS period control
enb.ZeroPowerCSIRSConfig = 0;         % Zero power CSI-RS configuration
enb.Ng = 'Sixth';                     % HICH group multiplier
enb.PHICHDuration = 'Extended';       % PHICH duration

% Set up hopping specific parameters
enb.HoppingOffset = 1;% Hopping offset 1...maxAvailableNarrowbands (TS 36.331)
enb.NChDLNBhop = 2;   % Number of narrowbands over which MPDCCH/PDSCH hops (2 or 4)
enb.NChDLNB = 2;      % Number of subframes in one hop/hopping block length

% MPDCCH Configuration
mpdcch = struct();
mpdcch.Hopping = true;          % Enable/Disable frequency hopping (only for 1.4MHz)
mpdcch.NRepMPDCCH = 8;          % The total number of MPDCCH repetitions
mpdcch.EPDCCHECCE = [0 7];      % ECCE range used for this MPDCCH (8 ECCE)
mpdcch.EPDCCHType = 'Localized';% Transmission type ('Localized', 'Distributed')
mpdcch.EPDCCHNID = 1;           % Cell ID/MPDCCH ID depending on search space type
mpdcch.EPDCCHStart = 4;         % MPDCCH start OFDM symbol in each subframe
mpdcch.RNTI = 1;                % RNTI for use with 'Localized' transmission

mpdcch.InitPRBSet = (2:3)';
mpdcch.InitNSubframe = 0; % Absolute subframe number of first MPDCCH subframe

% PDSCH Configuration
pdsch = struct();
pdsch.Hopping = true;      % Enable/Disable frequency hopping (only for 1.4MHz)
pdsch.NRepPDSCH = 16;      % The total number of PDSCH repetitions
pdsch.CEMode = 'A';        % A for CE mode A and B for CE mode B
pdsch.TxScheme = 'Port0';  % Port 0 or TxDiversity or Spatial Mux or Port 7
pdsch.Modulation  = 'QPSK';% Modulation scheme (QPSK/16QAM)
pdsch.NLayers = 1;         % Number of layers
pdsch.RV = 0;              % Redundancy version for DL-SCH processing
pdsch.RNTI = 1;            % RNTI used for the UE
pdsch.NSCID = 0;           % Scrambling identity
pdsch.TrBlkSizes = 100;    % Transport block size
pdsch.InitPRBSet = (1:2)';     % 0-based PRB index
pdsch.InitNarrowbandIndex = 0; % 0-based wideband index
% In this example, we disable frequency hopping when transmission is over 2
% or more narrowbands
if numel(pdsch.InitNarrowbandIndex) > 1
    pdsch.Hopping = false;
    mpdcch.Hopping = false;
end
enb.RepPBCHEnable = true;

% Specify the power scaling in dB for MPDCCH, MPDCCH DM-RS, PDSCH and
% reference signals (Cell RS or DM-RS)
mpdcch.MPDCCHPower = 30;
mpdcch.MPDCCHDMRSPower = 32;
pdsch.Rho = 25;
pdsch.RSPower = 80;
% Power levels for the PBCH core and reps parts
enb.PBCHPower = 33;
enb.PBCHRepsPower = 36;
% Power level for the PBCH Cell RS reps
enb.PBCHCellRSRepsPower = 28;

totmtcSubframes = mpdcch.InitNSubframe+mpdcch.NRepMPDCCH+2+pdsch.NRepPDSCH;
% Identify all downlink subframes in a frame
info = arrayfun(@(x)lteDuplexingInfo(setfield(enb,'NSubframe',x)),0:9);
dlsfs = arrayfun(@(x)strcmpi(x.SubframeType,'Downlink'),info);

% Total absolute subframes to simulate
sfsnumlastFrame = getlastabsSF(dlsfs,totmtcSubframes);
totSubframes = floor(totmtcSubframes/sum(dlsfs)) *10 + sfsnumlastFrame;

% Absolute subframe number of first PDSCH subframe, this would be two
% subframes after the MPDCCH subframes (assuming no non BL/CE subframes)
lastSfForMPDCCHPlus2 = getlastabsSF(dlsfs,mpdcch.NRepMPDCCH + 2); % Last subframe number in last frame for MPDCCH+2
pdsch.InitNSubframe = mpdcch.InitNSubframe + floor((mpdcch.NRepMPDCCH + 2)/sum(dlsfs)) *10 + lastSfForMPDCCHPlus2;

% Find the last absolute subframe for MPDCCH transmission
lastSfForMPDCCH = getlastabsSF(dlsfs,mpdcch.NRepMPDCCH); % Last subframe number in last frame for MPDCCH
mtclastabsSfForMPDCCH = mpdcch.InitNSubframe + floor((mpdcch.NRepMPDCCH)/sum(dlsfs)) *10 + lastSfForMPDCCH;
% Find the MPDCCH data bit capacity
[~,info] = lteEPDCCHIndices(enb,setfield(mpdcch,'EPDCCHPRBSet',mpdcch.InitPRBSet)); %#ok<SFLD>
% Define DCI message bits
dciBits = ones(26,1);
% Create the coded DCI bits
codedDciBits = lteDCIEncode(mpdcch,dciBits,info.EPDCCHG);
% Find the LTE-M PDSCH data bit capacity, this should not include the PBCH,
% PSS, SSS and CSI-RS REs. So we select the subframe 9 which is a DL
% subframe in both FDD and TDD duplex modes (Note: subframe 9 is not DL for
% TDDConfig 0, TDDConfig 0 does not have a 'normal' DL subframe)
fullPDSCHsf = 9;

[~,fullInfo] = ltePDSCHIndices(setfield(enb,'NSubframe',fullPDSCHsf),pdsch,getPDSCHAllocation(enb,pdsch));  %#ok<SFLD>
% Define DL-SCH message bits
trData = ones(pdsch.TrBlkSizes(1),1);
% Create the coded DL-SCH bits
codedTrBlock = lteDLSCH(enb,pdsch,fullInfo.G,trData);
% Number of subframes in a scrambling block
Nacc = 1;
if strcmpi(enb.DuplexMode,'FDD') && mpdcch.NRepMPDCCH >= 4
    Nacc = 4;
elseif strcmpi(enb.DuplexMode,'TDD') && mpdcch.NRepMPDCCH >= 10
    Nacc = 10;
end

% Create a resource grid for the entire transmission. The MPDCCH, PDSCH and
% DM-RS symbols will be mapped in this array. Note that we are creating the
% grid for 4 antenna planes as the MPDCCH transmission can be sent on ports
% selected from the set (107, 108, 109 and 110)
subframeSize = lteDLResourceGridSize(enb,4);
sfgrid = zeros([subframeSize(1) subframeSize(2)*totSubframes subframeSize(3:end)]);

mpdcchSym = []; % Initialize MPDCCH symbols
mpdschSym = []; % Initialize PDSCH symbols
mpbchCoreSymFull = [];  % Initialize PBCH symbols
startSubframe = enb.NFrame*10+enb.NSubframe; % Initial absolute subframe number
for sf = startSubframe + (0:totSubframes -1)
    % Set current absolute subframe and frame numbers
    enb.NSubframe = mod(sf,10);
    enb.NFrame = floor((sf)/10);

    % Skip processing if this is not a downlink subframe
    duplexInfo = lteDuplexingInfo(enb);
    if ~strcmpi(duplexInfo.SubframeType,'Downlink')
        continue
    end

    % Transmitting the MPDCCH
    if (sf >= mpdcch.InitNSubframe) && (sf < mtclastabsSfForMPDCCH)
        % Calculate the PRBSet used in the current subframe
        prbset = getHoppingAllocation(enb,mpdcch);

        % Calculate the MPDCCH indices for the current subframe
        mpdcch.EPDCCHPRBSet = prbset;
        [mpdcchIndices,info] = lteEPDCCHIndices(enb,mpdcch);

        % Create an empty subframe grid
        subframe = lteDLResourceGrid(enb,4);

        % Encode MPDCCH symbols from DCI codeword
        % In the case of repetition, the same symbols are repeated in each of
        % a block of NRepMPDCCH subframes. Frequency hopping is applied as required
        if ~mod(sf,Nacc) || isempty(mpdcchSym)
            mpdcchSym = lteEPDCCH(enb,mpdcch,codedDciBits)*db2mag(mpdcch.MPDCCHPower);
        end
        % Map MPDCCH symbols to the subframe grid
        subframe(mpdcchIndices) = mpdcchSym;

        % Create MPDCCH DM-RS
        % The MPDCCH and its reference symbols are transmitted on the same
        % port(s) and is transmitted only on the PRBs in which the
        % corresponding MPDCCH is mapped. The DM-RS sequence is the same as for
        % the EPDCCH as given by the equations in TS 36.211 section 6.10.3A
        mpdcchDMRS = lteEPDCCHDMRS(enb,mpdcch)*db2mag(mpdcch.MPDCCHDMRSPower); % MPDCCH DM-RS symbols
        mpdcchDMRSIndices = lteEPDCCHDMRSIndices(enb,mpdcch); % MPDCCH DM-RS indices
        subframe(mpdcchDMRSIndices) = mpdcchDMRS;   % Map DM-RS signals to the grid

        % Now assign the current subframe into the overall grid
        sfgrid(:,(1:subframeSize(2))+sf*subframeSize(2),:) = subframe;
    end
    if (sf >= pdsch.InitNSubframe)

        % Calculate the PRBSet used in the current subframe
        prbset = getPDSCHAllocation(enb,pdsch);

        % Calculate the PDSCH indices for the current subframe
        pdsch.PRBSet = prbset;
        mpdschIndices = ltePDSCHIndices(enb,pdsch,pdsch.PRBSet);
        % If the subframe contains PBCH, PSS, SSS, CSI-RS or Zero Power
        % CSI-RS REs, then we need to puncture the corresponding symbols
        % from the mapping but the rate matching should be to the full
        % PDSCH capacity ignoring the possible presence of these symbols.
        % This is done by setting the subframe and TDDConfig (if TDD mode)
        % to a subframe containing no PBCH, PSS and SSS and turning off the
        % CSI-RS and ZP CSI-RS. The full set of possible PDSCH indices are
        % recalculated every subframe as these can change when frequency
        % hopping
        enbTemp = enb;
        enbTemp.TDDConfig = 1;              % TDDConfig 0 has no full PDSCH subframe
        enbTemp.NSubframe = fullPDSCHsf;    % Set the subframe to a full PDSCH subframe
        enbTemp.CSIRSPeriod = 'Off';        % CSI-RS period control
        enbTemp.ZeroPowerCSIRSPeriod = 'Off'; % Zero power CSI-RS period control
        mpdschIndicesFull = ltePDSCHIndices(enbTemp,pdsch,pdsch.PRBSet);
        [~, txmpdschIndicesPositions] = intersect(mpdschIndicesFull,mpdschIndices);

        % Create an empty subframe grid
        subframe = lteDLResourceGrid(enb,4);

        % Encode PDSCH symbols from the codeword
        % In the case of repetition, the same symbols are repeated in each of
        % a block of NRepPDSCH subframes. Frequency hopping is applied as required
        if ~mod(sf,Nacc) || isempty(mpdschSym)
            mpdschSym = ltePDSCH(enb,pdsch,codedTrBlock)*db2mag(pdsch.Rho);
        end
        % Map punctured PDSCH symbols to the subframe grid
        subframe(mpdschIndices) = mpdschSym(txmpdschIndicesPositions);

        % Transmit UE-specific reference signal (DM-RS) if applicable
        if any(strcmpi(pdsch.TxScheme,{'Port5' 'Port7-8' 'Port8' 'Port7-14'}))
            ueRSIndices = lteDMRSIndices(enb,pdsch);
            ueRSSymbols = lteDMRS(enb,pdsch);
            subframe(ueRSIndices) = ueRSSymbols*db2mag(pdsch.RSPower);  % Map symbols to the grid
        end

        % Now assign the current subframe into the overall grid
        sfgrid(:,(1:subframeSize(2))+sf*subframeSize(2),:) = subframe;
    end
    subframe = sfgrid(:,(1:subframeSize(2))+sf*subframeSize(2),:);
    if(mod(enb.NSubframe,10)==0)
        % Generate symbols if its the first simulated frame or
        % when mod(NFrame,4) is 0;
        if ~mod(enb.NFrame,4) || isempty(mpbchCoreSymFull)
            mpbchCoreSymFull = getMPBCHCore(enb);
        end
        mpbchCoreIndices = ltePBCHIndices(enb,{'1based'});
        % Now extract out the core part for the Frame
        mpbchCoreSym = mpbchCoreSymFull(:,mod(enb.NFrame,4)+1);
        % Map the PBCH core symbols to the subframe
        subframe(mpbchCoreIndices) = mpbchCoreSym*db2mag(enb.PBCHPower);

        % Now assign the current subframe into the overall grid
        sfgrid(:,(1:subframeSize(2))+sf*subframeSize(2),:) = subframe;

        % Get the cell RS symbols and indices to be repeated if PBCH
        % repetitions are enabled
        [mpbchCoreCellRSSymbols,mpbchCoreCellRSIndices] = getPBCHCoreCellRS(enb);

    elseif enb.RepPBCHEnable && strcmpi(enb.DuplexMode,'FDD') && (mod(enb.NSubframe,10)==9)
        % If this is the 9th subframe in FDD mode, then create the core
        % symbols and indices for the next frame to be used for PBCH
        % repetitions in this subframe
        enbNext = enb;
        enbNext.NSubframe = 0;
        enbNext.NFrame = enbNext.NFrame+1; % Advance to the next frame
        % if the current frame contained the last PBCH block, then we need
        % the new set of PBCH symbols
        if mod(enb.NFrame,4)==3
            mpbchCoreSymFull = getMPBCHCore(enbNext);
        end
        % Now extract out the core part for the Frame
        mpbchCoreSym = mpbchCoreSymFull(:,mod(enbNext.NFrame,4)+1);
        mpbchCoreIndices = ltePBCHIndices(enbNext,{'1based'});
        [mpbchCoreCellRSSymbols,mpbchCoreCellRSIndices] = getPBCHCoreCellRS(enbNext);
    end
    % PBCH repetition part if enabled
    if (enb.RepPBCHEnable)
        % Get the PBCH repetition part consisting of repeating PBCH symbols
        % and repeating Cell RS signals and corresponding indices
        [pbchrepSymbols, pbchrepIndices, pbchCellRSrepSymbols, pbchCellRSrepIndices] = getPBCHRep(enb,mpbchCoreSym,mpbchCoreIndices,mpbchCoreCellRSSymbols,mpbchCoreCellRSIndices);
        % Map the PBCH repetitions to the grid
        subframe(pbchrepIndices) = pbchrepSymbols*db2mag(enb.PBCHRepsPower);
        % Map the Cell RS repetitions to the grid
        subframe(pbchCellRSrepIndices) = pbchCellRSrepSymbols*db2mag(enb.PBCHCellRSRepsPower);
    end

    % Now assign the current subframe into the overall grid
    sfgrid(:,(1:subframeSize(2))+sf*subframeSize(2),:) = subframe;
end
waveform = lteOFDMModulate(enb,sfgrid);

% Create an image of overall resource grid
% Plot the first port for all other channels
figure(1)
image(abs(sfgrid(:,:,1)));
axis xy;
title(sprintf('LTE-M CEMode%s Downlink RE Grid (NRepMPDCCH = %d, NRepPDSCH = %d)',pdsch.CEMode,mpdcch.NRepMPDCCH,pdsch.NRepPDSCH))
xlabel('OFDM symbols')
ylabel('Subcarriers')
% Create the legend box to indicate the channel/signal types associated with the REs
reNames = {'MPDCCH';'MPDCCH DRS';'PDSCH';'PBCH Core'; 'PBCH Reps'; 'Cell RS Reps'};
clevels = round(db2mag([mpdcch.MPDCCHPower mpdcch.MPDCCHDMRSPower  pdsch.Rho enb.PBCHPower enb.PBCHRepsPower enb.PBCHCellRSRepsPower]));
% If using DM-RS, include in legend
if any(strcmpi(pdsch.TxScheme,{'Port5' 'Port7-8' 'Port8' 'Port7-14'}))
    reNames{end+1} = 'DMRS';
    clevels(end+1) = pdsch.RSPower;
end
N = numel(reNames);
L = line(ones(N),ones(N), 'LineWidth',8); % Generate lines
% Index the color map
cmap = colormap(gcf);
set(L,{'color'},mat2cell(cmap( min(1+clevels,length(cmap) ),:),ones(1,N),3));   % Set the colors according to cmap
legend(reNames{:});

% Create separate plots of the control/data waveforms
figure(2)
plot(abs(waveform(:,1)))
title('PBCH and PDSCH time domain waveform')
xlabel('Samples')
ylabel('Amplitude')