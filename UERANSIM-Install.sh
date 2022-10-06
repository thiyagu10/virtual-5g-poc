#################################################################################
#				UERANSIM Compilation and Installation Steps						#
#################################################################################
cd ~
git clone https://github.com/aligungr/UERANSIM
sudo apt update
sudo apt upgrade
sudo apt install make gcc g++ libsctp-dev lksctp-tools iproute2
sudo snap install cmake --classic
cd ~/UERANSIM
make
cat <<EOF | sudo tee /etc/systemd/system/nr-gnb01.service
[Unit]
Description = UERANSIM NR gNB, RF Over RLS-3.2
After = network.target

[Service]
WorkingDirectory=/root/UERANSIM/build
ExecStart=/root/UERANSIM/build/nr-gnb -c ../config/gnb01.yaml

[Install]
WantedBy = multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start nr-gnb01.service
sudo systemctl enable nr-gnb01.service
#################################################################################
