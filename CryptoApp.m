function CryptoApp
    % --- Create UI Figure ---
    fig = uifigure('Name', 'Crypto App', 'Position', [100 100 700 600]); 
        
    % --- handles struct contains all UI components ---
    handles = layoutManager(fig);
    
    % --- Set Callbacks ---
    handles.uploadBtn.ButtonPushedFcn = @(btn,event) fileHandler(handles, fig);
    
    handles.methodDropdown.ValueChangedFcn = @(dd,event) handleVisibility(handles);
    
    handles.genKeyBtn.ButtonPushedFcn = @(btn,event) generateKey(handles, fig);
    handles.genDHBtn.ButtonPushedFcn = @(btn,event) generateKeyDH(handles, fig);
    handles.genNonceBtn.ButtonPushedFcn = @(btn,event) generateNonce(handles);
    handles.envGenIVBtn.ButtonPushedFcn = @(btn,event) generateEnvIV(handles);
    
    handles.encryptBtn.ButtonPushedFcn = @(btn,event) processText(handles, 'encrypt', fig);
    handles.decryptBtn.ButtonPushedFcn = @(btn,event) processText(handles, 'decrypt', fig);
    
    handles.inputTextArea.ValueChangedFcn = @(area, event) textChanged(handles, fig);

    % --- Initialize visibility ---
    handleVisibility(handles);
end

%% --- Helper Functions ---
function textChanged(handles, fig)
    handles.fileNameLabel.Text = 'No file selected';
    if isappdata(fig, 'BinaryInputData'), rmappdata(fig, 'BinaryInputData'); end
    if isappdata(fig, 'InputFilePath'), rmappdata(fig, 'InputFilePath'); end
    if isappdata(fig, 'IsBinaryInputFile'), rmappdata(fig, 'IsBinaryInputFile'); end
end

function generateKey(handles, fig)
    method = handles.methodDropdown.Value;
    
    if strcmp(method, 'One-Time Pad')
        plaintext = handles.inputTextArea.Value;
        if iscell(plaintext), plaintext = strjoin(plaintext, newline); end
        if isempty(plaintext)
            uialert(fig, 'Please enter text or upload a file to generate a matching key.', 'Key Gen Error');
            return;
        end
        handles.keyEdit.Value = char(randi([65, 90], 1, length(plaintext)));
    elseif strcmp(method, 'XOR - Bitwise stream cipher') || strcmp(method, 'Keyed Hash')
        chars = ['A':'Z' 'a':'z' '0':'9'];
        len = 16; 
        if strcmp(method, 'Keyed Hash'), len = 32; end
        handles.keyEdit.Value = chars(randi(length(chars), 1, len));
    elseif strcmp(method, 'AES block cipher')
        hexChars = '0123456789abcdef';
        handles.keyEdit.Value = hexChars(randi(16, 1, 64)); 
    elseif strcmp(method, 'DES block cipher')
        try
            key = keygen; 
            setappdata(fig, 'DESKey', key);
            handles.keyEdit.Value = mat2str(key);
        catch ME
            uialert(fig, ['Error generating DES key: ' ME.message], 'Key Gen Error');
        end
    end
end

function generateKeyDH(handles, fig)
    try
        prompt = {'Enter a prime value for g:', 'Enter a prime value for p:'};
        answer = inputdlg(prompt, 'Diffie-Hellman Inputs', [1 35], {'', ''});
        if isempty(answer), return; end
        g = str2double(answer{1}); p = str2double(answer{2});
        if isnan(g) || isnan(p) || ~isprime(g) || ~isprime(p)
            uialert(fig, 'g and p must be valid prime numbers.', 'Input Error');
            return;
        end
        key = DHKey(g, p);
        if isnumeric(key), key = num2str(key); end
        handles.keyEdit.Value = key;
        uialert(fig, 'Key generated using Diffie-Hellman.', 'DH Key Gen');
    catch ME
        uialert(fig, ['Error generating DH key: ' ME.message], 'Key Gen Error');
    end
end

function generateNonce(handles)
    handles.nonceEdit.Value = num2str(uint8(randi([0 255], 1, 8)));
end

function generateEnvIV(handles)
    handles.envIVEdit.Value = lower(reshape(dec2hex(randi([0 255], 1, 12))', 1, []));
end
