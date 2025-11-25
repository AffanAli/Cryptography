clc; clear;
%Encryption and Decryption exactly the same, simply swap the plaintext
% for the ciphertext with the same key

key = 'KAREEM';
%plaintext = 'Mission Accomplished';

plaintext = input('IN:',"s");
P = uint8(char(plaintext));

% ---------------------------
% Generate random nonce
% ---------------------------
nonce_length = 8; % choose 8, 12, or 16 bytes
nonce = uint8(randi([0 255], 1, nonce_length));
%disp('nonce (decimal):');
%disp(nonce);

% ---------------------------
% Combine key + nonce for KSA
% ---------------------------
combined_key = [uint8(key) nonce];      % key concatenated with nonce

% ---------------------------
% Generate keystream using KSA + PRGA
% ---------------------------
scramble_key = KSA(combined_key);
keystream = uint8(PRGA(scramble_key, length(P)));

%disp('Keystream (decimal):');
%disp(keystream);
 
% ---------------------------
% Encrypt plaintext
% ---------------------------
encrypt = bitxor(keystream, P);
res_in_unicode = char(encrypt);
disp(['Encrypted Text:', res_in_unicode])

% ---------------------------
% Decrypt ciphertext
% ---------------------------
decrypted = bitxor(encrypt, keystream);
disp(['Decrypted Text:', decrypted]);


%% ----------------------------
% Verify correctness
%% ----------------------------
if strcmp(char(decrypted), plaintext)
    disp('SUCCESS: Decrypted text matches original plaintext!');
else
    disp('ERROR: Decrypted text does NOT match original plaintext.');
end
