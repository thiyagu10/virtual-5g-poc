#################################################################################
#				UERANSIM Compilation and Installation Steps						#
#################################################################################
RANBLDDIR=$HOME/NRRANBLD

sudo apt update
sudo apt upgrade
sudo apt install make gcc g++ libsctp-dev lksctp-tools iproute2
sudo snap install cmake --classic

mkdir -pv $RANBLDDIR
cd $RANBLDDIR
git clone https://github.com/aligungr/UERANSIM
cd UERANSIM
make -j $(nproc)
if [ -f "${RANBLDDIR}/UERANSIM/build/nr-gnb" -a -f "${RANBLDDIR}/UERANSIM/build/nr-ue" ]
then
	echo "UERANSIM NR-gNB and NR-UE are compiled successfully"
else
	echo "Probelm in compiling the UERANSIM NR-gNB and NR-UE"
fi

cp ${RANBLDDIR}/UERANSIM/config/

cat <<EOF | sudo tee /etc/systemd/system/nr-gnb01.service
[Unit]
Description = UERANSIM NR gNB, RF Over RLS-3.2
After = network.target

[Service]
WorkingDirectory=${RANBLDDIR}/UERANSIM/build
ExecStart=${RANBLDDIR}/UERANSIM/build/nr-gnb -c ../config/gnb01.yaml

[Install]
WantedBy = multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start nr-gnb01.service
sudo systemctl enable nr-gnb01.service
#################################################################################
