# Install babashka a clojure scripting env
is_redhat || return 1
e_install "Installing clojure"
curl -O https://download.clojure.org/install/linux-install-1.10.1.536.sh
chmod +x linux-install-1.10.1.536.sh
sudo ./linux-install-1.10.1.536.sh

e_install "Installing babashka - a graalvm based clj"
sudo su -c 'bash <(curl -s https://raw.githubusercontent.com/borkdude/babashka/master/install)'

e_install "Installing jet - json to edn converter"
sudo su -c 'bash <(curl -s https://raw.githubusercontent.com/borkdude/jet/master/install)'
