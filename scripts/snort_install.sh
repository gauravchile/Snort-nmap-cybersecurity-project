#!/bin/bash

# Set up environment
TARGET_IP="192.168.64.4"
SNORT_VERSION="2.9.16"
DAQ_VERSION="2.0.7"
DOWNLOAD_DIR="$HOME/snort_src"

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y gcc libpcre3-dev zlib1g-dev libluajit-5.1-dev \
    libpcap-dev openssl libssl-dev libnghttp2-dev libdumbnet-dev \
    bison flex libdnet autoconf libtool

# Create download directory
mkdir -p $DOWNLOAD_DIR && cd $DOWNLOAD_DIR

# Install DAQ
echo "Downloading and installing DAQ..."
wget https://www.snort.org/downloads/snort/daq-$DAQ_VERSION.tar.gz
tar -xvzf daq-$DAQ_VERSION.tar.gz
cd daq-$DAQ_VERSION
autoreconf -f -i
./configure && make && sudo make install

# Install Snort
cd $DOWNLOAD_DIR
echo "Downloading and installing Snort..."
wget https://www.snort.org/downloads/snort/snort-$SNORT_VERSION.tar.gz
tar -xvzf snort-$SNORT_VERSION.tar.gz
cd snort-$SNORT_VERSION
./configure --enable-sourcefire && make && sudo make install

# Update shared libraries
sudo ldconfig

# Create symbolic link
sudo ln -s /usr/local/bin/snort /usr/sbin/snort

# Set up user and folder structure
echo "Setting up user and folder structure..."
sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
sudo mkdir -p /etc/snort/rules /var/log/snort /usr/local/lib/snort_dynamicrules
sudo chmod -R 5775 /etc/snort /var/log/snort /usr/local/lib/snort_dynamicrules
sudo chown -R snort:snort /etc/snort /var/log/snort /usr/local/lib/snort_dynamicrules
sudo touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules /etc/snort/rules/local.rules

# Copy configuration files
sudo cp $DOWNLOAD_DIR/snort-$SNORT_VERSION/etc/*.conf* /etc/snort
sudo cp $DOWNLOAD_DIR/snort-$SNORT_VERSION/etc/*.map /etc/snort

# Download and install Snort rules
echo "Downloading and installing Snort rules..."
wget https://www.snort.org/rules/community -O ~/community.tar.gz
tar -xvf ~/community.tar.gz -C ~/
sudo cp ~/community-rules/* /etc/snort/rules
sudo sed -i 's/include $RULE_PATH/#include $RULE_PATH/' /etc/snort/snort.conf

# Configure snort.conf
echo "Configuring snort.conf..."
sudo sed -i 's/ipvar HOME_NET .*/ipvar HOME_NET '$TARGET_IP'/24/' /etc/snort/snort.conf
sudo sed -i 's/ipvar EXTERNAL_NET .*/ipvar EXTERNAL_NET !$HOME_NET/' /etc/snort/snort.conf
sudo sed -i 's|var RULE_PATH .*|var RULE_PATH /etc/snort/rules|' /etc/snort/snort.conf
sudo sed -i 's|var SO_RULE_PATH .*|var SO_RULE_PATH /etc/snort/so_rules|' /etc/snort/snort.conf
sudo sed -i 's|var PREPROC_RULE_PATH .*|var PREPROC_RULE_PATH /etc/snort/preproc_rules|' /etc/snort/snort.conf
sudo sed -i 's|var WHITE_LIST_PATH .*|var WHITE_LIST_PATH /etc/snort/rules|' /etc/snort/snort.conf
sudo sed -i 's|var BLACK_LIST_PATH .*|var BLACK_LIST_PATH /etc/snort/rules|' /etc/snort/snort.conf
sudo sed -i '/unified2/s/# //' /etc/snort/snort.conf
sudo sed -i '/include $RULE_PATH\/local.rules/s/# //' /etc/snort/snort.conf
sudo sed -i '$a include $RULE_PATH/community.rules' /etc/snort/snort.conf

# Validate Snort configuration
echo "Validating Snort configuration..."
sudo snort -T -c /etc/snort/snort.conf

# Create Snort service
echo "Creating Snort service..."
sudo bash -c 'cat <<EOL > /lib/systemd/system/snort.service
[Unit]
Description=Snort NIDS Daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/snort -q -u snort -g snort -c /etc/snort/snort.conf -i eth0

[Install]
WantedBy=multi-user.target
EOL'

# Reload systemd and start Snort service
sudo systemctl daemon-reload
sudo systemctl start snort
sudo systemctl enable snort

# Test Snort
echo "Testing Snort..."
sudo snort -A console -i eth0 -u snort -g snort -c /etc/snort/snort.conf

echo "Snort installation and setup complete."

