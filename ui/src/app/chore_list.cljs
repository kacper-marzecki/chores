(ns app.chore-list
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [reagent.core :as r]
            [app.api :as api]
            [app.utils :as u]
            [cljs.core.async :refer [<!]]))

(defn chore-list []
  (let [state (r/atom [])]
    (fn []
      [:p "kek"])))