clc;

%% ---------- INPUTS: text or file + timestamped payload ----------
plainTextInput = 'I am here too';
iv  = '4392367e62ef9aa706e3e801';  % 12-byte GCM nonce (hex)
aad = 'additional unencrypted instructions';

inputFilePath = 'plaintext_input.txt';

fileContent = fileread(inputFilePath);
fprintf('[FILE] Using existing input file: %s\n', inputFilePath);


% Build timestamped payload that will be encrypted by AES-GCM.
timestampStr = datestr(datetime('now'), 'yyyy-mm-dd HH:MM:SS');
payloadPlaintext = sprintf('[TS:%s]\n%s', timestampStr, fileContent);


%% ---------- KMS: init, rotate, policy ----------
if isfile('kms_store.mat')
    load('kms_store.mat','kms');
    fprintf('[KMS] Loaded existing KMS store\n');
else
    kms = KMS.init();
    fprintf('[KMS] New KMS store created\n');
end

%% KMS KEY VERSIONING (KEKs)
% Rotate to create a new KEK version (latest enabled KEK).
[kms] = KMS.rotate(kms);

save('kms_store.mat','kms');   % persist KMS

%% ---------- Generate DEK, encrypt with AES-GCM (inner layer) ----------
DEK = uint8(randi([0,255],[1,32]));            % 32B (AES-256)
key_hex = bytes_to_hex(DEK);                   % your GCM expects hex key
[C, T] = GCM_AE(key_hex, iv, payloadPlaintext, aad);      % C, T are hex strings

%% ---------- Wrap DEK with KMS (outer layer) ----------
[wrappedDEK, kms] = KMS.wrap(kms, DEK);

% Record which KEK version was used (latest enabled version).
enabledMask   = [kms.keks.enabled];
enabledKeks   = kms.keks(enabledMask);
enabledVers   = [enabledKeks.version];
kekVersionUsed = max(enabledVers);
fprintf('[KMS] Wrapped DEK with KEK version %d\n', kekVersionUsed);

save('kms_store.mat','kms');  % store updated versions


%% ---------- Print ENVELOPE (store this with the object) ----------
fprintf('\n--- ENVELOPE ---\n');
fprintf('IV (hex):         %s\n', lower(iv));
fprintf('Tag (hex):        %s\n', lower(T));
fprintf('Ciphertext bytes: %d\n', numel(C)/2);
fprintf('wrappedDEK bytes: %d\n', numel(wrappedDEK));
fprintf('CT preview:       %s ...\n', hex_preview(C, 32));

% Persistable envelope struct
envelope.iv          = iv;
envelope.tag         = T;
envelope.ciphertext  = C;
envelope.wrappedDEK  = wrappedDEK;
envelope.aad         = aad;
envelope.kekVersion  = kekVersionUsed;  % track KEK version used for wrapping
save('envelope.mat','envelope');
fprintf('[SAVE] Envelope stored in envelope.mat\n');
%% ----------DECRYPT ----------

fprintf('\n== DECRYPTION TEST ==\n');

% Load KMS + envelope (simulate separate decryption program)
load('kms_store.mat','kms');
load('envelope.mat','envelope');
% unwrap DEK using correct version
[DEK_u, kms] = KMS.unwrap(kms, envelope.wrappedDEK, envelope.kekVersion);
key_hex_u = bytes_to_hex(DEK_u);
% decrypt data using AES-GCM
[P, A] = GCM_AD(key_hex_u, envelope.iv, envelope.ciphertext, envelope.aad, envelope.tag);

% Reconstruct payload and extract timestamp + original data.
recoveredPayload = char(P);

% Expect first line to be [TS:YYYY-mm-dd HH:MM:SS]
newlineIdx = find(recoveredPayload == sprintf('\n'), 1);
if isempty(newlineIdx)
    headerLine = recoveredPayload;
    dataPart   = '';
else
    headerLine = recoveredPayload(1:newlineIdx-1);
    dataPart   = recoveredPayload(newlineIdx+1:end);
end

tsStart = strfind(headerLine, '[TS:');
tsEnd   = strfind(headerLine, ']');
if ~isempty(tsStart) && ~isempty(tsEnd) && tsEnd(1) > tsStart(1)
    encryptedTimestamp = headerLine(tsStart(1)+4:tsEnd(1)-1);
else
    encryptedTimestamp = '';
end

dataMatch = strcmp(dataPart, fileContent);

fprintf('Auth OK: %d | Data match: %d\n', A, dataMatch);
fprintf('Encrypted timestamp (from payload): %s\n', encryptedTimestamp);
fprintf('Recovered data preview: %s\n', safe_text_preview(dataPart,120));

fprintf('\n== DONE ==\n');


%% ----------------- helpers -----------------
function s = safe_text_preview(u8, n)
% Show first n bytes as readable text (non-printables → '.')
  n = min(n, numel(u8));
  b = char(u8(1:n));
  mask = (b < 32) | (b > 126);
  b(mask) = '.';
  s = string(b);
end

function hex = bytes_to_hex(u8)
  hex = reshape(dec2hex(u8).',1,[]);
end

function s = hex_preview(hexStr, nBytes)
  nChars = min(2*nBytes, numel(hexStr));
  s = lower(hexStr(1:nChars));
end