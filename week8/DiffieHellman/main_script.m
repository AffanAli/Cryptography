clc; clear;

DHKey;  % run your existing DHKey.m

% Convert shared key to HMAC key
shared_key = ha;

% Compute HMAC for a message
message = 'This is a test message for DH+HMAC';

encrypted = HMAC(shared_key, message, 'SHA-256');

disp(['Message: ' message]);
disp(['HMAC Encrypted: ' encrypted]);

% -------------------------------
% Verification
% -------------------------------
decrypted = HMAC(shared_key, message, 'SHA-256');

if strcmpi(encrypted, decrypted)
    disp('Authentication SUCCESS');
else
    disp('Authentication FAILED');
end
