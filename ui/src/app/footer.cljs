(ns app.footer)

(defn footer []
  [:footer.footer
   [:div.content.has-text-centered
    [:p
     [:strong "Bulma"]
     " by "
     [:a {:href "https://jgthms.com"} "Jeremy Thomas"]
     ". The source code is licensed\n      "
     [:a {:href "http://opensource.org/licenses/mit-license.php"} "MIT"]
     ". The website content\n      is licensed "
     [:a
      {:href "http://creativecommons.org/licenses/by-nc-sa/4.0/"}
      "CC BY NC SA 4.0"]
     ".\n    "]]])