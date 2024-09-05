#!/bin/bash

# Define the target IP address
TARGET_IP="192.168.64.4"

# Define the output file
OUTPUT_FILE="scan_results.txt"

# Print start time
echo "Nmap scan started at $(date)" > $OUTPUT_FILE

# Perform TCP SYN Scan
echo -e "\n\nStarting TCP SYN Scan..." >> $OUTPUT_FILE
nmap -sS $TARGET_IP >> $OUTPUT_FILE

# Perform Service Version Detection
echo -e "\n\nStarting Service Version Detection..." >> $OUTPUT_FILE
nmap -sV $TARGET_IP >> $OUTPUT_FILE

# Perform OS Detection
echo -e "\n\nStarting OS Detection..." >> $OUTPUT_FILE
nmap -O $TARGET_IP >> $OUTPUT_FILE

# Perform Vulnerability Scan Using NSE
echo -e "\n\nStarting Vulnerability Scan Using NSE..." >> $OUTPUT_FILE
nmap --script vuln $TARGET_IP >> $OUTPUT_FILE

# Perform SSH Brute Force Script Scan
echo -e "\n\nStarting SSH Brute Force Script Scan..." >> $OUTPUT_FILE
nmap --script ssh-brute -p 22 $TARGET_IP >> $OUTPUT_FILE

# Print end time
echo -e "\n\nNmap scan completed at $(date)" >> $OUTPUT_FILE

# Notify completion
echo "Nmap scans have been completed. Results saved to $OUTPUT_FILE."

