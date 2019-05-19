% Calculate the PRBCH and Cell RS REs and symbols corresponding to the
% repetition part
function [pbchrepSymbols,pbchrepIndices, pbchCellRSrepSymbols, pbchCellRSrepIndices] = getPBCHRep(enb,pbchCoreSymbols,pbchCoreIndices,pbchCoreCellRSSymbols,pbchCoreCellRSIndices)
    pbchrepIndices = [];
    pbchrepSymbols = [];
    symMappings = {};
    pbchCellRSrepIndices = [];
    pbchCellRSrepSymbols = [];

    % For both FDD and TDD modes, there is no repetition if NDLRB = 6
    if enb.NDLRB==6
        return
    end

    % Get the subcarriers for the PBCH core part
    [pbchCoreSubcarriers,ofdmSymbols,~] = ind2sub(lteDLResourceGridSize(enb),pbchCoreIndices);
    % Get the subcarriers for the Cell RS core part
    [pbchCellRSCoreSubcarriers,ofdmSymbolsCellRS,~] = ind2sub(lteDLResourceGridSize(enb),pbchCoreCellRSIndices);

    % FDD reps only in subframes 9 (frame n-1) and 0 (frame n) and TDD only
    % reps in subframes 0 and 5 in the same frame
    % Get the subframe symbol numbers in which the reps go onto
    if strcmpi(enb.DuplexMode,'FDD')
        if strcmpi(enb.CyclicPrefix,'Normal')
            NsymbDL = 7;
            if (mod(enb.NSubframe,10) == 0)
                symMappings = { 5 ;
                               12 ;
                               13 ;
                               [4 14]};
            elseif (mod(enb.NSubframe,10)==9)
                symMappings = { [4 8 12] ;
                                [5 9 13] ;
                                [6 10 14] ;
                                [7 11]};
            end
        else
            NsymbDL = 6;
            if (mod(enb.NSubframe,10) == 0)
                symMappings = {[] ;
                               4  ;
                               11 ;
                               12};
            elseif (mod(enb.NSubframe,10)==9)
                symMappings = { [4 7] ;
                                [5 8] ;
                                [6 9] ;
                                [10 11]};
            end
        end

    else
        if strcmpi(enb.CyclicPrefix,'Normal')
            NsymbDL = 7;
            if (mod(enb.NSubframe,10) == 0)
                symMappings = { [4 12]  ;
                                [5 13] ;
                                6 ;
                                7};
            elseif (mod(enb.NSubframe,10)==5) && enb.NDLRB>15
                symMappings = { [4 8 12] ;
                                [5 9 13] ;
                                [6 10] ;
                                [7 11]};
            end
        else
            NsymbDL = 6;
            if (mod(enb.NSubframe,10) == 0)
                symMappings = {4 ;
                               5 ;
                               6 ;
                               11};
            elseif (mod(enb.NSubframe,10)==5) && enb.NDLRB>15
                symMappings = { [4 7] ;
                                [5 8] ;
                                [6 9] ;
                                [10 11]};
            end
        end

    end

    % If this is a repetition subframe, find the indices
    if ~isempty(symMappings)

        % Create an empty subframe grid
        sfgrid = lteDLResourceGrid(enb);
        sfgridRS = lteDLResourceGrid(enb);
        for osymb = 1:4 % For all 4 PBCH symbols
            % Extract out each core symbol to map to one or more OFDM
            % symbols
            coreOFDMsymb = pbchCoreSymbols(ofdmSymbols==(osymb+NsymbDL));
            coreOFDMsymbRS = pbchCoreCellRSSymbols(ofdmSymbolsCellRS==(osymb+NsymbDL));

            % Map to all new repetition OFDM symbols in the current
            % subframe
            for m = 1:numel(symMappings{osymb,1})
                % create the indices for the current symbol (subcarriers
                % are the same as core symbols)
                symtoMap = symMappings{osymb,1}(m);
                sfgrid(pbchCoreSubcarriers(ofdmSymbols==(osymb+NsymbDL)),symtoMap,:) = coreOFDMsymb;
                sfgridRS(pbchCellRSCoreSubcarriers(ofdmSymbolsCellRS==(osymb+NsymbDL)),symtoMap,:) = coreOFDMsymbRS;

            end

        end

        % As per TS 36.211 section 6.6.4, the PBCH repetitions and cell RS
        % repetitions are punctured by CSI (& ZP CSI) RS signals. So clear
        % these positions
        csirsIndices = lteCSIRSIndices(enb);
        sfgrid(csirsIndices) = 0;
        sfgridRS(csirsIndices) = 0;

        % Now get the PBCH repeating symbols and indices
        pbchrepIndices = find(sfgrid);
        pbchrepSymbols = sfgrid(pbchrepIndices);
        % Now get the CellRS repeating symbols and indices
        pbchCellRSrepIndices = find(sfgridRS);
        pbchCellRSrepSymbols = sfgridRS(pbchCellRSrepIndices);

    end
end