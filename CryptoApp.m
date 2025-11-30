function CryptoApp
    % Create UI Figure
    fig = uifigure('Name', 'Crypto App', 'Position', [100 100 700 600]); 
    
    % Grid Layout
    gl = uigridlayout(fig, [7, 4]); 
    gl.RowHeight = {40, 40, 30, 30, 150, 40, 150}; 
    gl.ColumnWidth = {100, '1x', '1x', 160}; 
    
    % Store user data (RSA P/Q) in app data if needed, or just prompt
    
    % File Upload Section
    uploadBtn = uibutton(gl, 'Text', 'Upload File');
    uploadBtn.Layout.Row = 1;
    uploadBtn.Layout.Column = 1;
    uploadBtn.BackgroundColor = [0.30, 0.50, 0.90]; 
    uploadBtn.FontColor = [1 1 1];
    uploadBtn.FontWeight = 'bold';
    
    fileNameLabel = uilabel(gl);
    fileNameLabel.Text = 'No file selected';
    fileNameLabel.Layout.Row = 1;
    fileNameLabel.Layout.Column = [2 4];

    % Method Selection
    methodLabel = uilabel(gl);
    methodLabel.Text = 'Method:';
    methodLabel.Layout.Row = 2;
    methodLabel.Layout.Column = 1;
    methodLabel.HorizontalAlignment = 'right';

    methodDropdown = uidropdown(gl);
    methodDropdown.Items = {'Caesar', 'One-Time Pad', 'XOR - Bitwise stream cipher', 'DES block cipher', 'AES block cipher', 'Keyed Hash', 'RSA'};
    methodDropdown.Layout.Row = 2;
    methodDropdown.Layout.Column = [2 4];

    % Parameters (Shift / Key)
    % Shift
    shiftLabel = uilabel(gl);
    shiftLabel.Text = 'Shift:';
    shiftLabel.Layout.Row = 3;
    shiftLabel.Layout.Column = 1;
    shiftLabel.HorizontalAlignment = 'right';
    
    shiftEdit = uieditfield(gl, 'text');
    shiftEdit.Layout.Row = 3;
    shiftEdit.Layout.Column = [2 4]; 
    shiftEdit.Value = ''; 
    shiftEdit.Placeholder = 'Enter shift amount';

    % Key (Initially hidden)
    keyLabel = uilabel(gl);
    keyLabel.Text = 'Key:';
    keyLabel.Layout.Row = 3;
    keyLabel.Layout.Column = 1;
    keyLabel.HorizontalAlignment = 'right';
    keyLabel.Visible = 'off';

    keyEdit = uieditfield(gl, 'text');
    keyEdit.Layout.Row = 3;
    keyEdit.Layout.Column = [2 3]; 
    keyEdit.Visible = 'off';
    keyEdit.Placeholder = 'Enter key...';

    % Key Generation Buttons Container
    keyBtnGrid = uigridlayout(gl, [1, 2]); 
    keyBtnGrid.Layout.Row = 3;
    keyBtnGrid.Layout.Column = 4;
    keyBtnGrid.Padding = [0 0 0 0];
    keyBtnGrid.ColumnSpacing = 2;
    keyBtnGrid.Visible = 'off'; 

    % Standard Gen Button
    genKeyBtn = uibutton(keyBtnGrid, 'Text', 'Gen');
    genKeyBtn.Visible = 'off';
    genKeyBtn.BackgroundColor = [0.5, 0.5, 0.5];
    genKeyBtn.FontColor = [1 1 1];
    genKeyBtn.FontWeight = 'bold';

    % DH Key Button (Keyed Hash)
    genDHBtn = uibutton(keyBtnGrid, 'Text', 'DH');
    genDHBtn.Visible = 'off';
    genDHBtn.BackgroundColor = [0.6, 0.4, 0.8]; 
    genDHBtn.FontColor = [1 1 1];
    genDHBtn.FontWeight = 'bold';

    % Algo Dropdown (Row 4)
    algoLabel = uilabel(gl);
    algoLabel.Text = 'Algorithm:';
    algoLabel.Layout.Row = 4;
    algoLabel.Layout.Column = 1;
    algoLabel.HorizontalAlignment = 'right';
    algoLabel.Visible = 'off';

    algoDropdown = uidropdown(gl);
    algoDropdown.Items = {'SHA-1', 'SHA-384', 'SHA-512'};
    algoDropdown.Layout.Row = 4;
    algoDropdown.Layout.Column = [2 3];
    algoDropdown.Visible = 'off';

    % Nonce (Row 4)
    nonceLabel = uilabel(gl);
    nonceLabel.Text = 'Nonce:';
    nonceLabel.Layout.Row = 4;
    nonceLabel.Layout.Column = 1;
    nonceLabel.HorizontalAlignment = 'right';
    nonceLabel.Visible = 'off';

    nonceEdit = uieditfield(gl, 'text');
    nonceEdit.Layout.Row = 4;
    nonceEdit.Layout.Column = [2 3]; 
    nonceEdit.Visible = 'off';
    nonceEdit.Placeholder = 'Enter nonce (space separated uint8)...';

    genNonceBtn = uibutton(gl, 'Text', 'Gen Nonce');
    genNonceBtn.Layout.Row = 4;
    genNonceBtn.Layout.Column = 4;
    genNonceBtn.Visible = 'off';
    genNonceBtn.BackgroundColor = [0.5, 0.5, 0.5]; 
    genNonceBtn.FontColor = [1 1 1];
    genNonceBtn.FontWeight = 'bold';
    
    % RSA Inputs (Using Row 3/4 dynamically or reuse Key fields? 
    % RSA needs p and q. We can use KeyEdit for p and NonceEdit for q?
    % Or dedicated fields?
    % Let's reuse Key Label/Edit for 'p' and add 'q' input.
    % Actually, let's prompt for p and q via dialog to keep UI clean or add fields.
    % The user said "Take input and P and Q from user". 
    % Let's add specific fields for RSA that show up.
    
    rsaPLabel = uilabel(gl);
    rsaPLabel.Text = 'Prime p:';
    rsaPLabel.Layout.Row = 3;
    rsaPLabel.Layout.Column = 1;
    rsaPLabel.HorizontalAlignment = 'right';
    rsaPLabel.Visible = 'off';
    
    rsaPEdit = uieditfield(gl, 'numeric');
    rsaPEdit.Layout.Row = 3;
    rsaPEdit.Layout.Column = 2; 
    rsaPEdit.Visible = 'off';
    
    rsaQLabel = uilabel(gl);
    rsaQLabel.Text = 'Prime q:';
    rsaQLabel.Layout.Row = 3;
    rsaQLabel.Layout.Column = 3;
    rsaQLabel.HorizontalAlignment = 'right';
    rsaQLabel.Visible = 'off';
    
    rsaQEdit = uieditfield(gl, 'numeric');
    rsaQEdit.Layout.Row = 3;
    rsaQEdit.Layout.Column = 4; 
    rsaQEdit.Visible = 'off';

    % Input Text Area
    inputTextLabel = uilabel(gl);
    inputTextLabel.Text = 'Text:'; 
    inputTextLabel.Layout.Row = 5;
    inputTextLabel.Layout.Column = 1;
    inputTextLabel.VerticalAlignment = 'top';
    inputTextLabel.HorizontalAlignment = 'right'; 

    inputTextArea = uitextarea(gl);
    inputTextArea.Layout.Row = 5;
    inputTextArea.Layout.Column = [2 4];
    inputTextArea.Editable = 'on'; 
    inputTextArea.Placeholder = 'Enter text here or upload a file...';

    % Action Buttons
    encryptBtn = uibutton(gl, 'Text', 'Encrypt');
    encryptBtn.Layout.Row = 6;
    encryptBtn.Layout.Column = 2; 
    encryptBtn.BackgroundColor = [0.39, 0.83, 0.07]; 
    encryptBtn.FontColor = [1 1 1];
    encryptBtn.FontWeight = 'bold';
    
    decryptBtn = uibutton(gl, 'Text', 'Decrypt');
    decryptBtn.Layout.Row = 6;
    decryptBtn.Layout.Column = 3;
    decryptBtn.BackgroundColor = [0.85, 0.33, 0.10]; 
    decryptBtn.FontColor = [1 1 1];
    decryptBtn.FontWeight = 'bold';

    % Output Text Area
    outputTextLabel = uilabel(gl);
    outputTextLabel.Text = 'Output:';
    outputTextLabel.Layout.Row = 7;
    outputTextLabel.Layout.Column = 1;
    outputTextLabel.VerticalAlignment = 'top';
    outputTextLabel.HorizontalAlignment = 'right'; 

    outputTextArea = uitextarea(gl);
    outputTextArea.Layout.Row = 7;
    outputTextArea.Layout.Column = [2 4];
    outputTextArea.Editable = 'off';

    % Callbacks
    uploadBtn.ButtonPushedFcn = @(btn,event) uploadFile(fileNameLabel, inputTextArea, fig);
    
    % Update visibility callback to include new RSA widgets
    methodDropdown.ValueChangedFcn = @(dd,event) updateVisibility(dd, shiftLabel, shiftEdit, keyLabel, keyEdit, keyBtnGrid, genKeyBtn, genDHBtn, nonceLabel, nonceEdit, genNonceBtn, algoLabel, algoDropdown, rsaPLabel, rsaPEdit, rsaQLabel, rsaQEdit, encryptBtn, decryptBtn, gl);
    
    genKeyBtn.ButtonPushedFcn = @(btn,event) generateKey(keyEdit, inputTextArea, methodDropdown, fig);
    genDHBtn.ButtonPushedFcn = @(btn,event) generateKeyDH(keyEdit, fig);
    
    genNonceBtn.ButtonPushedFcn = @(btn,event) generateNonce(nonceEdit, fig);
    
    % Update processText to include RSA widgets
    encryptBtn.ButtonPushedFcn = @(btn,event) processText(inputTextArea, outputTextArea, methodDropdown, shiftEdit, keyEdit, nonceEdit, algoDropdown, rsaPEdit, rsaQEdit, 'encrypt', fig);
    decryptBtn.ButtonPushedFcn = @(btn,event) processText(inputTextArea, outputTextArea, methodDropdown, shiftEdit, keyEdit, nonceEdit, algoDropdown, rsaPEdit, rsaQEdit, 'decrypt', fig);
    
    inputTextArea.ValueChangedFcn = @(area, event) textChanged(fileNameLabel, fig);

    % Initialize visibility
    updateVisibility(methodDropdown, shiftLabel, shiftEdit, keyLabel, keyEdit, keyBtnGrid, genKeyBtn, genDHBtn, nonceLabel, nonceEdit, genNonceBtn, algoLabel, algoDropdown, rsaPLabel, rsaPEdit, rsaQLabel, rsaQEdit, encryptBtn, decryptBtn, gl);
end

function uploadFile(lbl, area, fig)
    [file, path] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select File');
    if isequal(file, 0)
        return;
    end
    fullPath = fullfile(path, file);
    lbl.Text = file;
    try
        % Read as binary bytes
        fid = fopen(fullPath, 'rb');
        raw_bytes = fread(fid, inf, '*uint8')';
        fclose(fid);
        
        % Store raw bytes in appdata for processing
        setappdata(fig, 'BinaryInputData', raw_bytes);
        
        % Determine if it's text or binary for display
        % Heuristic: if contains nulls or many control chars, treat as binary
        is_binary = any(raw_bytes == 0) || (sum(raw_bytes < 9 | (raw_bytes > 13 & raw_bytes < 32)) / length(raw_bytes) > 0.1);
        
        if is_binary
            % Display as Hex String
            hex_str = upper(reshape(dec2hex(raw_bytes)', 1, []));
            area.Value = hex_str; 
        else
            % It's text, convert to char
            text_content = char(raw_bytes);
            area.Value = text_content;
        end
    catch ME
        if exist('fid', 'var') && fid > 0
            fclose(fid);
        end
        uialert(fig, ['Error reading file: ' ME.message], 'File Error');
    end
end

function textChanged(lbl, fig)
    lbl.Text = 'No file selected';
    % Clear binary data if user edits text manually
    if isappdata(fig, 'BinaryInputData')
        rmappdata(fig, 'BinaryInputData');
    end
end

function updateVisibility(dd, sLbl, sEdit, kLbl, kEdit, kGrid, genBtn, dhBtn, nLbl, nEdit, nGenBtn, aLbl, aDD, pLbl, pEdit, qLbl, qEdit, encBtn, decBtn, gl)
    method = dd.Value;
    
    % Default visibility (hide all)
    sLbl.Visible = 'off'; sEdit.Visible = 'off';
    kLbl.Visible = 'off'; kEdit.Visible = 'off'; 
    kGrid.Visible = 'off'; genBtn.Visible = 'off'; dhBtn.Visible = 'off';
    
    nLbl.Visible = 'off'; nEdit.Visible = 'off'; nGenBtn.Visible = 'off';
    aLbl.Visible = 'off'; aDD.Visible = 'off';
    
    pLbl.Visible = 'off'; pEdit.Visible = 'off';
    qLbl.Visible = 'off'; qEdit.Visible = 'off';
    
    encBtn.Text = 'Encrypt';
    decBtn.Visible = 'on'; % Default show decrypt button

    % Reset Row 3/4 height to default
    gl.RowHeight{3} = 30; 
    gl.RowHeight{4} = 0; % Hide Row 4 by default

    kEdit.Editable = 'on'; 

    if strcmp(method, 'Caesar')
        sLbl.Visible = 'on';
        sEdit.Visible = 'on';
    elseif strcmp(method, 'One-Time Pad')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Generate';
    elseif strcmp(method, 'XOR - Bitwise stream cipher')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen Key';
        
        nLbl.Visible = 'on';
        nEdit.Visible = 'on';
        nGenBtn.Visible = 'on';
        gl.RowHeight{4} = 30; % Show Nonce row
    elseif strcmp(method, 'AES block cipher')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen AES-256';
    elseif strcmp(method, 'DES block cipher')
        kLbl.Visible = 'on'; 
        kEdit.Visible = 'on'; 
        kEdit.Editable = 'off'; 
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Update Key Matrix';
        gl.RowHeight{3} = 150; % Increase height for matrix display
    elseif strcmp(method, 'Keyed Hash')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen Key';
        dhBtn.Visible = 'on';
        
        aLbl.Visible = 'on';
        aDD.Visible = 'on';
        gl.RowHeight{4} = 30; % Show Algo row

        encBtn.Text = 'Generate Hash';
        decBtn.Visible = 'off'; 
    elseif strcmp(method, 'RSA')
        % Show P and Q inputs
        pLbl.Visible = 'on';
        pEdit.Visible = 'on';
        qLbl.Visible = 'on';
        qEdit.Visible = 'on';
        % Row 3 needs to accommodate 2 fields (P and Q)
        % We used Grid Layout column 1 for label, 2 for P, 3 for Q label, 4 for Q edit
        % The labels and edits are already positioned in Row 3.
        % Just ensuring kLbl/kEdit are hidden allows p/q to be seen if they overlap? 
        % Grid layout prevents overlap if cells are distinct. 
        % My layout:
        % sLbl, kLbl, pLbl share Row 3, Col 1
        % sEdit, kEdit share Row 3, Col [2 3] or [2 4]
        % pEdit is Row 3, Col 2. qLbl is Col 3. qEdit is Col 4.
        % So hiding sEdit/kEdit clears the space.
    end
end

function generateKey(kEdit, inArea, methodDD, fig)
    method = methodDD.Value;
    
    if strcmp(method, 'One-Time Pad')
        plaintext = inArea.Value;
        if iscell(plaintext)
            plaintext = strjoin(plaintext, newline);
        end
        
        if isempty(plaintext)
            uialert(fig, 'Please enter text or upload a file to generate a matching key.', 'Key Generation Error');
            return;
        end
        
        key = char(randi([65, 90], 1, length(plaintext)));
        kEdit.Value = key;
        
    elseif strcmp(method, 'AES block cipher')
        hexChars = '0123456789abcdef';
        key = hexChars(randi(16, 1, 64));
        kEdit.Value = key;
    elseif strcmp(method, 'DES block cipher')
        try
            addpath(genpath('week6'));
            key = keygen; 
            setappdata(fig, 'DESKey', key);
            kEdit.Value = mat2str(key);
            keyStr = num2str(key);
            msg = "DES Key Matrix Updated:" + newline + newline + join(string(keyStr), newline);
            uialert(fig, msg, 'Key Update');
        catch ME
            uialert(fig, ['Error generating DES key: ' ME.message], 'Key Gen Error');
        end
    elseif strcmp(method, 'XOR - Bitwise stream cipher')
        chars = ['A':'Z' 'a':'z' '0':'9'];
        key = chars(randi(length(chars), 1, 16));
        kEdit.Value = key;
    elseif strcmp(method, 'Keyed Hash')
        chars = ['A':'Z' 'a':'z' '0':'9'];
        key = chars(randi(length(chars), 1, 32)); 
        kEdit.Value = key;
    end
end

function generateKeyDH(kEdit, fig)
    try
        addpath(genpath('week8'));
        prompt = {'Enter a prime value for g:', 'Enter a prime value for p:'};
        dlgtitle = 'Diffie-Hellman Inputs';
        dims = [1 35];
        definput = {'', ''};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        
        if isempty(answer), return; end
        
        g_str = answer{1};
        p_str = answer{2};
        
        if isempty(g_str) || isempty(p_str)
            uialert(fig, 'Both g and p are required.', 'Input Error');
            return;
        end
        
        g = str2double(g_str);
        p = str2double(p_str);
        
        if isnan(g) || isnan(p)
            uialert(fig, 'g and p must be numeric.', 'Input Error');
            return;
        end
        
        if ~isprime(g) || ~isprime(p)
             uialert(fig, 'g and p must be prime numbers.', 'Input Error');
             return;
        end
        
        key = DHKey(g, p);
        if isnumeric(key), key = num2str(key); end
        kEdit.Value = key;
        uialert(fig, 'Key generated using Diffie-Hellman.', 'DH Key Gen');
        
    catch ME
        uialert(fig, ['Error generating DH key: ' ME.message], 'Key Gen Error');
    end
end

function generateNonce(nEdit, fig)
    nonce = uint8(randi([0 255], 1, 8));
    nEdit.Value = num2str(nonce);
end

function processText(inArea, outArea, methodDD, sEdit, kEdit, nEdit, aDD, pEdit, qEdit, mode, fig)
    hasBinaryData = isappdata(fig, 'BinaryInputData');
    if hasBinaryData
        text = getappdata(fig, 'BinaryInputData');
    else
        text = inArea.Value;
        if isempty(text)
            uialert(fig, 'Please enter text or upload a file.', 'Input Error');
            return; 
        end
        if iscell(text), text = strjoin(text, newline); end
    end

    method = methodDD.Value;
        
    try
        result = '';
        if strcmp(method, 'Caesar')
            if isnumeric(text), text = char(text); end
            shiftStr = sEdit.Value;
            shift = str2double(shiftStr);
            if isnan(shift), error('Please enter a valid numeric shift value.'); end
            result = caeser(text, shift, mode);
            
        elseif strcmp(method, 'One-Time Pad')
            if isnumeric(text), text = char(text); end
            key = kEdit.Value;
            if isempty(key), error('Please enter a key for One-Time Pad.'); end
            result = oneTimePad(text, key, mode);
            
        elseif strcmp(method, 'XOR - Bitwise stream cipher')
            key = kEdit.Value;
            nonceStr = nEdit.Value;
            if isempty(key), error('Please enter a key for XOR.'); end
            if isempty(nonceStr), error('Please enter a nonce for XOR.'); end

            if strcmpi(mode, 'decrypt') && ~hasBinaryData
                 try
                     clean_text = strrep(text, ' ', '');
                     text = uint8(hex2dec(reshape(clean_text, 2, [])')');
                 catch
                     error('Input for decryption must be a valid Hex string (or upload a binary file).');
                 end
            end

            out_uint8 = xorCipher(text, key, nonceStr, mode);

            is_printable = all((out_uint8 >= 32 & out_uint8 <= 126) | out_uint8 == 9 | out_uint8 == 10 | out_uint8 == 13);
            if is_printable
                result = char(out_uint8);
            else
                result = lower(reshape(dec2hex(out_uint8)', 1, []));
            end
            
        elseif strcmp(method, 'AES block cipher')
            if isnumeric(text), text = char(text); end
            key = kEdit.Value;
            if isempty(key) || length(key) ~= 64
                error('AES-256 key must be exactly 64 hex characters.');
            end
            
            if strcmpi(mode, 'decrypt')
                result = aesBlockCipher(text, key, mode);
                try
                    str_result = char(hex2dec(reshape(result, 2, [])')');
                    result = strtrim(str_result); 
                catch
                    error('Decryption failed to convert Hex to String.');
                end
            else
                result = aesBlockCipher(text, key, mode);
            end
            
        elseif strcmp(method, 'DES block cipher')
            if isnumeric(text), text = char(text); end
            key = getappdata(fig, 'DESKey');
            if isempty(key), error('No DES key found. Update Key Matrix first.'); end
            result = desBlockCipher(text, key, mode);
            
        elseif strcmp(method, 'Keyed Hash')
            if isnumeric(text), text = char(text); end
            key = kEdit.Value;
            if isempty(key), error('Please enter a key for HMAC.'); end
            result = HMAC(key, text, aDD.Value);
            
        elseif strcmp(method, 'RSA')
            % Get p and q
            p = pEdit.Value;
            q = qEdit.Value;
            
            if isempty(p) || isempty(q)
                error('Both p and q (prime numbers) are required for RSA.');
            end
            if ~isprime(p) || ~isprime(q)
                error('p and q must be prime numbers.');
            end
            
            % RSA expects numeric array (of chars) for encrypt, 
            % and numeric array (of cipher ints) for decrypt.
            
            % Ensure week8 is in path for rsaWrapper
            addpath(genpath('week8'));
            
            if strcmpi(mode, 'encrypt')
                if isnumeric(text), text = char(text); end
                % rsaWrapper encrypts char -> cipher int array
                cipher_ints = rsaWrapper(text, p, q, 'encrypt');
                
                % Convert cipher integers to string for display (space separated?)
                % Or Hex? rsaWrapper returns double array of encrypted values.
                % Values can be large (up to p*q).
                % Space separated decimals is safest for display/copy-paste.
                result = num2str(cipher_ints);
            else
                % Decrypt
                % Input is likely space separated string of integers if manual
                % Or numeric array if passed from somewhere?
                % If it's text string from input area:
                if ischar(text) || isstring(text)
                    try
                        cipher_ints = str2num(text);
                        if isempty(cipher_ints)
                            error('Input format error. RSA Decryption expects space-separated integers.');
                        end
                    catch
                         error('Invalid input format for RSA decryption.');
                    end
                else
                    % If binary data, it's uint8? RSA cipher texts are usually > 255.
                    % So binary file upload for RSA cipher text might need 
                    % special handling (e.g. reading int16/32/64).
                    % Current uploadFile reads *uint8.
                    % If user uploads a text file containing numbers, raw_bytes will be ASCII chars.
                    % We need to parse them.
                    cipher_ints = str2num(char(text));
                end
                
                decrypted_str = rsaWrapper(cipher_ints, p, q, 'decrypt');
                result = decrypted_str;
            end
        end
        
        outArea.Value = result;
    catch ME
        uialert(fig, ME.message, 'Processing Error');
    end
end
