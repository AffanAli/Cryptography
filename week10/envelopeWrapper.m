function [result, aux] = envelopeWrapper(input_data, mode, varargin)
    kms_file = 'kms_store.mat';

    % Common: Load KMS
    if isfile(kms_file)
        load(kms_file, 'kms');
    else
        % Only create new KMS if encrypting; decrypting requires existing KMS
        if strcmpi(mode, 'encrypt')
            kms = KMS.init();
            kms = KMS.rotate(kms);
            save(kms_file, 'kms');
        else
            error('KMS file not found. Cannot decrypt without KMS store.');
        end
    end

    if strcmpi(mode, 'encrypt')
        [result, aux] = encrypt(input_data, kms, kms_file, varargin{:});
    elseif strcmpi(mode, 'decrypt')
        [result, aux] = decrypt(input_data, kms);
    else
        error('Invalid mode. Use "encrypt" or "decrypt".');
    end
end

function [envelope, aux] = encrypt(input_data, kms, kms_file, iv, aad)
    % Defaults
    if nargin < 4 || isempty(iv)
        iv = lower(reshape(dec2hex(randi([0 255], 1, 12))', 1, [])); 
    end
    if nargin < 5 || isempty(aad)
        aad = ''; 
    end
    aux = [];

    % Handle input data (File path or direct text)
    if (ischar(input_data) || isstring(input_data)) && exist(input_data, 'file') == 2
            fileContent = fileread(input_data);
    else
            fileContent = char(input_data);
    end

    % Build timestamped payload
    timestampStr = datestr(datetime('now'), 'yyyy-mm-dd HH:MM:SS');
    payloadPlaintext = sprintf('[TS:%s]\n%s', timestampStr, fileContent);

    % Generate DEK and Encrypt (Inner Layer)
    DEK = uint8(randi([0,255],[1,32])); % 32B (AES-256)
    key_hex = bytes_to_hex(DEK);
    
    % Encrypt using AES-GCM
    [C, T] = GCM_AE(key_hex, iv, payloadPlaintext, aad);

    % Wrap DEK with KMS (Outer Layer)
    [wrappedDEK, kms] = KMS.wrap(kms, DEK);
    
    % Record KEK version
    enabledMask = [kms.keks.enabled];
    enabledKeks = kms.keks(enabledMask);
    enabledVers = [enabledKeks.version];
    kekVersionUsed = max(enabledVers);
    
    % Save updated KMS (persisting any updates from wrap/rotate)
    save(kms_file, 'kms');

    % Construct Envelope
    envelope.iv = iv;
    envelope.tag = T;
    envelope.ciphertext = C;
    envelope.wrappedDEK = wrappedDEK;
    envelope.aad = aad;
    envelope.kekVersion = kekVersionUsed;
end

function [plaintext, auth_ok] = decrypt(input_data, kms)
    % Handle input_data (Envelope struct or path to .mat)
    if ischar(input_data) || isstring(input_data)
        if exist(input_data, 'file') == 2
            loaded = load(input_data);
            if isfield(loaded, 'envelope')
                envelope = loaded.envelope;
            else
                error('File does not contain an "envelope" variable.');
            end
        else
            error('Envelope file not found.');
        end
    elseif isstruct(input_data)
        envelope = input_data;
    else
        error('Invalid input for decrypt. Expecting envelope struct or .mat file path.');
    end

    % Unwrap DEK
    [DEK_u, kms] = KMS.unwrap(kms, envelope.wrappedDEK, envelope.kekVersion);
    key_hex_u = bytes_to_hex(DEK_u);

    % Decrypt data (GCM_AD)
    [P, A] = GCM_AD(key_hex_u, envelope.iv, envelope.ciphertext, envelope.aad, envelope.tag);
    auth_ok = A;
    
    % Simply return the recovered plaintext (raw bytes converted to char)
    % No timestamp stripping, no comparisons.
    plaintext = char(P);
end

function hex = bytes_to_hex(u8)
    hex = reshape(dec2hex(u8).',1,[]);
end
