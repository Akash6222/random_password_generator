#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No color

# Title
echo -e "${BOLD}${CYAN}=== Random Password Generator ===${NC}"

# Prompt the user for the number of passwords to generate
echo -e "${BLUE}Enter the number of random passwords to generate:${NC}"
read -p " " num_passwords

# Prompt for each character type
echo -e "${BLUE}Do you want to include alphabets? (yes/no):${NC}"
read -p " " include_alphabets
echo -e "${BLUE}Do you want to include numbers? (yes/no):${NC}"
read -p " " include_numbers
echo -e "${BLUE}Do you want to include special characters? (yes/no):${NC}"
read -p " " include_special

# Prompt for the desired password length
echo -e "${BLUE}Enter the length of each password:${NC}"
read -p "> " password_length

# Validate input
if [[ -z "$num_passwords" || -z "$password_length" ]]; then
    echo -e "${RED}Error: Please provide valid inputs for the number of passwords and password length.${NC}"
    exit 1
fi

# Define character sets
alphabets="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
numbers="0123456789"
special_characters="!@#$%^&*()-_=+[]{}|;:,.<>?/~"

# Build the character set based on user input
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
    echo -e "${RED}Error: No character sets selected. Please run the script again and choose at least one option.${NC}"
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
echo -e "${CYAN}\nGenerating passwords...${NC}"
for (( i=1; i<=num_passwords; i++ ))
do
    password=$(generate_password "$password_length" "$char_set")
    echo "$password" >> "$output_file"
done

# Display the generated passwords with a professional format
echo -e "\n${GREEN}Successfully generated $num_passwords passwords!${NC}"
echo -e "${YELLOW}Passwords saved in:${NC} ${BOLD}$output_file${NC}"

echo -e "\n${CYAN}=== Generated Passwords ===${NC}"
cat "$output_file" | nl -w 2 -s '. ' # Number each password for easy readability
echo -e "${CYAN}===========================${NC}"
