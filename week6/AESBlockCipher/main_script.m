clc; clear;

key_hex = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';
% disp(['Key (hex): ', key_hex]);

% Plaintext input (English text)
plaintext_str = input('Enter plaintext: ', 's');
%disp(['Original plaintext: ', plaintext_str]);

%% ----------------------------
% PlainText conversion
%% ----------------------------
% Pad plaintext to 16 bytes if needed
% block_size = 16 sets this standard - Every piece of plaintext must be a multiple of 16 bytes.
block_size = 16;

% ensures always the minimum number of padding bytes to reach the next multiple of 16.
pad_len = mod(block_size - mod(length(plaintext_str), block_size), block_size);

% repmat(' ',1,pad_len) → creates a string of spaces (' ') with length pad_len.
% [plaintext_str ... ] → concatenates the padding to the end of the original plaintext.
% plaintext_padded is now length divisible by 16.
plaintext_padded = [plaintext_str repmat(' ',1,pad_len)];

% Convert plaintext to hex
plaintext_hex = lower(dec2hex(uint8(plaintext_padded))');
plaintext_hex = plaintext_hex(:)';  % row vector

%% ----------------------------
% Encryption
%% ----------------------------
ciphertext_hex = Cipher(key_hex, plaintext_hex);
disp('Ciphertext (hex):');
disp(ciphertext_hex);

%% ----------------------------
% Decryption
%% ----------------------------
recovered_hex = InvCipher(key_hex, ciphertext_hex);  
disp('Recovered plaintext (hex):');
disp(recovered_hex);

%% ----------------------------
% Verify correctness
%% ----------------------------
if strcmp(recovered_hex, plaintext_hex)
    disp('SUCCESS: Decrypted text matches original plaintext!');
else
    disp('ERROR: Decrypted text does NOT match original plaintext.');
end

% Test Case
% Text1 = 'affanali'
% Text2 = 'The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.';
% Text3 = 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.';