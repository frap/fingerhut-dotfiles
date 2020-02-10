#!/usr/bin/env bb

(require '[clojure.java.shell :refer [sh]]
         '[clojure.string :as str])

(let [[username project branch] *command-line-args*
      branch (or branch "master")
      url (str "https://github.com/" username "/" project)
      sha (-> (sh "git" "ls-remote" url branch)
              :out
              (str/split #"\s")
              first)]
  {:git/url url
   :sha sha})
