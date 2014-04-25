## Cooking! ##

# First we need something to help us manage our
# cookbooks.
# Librarian is a Gem that help us manage our cookbooks
# and their dependencies.
# Let's create a Gemfile by running:
# ---Shell---
bundle init

# Now insert the Berkshelf Gem into our Gemfile:
# ---Gemfile---
source "https://rubygems.org"

gem "librarian-chef"

# Now let's get it installed
# ---Shell---
bundle install --path vendor/bundle

#       __________________
#     .-'  \ _.-''-._ /  '-.
#   .-/\   .'.      .'.   /\-.
#  _'/  \.'   '.  .'   './  \'_
# :======:======::======:======:
#  '. '.  \     ''     /  .' .'
#    '. .  \   :  :   /  . .'
#      '.'  \  '  '  /  '.'
#        ':  \:    :/  :'
#          '. \    / .'
#            '.\  /.'
#              '\/'

## Getting Librarian ready ##

# Let's create our Librarian configuration file by
# running:
# ---Shell---
librarian-chef init

# It will generate a template file named Cheffile in
# your root. Let's configure it properly:
# ---Cheffile---
#!/usr/bin/env ruby

site 'http://community.opscode.com/api/v1'

cookbook 'docker', github: 'akshaykarle/docker-cookbook'
# The cookbook yum-epel adds a new repository for
# yum.
# Let's install it
librarian-chef install

#                                 .-. _...
#                                /   '    `.--.
#                               (    \.    |   |
#                                `.    )  .'  /
#                                  `.  |     /'
#                                   |  '    /'
#                                   |_______|
#                                  /wWw    -.
#                               .-'  o-   |  )
#                              (__         _/
#                  _..--.        `/\\\    .'
#                .'   .- `|       (o)    .'|
#               (  .-'   /         \     ' |
#                \    \  |        (____.' _|
#                 `.   \ |\          /   . /`-,
#            '      `.  .'\\       .'`--' /    \
#           (          --' \\      /     (  -_  `.
#       _,...).             \\    | Da    `._ \   `
#  _.-''  / / (  ``-._      (_/)  /Chef      | '.  `.
#.' / /  / .--.) ==== `.     (_ \|           |   `. `.
#| `./  / (    )/==== / `>     \,'      '-   |    _\  |
#`.  `./  /`--'/  /  /,-'|      |         `. |   (/((_)
# |     `-../.__,,.--'   /     |  .        |  '   /
#  \                    /      '.         ,'  / \/
#   `.                ,'         `-------'   /// \
#     `._          _,'                       \///
#        `--....--'                           \/

# That's it? Yes! That's it!
# What about execute the provision in our box?
# ---Shell---
# If your vagrant box is up:
vagrant provision

# This fails as the cookbooks directory is not shared inside vagrant
# To share the cookbooks with your vagrant box and provision it, restart your box with the provision parameter:
vagrant reload --provision

# Yes, our docker cookbook has Yum as a dependency,
# So we don't need it anymore.
# Let's replace it as well in our Vagrant:
# ---Vagrantfile---
config.vm.provision :chef_solo do |chef|
  chef.add_recipe "docker"
end

# Nice, let's install our new cookbooks and provision
# our box again!
# ---Shell---
librarian-chef install
vagrant provision

# Ok, that's it for now!
# Thank you and let's go to our largest and last
# module.
#             __   __
#            __ \ / __
#           /  \ | /  \
#               \|/
#          _,.---v---._
# /\__/\  /            \
# \_  _/ /              \
#   \ \_|           @ __|
#    \                \_
#     \     ,__/       /
#   ~~~`~~~~~~~~~~~~~~/~~~~
