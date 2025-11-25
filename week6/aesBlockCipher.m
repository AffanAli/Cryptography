function result = aesBlockCipher(text, key, mode)
    if strcmpi(mode, 'encrypt')
        result = encrypt(text, key);
    elseif strcmpi(mode, 'decrypt')
        result = decrypt(text, key);
    else
        error('Invalid mode. Use "encrypt" or "decrypt".');
    end
end

function ciphertext_hex = encrypt(plaintext_str, key_hex)
    block_size = 16;
    pad_len = mod(block_size - mod(length(plaintext_str), block_size), block_size);
    plaintext_padded = [plaintext_str repmat(' ',1,pad_len)];

    plaintext_hex = lower(dec2hex(uint8(plaintext_padded))');
    plaintext_hex = plaintext_hex(:)';  % row vector

    ciphertext_hex = Cipher(key_hex, plaintext_hex);
end

function recovered_hex = decrypt(ciphertext_hex, key_hex)
    recovered_hex = InvCipher(key_hex, ciphertext_hex);
end
