function result = xorCipher(text, key, nonce, mode)
    % Validate and convert inputs
    % Ensure nonce is numeric array, not string representation
    if ischar(nonce) || isstring(nonce)
        nonce = str2num(nonce); 
    end
    nonce = uint8(nonce);

    % Ensure key is converted to uint8 properly if it's a string
    if ischar(key) || isstring(key)
        key_bytes = uint8(char(key));
    else
        key_bytes = uint8(key);
    end

    combined_key = [key_bytes nonce];
    scramble_key = KSA(combined_key);

    
    if strcmpi(mode, 'encrypt')
        result = encrypt(text, scramble_key);
    elseif strcmpi(mode, 'decrypt')
        result = decrypt(text, scramble_key);
    else
        error('Invalid mode. Use "encrypt" or "decrypt".');
    end
end

function ciphertext_hex = encrypt(plaintext_str, scramble_key)
    keystream = uint8(PRGA(scramble_key, length(plaintext_str)));

    % Ensure numeric
    if ischar(plaintext_str) || isstring(plaintext_str)
         plaintext_bytes = uint8(char(plaintext_str));
    else
         plaintext_bytes = uint8(plaintext_str);
    end
    ciphertext_hex = bitxor(keystream, plaintext_bytes);
end

function recovered_hex = decrypt(ciphertext_hex, scramble_key)
    keystream = uint8(PRGA(scramble_key, length(ciphertext_hex)));

    % Ensure numeric
    if ischar(ciphertext_hex) || isstring(ciphertext_hex)
         ciphertext_bytes = uint8(char(ciphertext_hex));
    else
         ciphertext_bytes = uint8(ciphertext_hex);
    end

    recovered_hex = bitxor(ciphertext_bytes, keystream);
end
