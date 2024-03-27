# fedora32-laptop-swaywm

My automation scripts for swaywm/i3wm on laptop fedora 32(workstation) enviroment.

## warning

You must be able to know what the script is doing or don't use it.

Take backups of everything you could imagine.

Be ready to reinstall your os in any situation.

## Requirements

 - fedora 32 workstaion(no rawhide/silverblue//spins)
   - user account and root privilege
 - A laptop

## Usage

Run the setup.sh script(take backups before this)

```
bash (i3/sway)_setup.sh
```

1. Os setups

You can opt out every settings by "n"

2. Packages installation

You can opt out some installation by "n"

Installation may take a while.

3. Post installation settings

Some post installation

3. reboot

The script asks you to reboot.

## after running the script

You're supposed to have your own dotfiles etc.

Have your life.

## Script flow

Here are whats going to happen with the script.

### Script flow 1 - OS relatd settings
First part is some os related settings.

1. validations
Script checks the following

 - Running the script as a user (not root)

 - The script aborts if you're not running the script on fedora 32.

2. OS related settins

1. Change hostname

If you want to change the hostname of the system, presss y and tell thew new name.

2. Gnome related settings

 - Turn of the animation (y/n)
 - event sound off (y/n)
 - disabling tracker (y/n)

3. adding repositories

 - RPM Fusion free (y/n)
 - RPM Fusion non-free (y/n)
 - Google Chrome repository (y/n)

4. I/O related settings

 - vm.swappines to 1 (y/n)
 - vm.dirty_ratio to 10 (y/n)
 - vm.dirty_background_ratio to 3 (y/n)
 - make /home/{user}/.cache/* on tmpfs (y/n)
 - touchpad scroll to natural-scrolling (y/n)

### Script flow 2 - Packages selection

As you go along with the script, you will be asked to choose the packages to install.

1. one of the vims (select by number)

2. Common desktop packages (select all or none)(y/n)

3. pythons (select all r none)(y/n)

4. terminal (select all r none)(y/n)

5. powerlines (select all r none)(y/n)

6. i3/sway wm related packages (select all r none)(y/n)

7. inkscape (y/n)

8. krita (y/n)

9. gimp (y/n)

10. RPM FUSION FREE packages

You will not be prompted to install those unless you had chosen to enable rpm fusion free repository.

vlc cmus

11. google-chrome-stable (y/n)

### Script flow 3 - Post installation

 - enable ufw (deny incoming,allow outgoing) (y/n)

   - (You need to have chosen y for this question to pop up)


### Script flow 4 - Reboot

You need to reboot for changes to be activated.

Reboot or not (y/n)

## UnInstall

In case anything doeesn't work, use uninstall_sway.sh

or reinstall your os again.



