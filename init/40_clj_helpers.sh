# Install babashka a clojure scripting env
e_install "Installing babashka - a graalvm based clj"
sudo su -c 'bash <(curl -s https://raw.githubusercontent.com/borkdude/babashka/master/install)'

e_install "Installing jet - json to edn converter"
sudo su -c 'bash <(curl -s https://raw.githubusercontent.com/borkdude/jet/master/install)'
