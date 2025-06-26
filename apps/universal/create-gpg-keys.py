#!/bin/bash

# Script to generate a new GPG key and export the public and private keys.

# --- Configuration ---

# You can pre-configure these variables if you wish to run the script with no user input.
# LEAVE BLANK TO BE PROMPTED
NAME=""
EMAIL=""
COMMENT=""
PASSPHRASE=""

# Key generation parameters (sensible defaults)
KEY_TYPE="RSA"
KEY_LENGTH="4096"
SUBKEY_TYPE="RSA"
SUBKEY_LENGTH="4096"
EXPIRATION="0" # 0 means the key does not expire

# --- Script Logic ---

# Function to display errors and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Prompt for user details if not pre-configured
if [ -z "$NAME" ]; then
    read -p "Enter your full name: " NAME
fi

if [ -z "$EMAIL" ]; then
    read -p "Enter your email address: " EMAIL
fi

if [ -z "$COMMENT" ]; then
    read -p "Enter a comment (e.g., work, personal): " COMMENT
fi

if [ -z "$PASSPHRASE" ]; then
    read -s -p "Enter a strong passphrase for your new key: " PASSPHRASE
    echo
fi

# Check for gpg command
command -v gpg >/dev/null 2>&1 || error_exit "gpg command not found. Please install GnuPG."

# Create a temporary file for key generation parameters
param_file=$(mktemp)
trap 'rm -f "$param_file"' EXIT

# Populate the parameter file for unattended key generation
cat > "$param_file" <<EOF
%echo Generating a new GPG key
Key-Type: $KEY_TYPE
Key-Length: $KEY_LENGTH
Subkey-Type: $SUBKEY_TYPE
Subkey-Length: $SUBKEY_LENGTH
Name-Real: $NAME
Name-Email: $EMAIL
Name-Comment: $COMMENT
Expire-Date: $EXPIRATION
Passphrase: $PASSPHRASE
%commit
%echo done
EOF

# Generate the key using the parameter file
gpg --batch --gen-key "$param_file"

# Get the fingerprint of the newly created key
FINGERPRINT=$(gpg --list-secret-keys --with-colons "$EMAIL" | awk -F: '$1 == "fpr" {print $10; exit}')

if [ -z "$FINGERPRINT" ]; then
    error_exit "Failed to retrieve the fingerprint of the newly generated key."
fi

echo "Key successfully generated with fingerprint: $FINGERPRINT"

# Define output filenames
PUBLIC_KEY_FILE="${EMAIL}_public_key.asc"
PRIVATE_KEY_FILE="${EMAIL}_private_key.asc"

# Export the public key
echo "Exporting public key to $PUBLIC_KEY_FILE..."
gpg --armor --export "$FINGERPRINT" > "$PUBLIC_KEY_FILE"

# Export the private key
echo "Exporting private key to $PRIVATE_KEY_FILE..."
gpg --armor --export-secret-key "$FINGERPRINT" > "$PRIVATE_KEY_FILE"

echo -e "\n--- All Done! ---"
echo "Your public key has been saved to: $PUBLIC_KEY_FILE"
echo "Your private key has been saved to: $PRIVATE_KEY_FILE"
echo "Keep your private key secure and do not share it with anyone."
