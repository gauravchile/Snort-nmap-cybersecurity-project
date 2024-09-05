# Network Intrusion Detection and Vulnerability Scanning Using Snort and Nmap

## Project Overview
This project demonstrates the setup of a basic network security environment where Snort is used as an Intrusion Detection System (IDS) to monitor network traffic for suspicious activities, and Nmap is employed to perform network scanning to identify open ports, services, and potential vulnerabilities.

## Project Structure
- **network_topology/**: Contains the network diagram used in the project.
- **snort/**: Includes Snort configuration files, custom rules, and logs.
- **nmap/**: Contains Nmap scan results and any scripts used for scanning.
- **documentation/**: Final project report, incident response plan, and other documentation.
- **scripts/**: Bash scripts to automate Snort setup and Nmap scanning.

## How to Set Up the Project

### Prerequisites
- VirtualBox or VMware to create VMs.
- Ubuntu/Debian-based Linux distribution for Snort installation.
- Basic knowledge of Linux, networking, and security tools.

### Step-by-Step Guide

1. **Clone the Repository**
    ```bash
    git clone https://github.com/gauravchile/snort-nmap-cybersecurity-project.git
    cd snort-nmap-cybersecurity-project
    ```

2. **Set Up the Network Topology**
   - Refer to the `network_diagram.png` in the `network_topology/` folder.
   - Set up VMs as per the diagram with static IP addresses.

3. **Install and Configure Snort**
   - Use the `setup_snort.sh` script in the `scripts/` folder to install and configure Snort.
   - Customize the `snort.conf` file located in the `snort/` folder.

4. **Run Nmap Scans**
   - Use the `run_nmap.sh` script to perform network scans.
   - Analyze the scan results stored in the `nmap/scan_results.txt` file.

5. **Simulate Attacks and Monitor Snort Alerts**
   - Perform different types of network attacks (e.g., port scanning, DoS attacks).
   - Check Snort logs in the `snort/logs/` folder for alerts.

## Documentation
- The project report and incident response plan can be found in the `documentation/` folder.

## Future Work
- Suggestions for extending the project, such as integrating with a SIEM system for centralized monitoring.

## License
This project is licensed under the [MIT License](LICENSE).

