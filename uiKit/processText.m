function processText(handles, mode, fig)
    text = handles.inputTextArea.Value;
    hasBinaryData = isappdata(fig, 'BinaryInputData');
    
    if hasBinaryData
        text = getappdata(fig, 'BinaryInputData');
    else
        if isempty(text)
            uialert(fig, 'Please enter text or upload a file.', 'Input Error');
            return; 
        end
        if iscell(text), text = strjoin(text, newline); end
    end

    method = handles.methodDropdown.Value;
    
    % Distinguish truly-binary files from plain text files loaded via Upload
    isBinaryFile = false;
    if isappdata(fig, 'IsBinaryInputFile')
        isBinaryFile = getappdata(fig, 'IsBinaryInputFile');
    end
        
    try
        result = '';
        if strcmp(method, 'Caesar')
            if isnumeric(text), text = char(text); end
            shift = str2double(handles.shiftEdit.Value);
            if isnan(shift), error('Invalid shift value.'); end
            result = caeser(text, shift, mode);
            
        elseif strcmp(method, 'One-Time Pad')
            if isnumeric(text), text = char(text); end
            key = handles.keyEdit.Value;
            if isempty(key), error('Please enter a key.'); end
            result = oneTimePad(text, key, mode);
            
        elseif strcmp(method, 'XOR - Bitwise stream cipher')
            key = handles.keyEdit.Value;
            nonceStr = handles.nonceEdit.Value;
            if isempty(key) || isempty(nonceStr)
                error('Key and Nonce required.');
            end
            
            % Binary/image flow only for truly-binary files
            if hasBinaryData && isBinaryFile
                % Delegate binary/image handling to a dedicated helper
                result = handleXorBinary(fig, mode, key, nonceStr);
            else
                % --- Text / hex flow (existing behavior) ---
                inputBytes = [];
                if strcmpi(mode, 'decrypt')
                    % Expect hex string and convert back to bytes
                    try
                        clean_text = strrep(text, ' ', '');
                        inputBytes = uint8(hex2dec(reshape(clean_text, 2, [])')');
                    catch
                        error('Input for decryption must be Hex string.');
                    end
                else
                    % Encrypt plain text directly
                    if ischar(text) || isstring(text)
                        inputBytes = uint8(char(text));
                    else
                        inputBytes = uint8(text);
                    end
                end

                out_uint8 = xorCipher(inputBytes, key, nonceStr, mode);

                % Display Logic
                is_printable = all((out_uint8 >= 32 & out_uint8 <= 126) | out_uint8 == 9 | out_uint8 == 10 | out_uint8 == 13);
                if is_printable
                    result = char(out_uint8);
                else
                    result = lower(reshape(dec2hex(out_uint8)', 1, []));
                end
            end
            
        elseif strcmp(method, 'AES block cipher')
            if isnumeric(text), text = char(text); end
            key = handles.keyEdit.Value;
            if length(key) ~= 64, error('AES Key must be 64 hex chars.'); end
            if strcmpi(mode, 'decrypt')
                result = aesBlockCipher(text, key, mode);
                try, result = strtrim(char(hex2dec(reshape(result, 2, [])')')); end
            else
                result = aesBlockCipher(text, key, mode);
            end
            
        elseif strcmp(method, 'DES block cipher')
            if isnumeric(text), text = char(text); end
            key = getappdata(fig, 'DESKey');
            if isempty(key), error('No DES Key found.'); end
            result = desBlockCipher(text, key, mode);
            
        elseif strcmp(method, 'Keyed Hash')
            if isnumeric(text), text = char(text); end
            key = handles.keyEdit.Value;
            if isempty(key), error('Key required.'); end
            result = HMAC(key, text, handles.algoDropdown.Value);
            
        elseif strcmp(method, 'RSA')
            p = handles.rsaPEdit.Value; q = handles.rsaQEdit.Value;
            % Treat non-positive values (e.g. cleared 0) as "not provided"
            if isempty(p) || isempty(q) || p <= 0 || q <= 0
                error('P and Q required.');
            end
            addpath(genpath('week8'));
            if strcmpi(mode, 'encrypt')
                if isnumeric(text), text = char(text); end
                result = num2str(rsaWrapper(text, p, q, 'encrypt'));
            else
                if ischar(text) || isstring(text), text = str2num(char(text)); end
                result = rsaWrapper(text, p, q, 'decrypt');
            end
            
        elseif strcmp(method, 'Envelope Encryption (KMS)')
            if strcmpi(mode, 'encrypt')
                iv = handles.envIVEdit.Value;
                aad = handles.envAADEdit.Value;
                inputToWrapper = text;
                if isappdata(fig, 'InputFilePath')
                    inputToWrapper = getappdata(fig, 'InputFilePath');
                end
                [env, ~] = envelopeWrapper(inputToWrapper, 'encrypt', iv, aad);
                
                result = sprintf('Envelope Encryption Successful!\n\nIV: %s\nTag: %s\nCiphertext Length: %d bytes\nWrapped DEK Length: %d bytes\nKEK Version: %d\nAAD: %s', ...
                    env.iv, env.tag, length(env.ciphertext), length(env.wrappedDEK), env.kekVersion, env.aad);
                
                [file, path] = uiputfile('envelope.mat', 'Save Envelope Data');
                if ~isequal(file, 0)
                    envelope = env;
                    save(fullfile(path, file), 'envelope');
                    result = [result newline newline 'Envelope saved to: ' file];
                else
                    result = [result newline newline '(Envelope not saved)'];
                end
            else
                if isappdata(fig, 'InputFilePath')
                    filePath = getappdata(fig, 'InputFilePath');
                    if ~endsWith(filePath, '.mat'), error('Upload .mat file.'); end
                    
                    [plaintext, auth_ok] = envelopeWrapper(filePath, 'decrypt');
                    
                    if auth_ok
                         result = plaintext;
                    else
                         result = ['[AUTH FAILED - WARNING] ' newline plaintext];
                    end
                else
                    error('Upload envelope .mat file to decrypt.');
                end
            end
        end
        
        handles.outputTextArea.Value = result;
    catch ME
        uialert(fig, ME.message, 'Processing Error');
    end
end

function result = handleXorBinary(fig, mode, key, nonceStr)
    dataBytes = getappdata(fig, 'BinaryInputData');

    out_uint8 = xorCipher(dataBytes, key, nonceStr, mode);

    % Suggest a default filename based on the input file (if any)
    defaultName = 'xor_output.bin';
    dialogTitle = 'Save XOR Output File';

    if isappdata(fig, 'InputFilePath')
        inputPath = getappdata(fig, 'InputFilePath');
        [~, baseName, ext] = fileparts(inputPath);

        if strcmpi(mode, 'encrypt')
            defaultName = sprintf('%s%s.xor', baseName, ext);
            dialogTitle = 'Save XOR Encrypted File';
        else
            defaultName = sprintf('%s_dec%s', baseName, ext);
            dialogTitle = 'Save XOR Decrypted File';
        end
    end

    [file, path] = uiputfile('*.*', dialogTitle, defaultName);

    if ~isequal(file, 0)
        fid = fopen(fullfile(path, file), 'wb');
        fwrite(fid, out_uint8, 'uint8');
        fclose(fid);

        result = sprintf('XOR %sion successful.\nSaved to: %s', mode, file);
    else
        result = sprintf('XOR %sion successful (file not saved).', mode);
    end
end