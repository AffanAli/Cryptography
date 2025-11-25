function result = oneTimePad(text, key, mode)
    % Ensure inputs are character arrays
    text = char(text);
    key = char(key);

    if length(key) < length(text)
        error('Key must be at least as long as the text.');
    end

    if strcmpi(mode, 'encrypt')
        result = encrypt(text, key);
    elseif strcmpi(mode, 'decrypt')
        result = decrypt(text, key);
    else
        error('Invalid mode. Use "encrypt" or "decrypt".');
    end
end

function encryptedText = encrypt(text, key)
    encryptedText = '';
    for i = 1:length(text)
        ch = text(i);
        k_char = key(i);
        
        shift = double(upper(k_char)) - 65;
        
        if isletter(ch)
            if isstrprop(ch, 'upper')
                val = double(ch) - 65;
                enc_val = mod(val + shift, 26);
                encryptedText = [encryptedText, char(enc_val + 65)];
            else
                val = double(ch) - 97;
                enc_val = mod(val + shift, 26);
                encryptedText = [encryptedText, char(enc_val + 97)];
            end
        else
            encryptedText = [encryptedText, ch];
        end
    end
end

function decryptedText = decrypt(text, key)
    decryptedText = '';
    for i = 1:length(text)
        ch = text(i);
        k_char = key(i);
        
        shift = double(upper(k_char)) - 65;
        
        if isletter(ch)
            if isstrprop(ch, 'upper')
                val = double(ch) - 65;
                dec_val = mod(val - shift, 26);
                decryptedText = [decryptedText, char(dec_val + 65)];
            else
                val = double(ch) - 97;
                dec_val = mod(val - shift, 26);
                decryptedText = [decryptedText, char(dec_val + 97)];
            end
        else
            decryptedText = [decryptedText, ch];
        end
    end
end
