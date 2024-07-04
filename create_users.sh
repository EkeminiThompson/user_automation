#!/bin/bash

# Check if file argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

INPUT_FILE=$1
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Create the log and password files if they don't exist
touch "$LOG_FILE"
mkdir -p /var/secure
touch "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"

# Function to generate random password
generate_password() {
    tr -dc 'A-Za-z0-9!@#$%&*' < /dev/urandom | head -c 12
}

# Function to create groups if they do not exist
create_groups() {
    local groups=("$@")
    for group in "${groups[@]}"; do
        if ! getent group "$group" &>/dev/null; then
            groupadd "$group"
            echo "Created group: $group" | tee -a "$LOG_FILE"
        fi
    done
}

# Read input file line by line, ignoring whitespace
while IFS=';' read -r username groups; do
    # Trim whitespace
    username=$(echo "$username" | tr -d '[:space:]')
    groups=$(echo "$groups" | tr -d '[:space:]')

    # Check if user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists." | tee -a "$LOG_FILE"
        continue
    fi

    # Create user and personal group
    useradd -m -s /bin/bash "$username"
    if [ $? -eq 0 ]; then
        echo "User $username created successfully." | tee -a "$LOG_FILE"
        mkdir -p "/home/$username"
        chown "$username:$username" "/home/$username"
        chmod 755 "/home/$username"
    else
        echo "Failed to create user $username." | tee -a "$LOG_FILE"
        continue
    fi

    # Create specified groups if they do not exist
    IFS=',' read -ra GROUP_ARRAY <<< "$groups"
    create_groups "${GROUP_ARRAY[@]}"

    # Assign user to groups
    for group in "${GROUP_ARRAY[@]}"; do
        usermod -aG "$group" "$username"
        echo "Added $username to group $group." | tee -a "$LOG_FILE"
    done

    # Generate and store password
    password=$(generate_password)
    echo "$username,$password" >> "$PASSWORD_FILE"
    echo "Generated password for $username and stored in $PASSWORD_FILE" | tee -a "$LOG_FILE"
    echo "$username:$password" | chpasswd

done < <(grep -v '^[[:space:]]*$' "$INPUT_FILE")

echo "User creation process completed." | tee -a "$LOG_FILE"
