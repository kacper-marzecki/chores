(ns app.footer)

(defn footer []
  [:footer.footer
   [:div.has-text-centered
    [:p
     [:strong "Chores "]
     [:a {:href "http://opensource.org/licenses/mit-license.php"} "MIT"]]]])