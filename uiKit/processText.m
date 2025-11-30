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
            if isempty(key) || isempty(nonceStr), error('Key and Nonce required.'); end
            if strcmpi(mode, 'decrypt') && ~hasBinaryData
                 try
                     clean_text = strrep(text, ' ', '');
                     text = uint8(hex2dec(reshape(clean_text, 2, [])')');
                 catch
                     error('Input for decryption must be Hex string.');
                 end
            end
            out_uint8 = xorCipher(text, key, nonceStr, mode);
            
            % Display Logic
            is_printable = all((out_uint8 >= 32 & out_uint8 <= 126) | out_uint8 == 9 | out_uint8 == 10 | out_uint8 == 13);
            if is_printable, result = char(out_uint8);
            else, result = lower(reshape(dec2hex(out_uint8)', 1, [])); end
            
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
            if isempty(p) || isempty(q), error('P and Q required.'); end
            addpath(genpath('week8'));
            if strcmpi(mode, 'encrypt')
                if isnumeric(text), text = char(text); end
                result = num2str(rsaWrapper(text, p, q, 'encrypt'));
            else
                if ischar(text) || isstring(text), text = str2num(char(text)); end
                result = rsaWrapper(text, p, q, 'decrypt');
            end
            
        elseif strcmp(method, 'Envelope Encryption (KMS)')
            addpath(genpath('week10'));
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