# Atea paths
prepend_to_path_if_exists "/home/atearoot/.sqlscripts"
prepend_to_path_if_exists "/home/atearoot/Dev/scripts"
#-------- Check if rust installed -------
prepend_to_path_if_exists "$HOME/.cargo/bin"
#-- if doom emacs add bin/doom  ---------
prepend_to_path_if_exists "$HOME/.emacs.d/bin"

