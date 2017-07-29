Vagrant.configure("2") do |config|
  config.vm.define "fed" do |fed|
    # fed.vm.box = "boxcutter/fedora25"
    fed.vm.box = "jhcook/fedora26"
    # fed.vm.box_version = "3.0.5"
    fed.vm.hostname = "fed-26"
    fed.vm.provider :virtualbox do |vb|
      vb.gui = true
      vb.name = "fed-26"
    end
  end
#  config.vm.define "arch" do |arch|
#    # arch.vm.box = "dreamscapes/archlinux"
#    arch.vm.box = "EarlAbides/archlinux64"
#    arch.vm.hostname = "arch"
#    arch.vm.provider :virtualbox do |vb|
#      vb.gui = true
#      vb.name = "arch"
#    end
#    arch.vm.synced_folder ".", "/home/vagrant/workspace/dotfiles"
#  end
end
