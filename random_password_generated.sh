#!/bin/bash

# Prompt the user for the number of passwords to generate
read -p "Enter the number of random passwords to generate: " num_passwords

# Prompt for each character type
read -p "Do you want to include alphabets? (yes/no): " include_alphabets
read -p "Do you want to include numbers? (yes/no): " include_numbers
read -p "Do you want to include special characters? (yes/no): " include_special

# Prompt for the desired password length
read -p "Enter the length of each password: " password_length

# Validate input
if [[ -z "$num_passwords" || -z "$password_length" ]]; then
    echo "Please provide valid inputs for the number of passwords and password length. Exiting."
    exit 1
fi

# Define character sets
alphabets="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
numbers="0123456789"
special_characters="!@#$%^&*()-_=+[]{}|;:,.<>?/~"

# Build the character set based on user input (accepts yes, y, Y, or Enter for "yes")
char_set=""
if [[ "$include_alphabets" =~ ^([yY][eE][sS]|[yY]?)$ ]]; then
    char_set+="$alphabets"
fi
if [[ "$include_numbers" =~ ^([yY][eE][sS]|[yY]?)$ ]]; then
    char_set+="$numbers"
fi
if [[ "$include_special" =~ ^([yY][eE][sS]|[yY]?)$ ]]; then
    char_set+="$special_characters"
fi

# Check if any character set was selected
if [[ -z "$char_set" ]]; then
    echo "No character sets selected. Please run the script again and choose at least one option."
    exit 1
fi

# Output file
output_file="output.txt"

# Clear the output file if it exists
> "$output_file"

# Function to generate a random password
generate_password() {
    local length=$1
    local characters=$2
    # Generate the password by randomly picking characters from the given set
    echo "$(cat /dev/urandom | tr -dc "$characters" | fold -w "$length" | head -n 1)"
}

# Generate and save passwords to the output file
for (( i=1; i<=num_passwords; i++ ))
do
    password=$(generate_password "$password_length" "$char_set")
    echo "$password" >> "$output_file"
done

# Display the generated passwords
cat "$output_file"
echo "$num_passwords passwords have been generated and saved in $output_file."
