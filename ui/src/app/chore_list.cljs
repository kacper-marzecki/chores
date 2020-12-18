(ns app.chore-list
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [reagent.core :as r]
            [app.api :as api]
            [app.utils :as u]
            [cljs.core.async :refer [<!]]))

(defn chore-row 
  [{:keys [date login activity] :as chore}]
  [:tr 
   [:td date]
   [:td login]
   [:td activity]])

(defn chore-list
  []
  (let [state (r/atom [{:date "asd" :login "login" :activity "activity"}])]
    (fn []
      [:div.container
       [:table.table.is-fullwidth
        [:thead
         [:tr
          [:th "Date"]
          [:th "Login"]
          [:th "Chore"]]]
        [:tbody
         (map chore-row @state)]]])))