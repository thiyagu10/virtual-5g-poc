#################################################################################
#				OPEN5GS-2.4.8 Compilation and Installation Steps				#
#################################################################################
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:open5gs/latest
sudo apt update
sudo apt install open5gs		### on Control Plane Only. Disable UPF
sudo apt install open5gs-upf	### on Data Plane Only.
#################################################################################
