(ns utils)

;; extracts target.value from event
(defn event-value [e] (.. e -target -value))


;; performs a function on event value
(defn with-event
  ([f] (fn [e] (with-event e f)))
  ([e f] (-> e event-value f)))