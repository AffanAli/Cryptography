function result = rsaWrapper(text, p, q, mode)
    % Initialize RSA keys
    [Pk, Phi, d, e] = intialize(p, q);
    
    if strcmpi(mode, 'encrypt')
        result = encrypt_rsa(text, Pk, e);
    elseif strcmpi(mode, 'decrypt')
        result = decrypt_rsa(text, Pk, d);
    else
        error('Invalid mode. Use "encrypt" or "decrypt".');
    end
end

function cipher = encrypt_rsa(plaintext, Pk, e)
    % Convert text to ASCII double
    M = double(plaintext);
    cipher = zeros(size(M));
    
    for j = 1:length(M)
        cipher(j) = crypt(M(j), Pk, e);
    end
end

function decrypted_text = decrypt_rsa(encryptedText, Pk, d)
    % encryptedText should be numeric array of cipher integers
    decrypted = zeros(size(encryptedText));
    
    for j = 1:length(encryptedText)
        decrypted(j) = crypt(encryptedText(j), Pk, d);
    end
    
    % Convert back to characters
    decrypted_text = char(decrypted);
end

