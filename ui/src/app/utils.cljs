(ns app.utils)

;; extracts target.value from event
(defn event-value [e] (.. e -target -value))


;; performs a function on event value
(defn with-event
  ([f] (fn [e] (with-event e f)))
  ([e f] (-> e event-value f)))

(defn update-form-at [form at]
  (fn [e]
    (let [v (event-value e)]
      (swap! form #(assoc-in %1 at v)))))

(defn prevent-default [e]
  (.preventDefault e))

