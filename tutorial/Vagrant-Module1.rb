## First things first! ##

# ---Shell---
# We need a folder for the project
# So... do it!

# Ok, now let's generate a template Vagrantfile
$ vagrant init

# Take a quick look into it!
#         _,--,            _
#    __,-'____| ___      /' |
#  /'   `\,--,/'   `\  /'   |
# (       )  (       )'
#  \_   _/'  `\_   _/
#    """        """

## Setting our next step up! ##

# Let's configure our box
#   .+------+
#  .' |    .'|
# +---+--+'  |
# |   |  |   |
# |  ,+--+---+
# |.'    | .'
# +------+'

# ---Vagrantfile---
# Defines the name of the box we are going to use
config.vm.box = "centos"

# Defines a place for Vagrant download your base box
config.vm.box_url = "http://172.40.0.86:3000/centos.box"

# Configures a private network
config.vm.network :private_network, ip: "192.168.10.10"

# Let's limit the amount of memory our box will take
# from the host
config.vm.provider :virtualbox do |vb|
  vb.customize ["modifyvm", :id, "--memory", "2048"]
end

# Finally let's make Vagrant install Chef
#       _______________________________ ____________________
#     .' In the kitchen,               | (_)   (_)    (_)   \
#   .'   no one can hear you ice cream.|  ____        ____   }
# .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,_|_(    `------'    )_/

config.vm.provision :shell, inline:
  "curl https://opscode.com/chef/install.sh | sudo bash"

# We need to make it idempotent
script = <<SCRIPT
  WHICH_STATUS_CODE=`which chef-solo; echo $?`
  if [[ ${WHICH_STATUS_CODE} == "1" ]]
  then
    curl https://opscode.com/chef/install.sh | sudo bash
  else
    echo "chef-solo already installed."
  fi
SCRIPT
config.vm.provision :shell, inline: script

# What about a try?
# The next snippet will make our box wake up!
# ---Shell---
vagrant box add centos PATH_TO_YOUR_BOX
$ vagrant up

# That's it for the Vagrant module!!
# Questions? Problems? Tell us now!

# Thank you!
# Let's play with Chef now!

#                   ¶¶¶¶¶¶¶¶¶¶¶¶
#                 ¶¶            ¶¶
#   ¶¶¶¶¶        ¶¶                ¶¶
#   ¶     ¶     ¶¶      ¶¶    ¶¶     ¶¶
#    ¶     ¶    ¶¶       ¶¶    ¶¶      ¶¶
#     ¶    ¶   ¶¶        ¶¶    ¶¶      ¶¶
#      ¶   ¶   ¶                         ¶¶
#    ¶¶¶¶¶¶¶¶¶¶¶¶                         ¶¶
#   ¶            ¶    ¶¶            ¶¶    ¶¶
#  ¶¶            ¶    ¶¶            ¶¶    ¶¶
# ¶¶   ¶¶¶¶¶¶¶¶¶¶¶      ¶¶        ¶¶     ¶¶
# ¶               ¶       ¶¶¶¶¶¶¶       ¶¶
# ¶¶              ¶                    ¶¶
#  ¶   ¶¶¶¶¶¶¶¶¶¶¶¶                   ¶¶
#  ¶¶           ¶  ¶¶                ¶¶
#  ¶¶¶¶¶¶¶¶¶¶¶¶    ¶¶            ¶¶
#                  ¶¶¶¶¶¶¶¶¶¶¶