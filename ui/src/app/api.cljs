(ns app.api
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [cljs-http.client :as http]
            [cljs.core.async :refer [<!]]))

(defn kek [f]
  (go (let [response (<! (http/get "https://api.github.com/users"
                                   {:with-credentials? false
                                    :query-params {"since" 135}}))]
        ; (prn (:status response))
        ; (prn (map :login (:body response)))
        (f (:body response)))))

(defn is-logged-in []
  (go (let [response (<! (http/get "/api/loginCheck"))]
        (= (:status response) 200))))

(defn log-in [request]
  (go (let [response (<! (http/post "/api/auth/login" {:json-params request}))]
        (cond
          (contains? [200 201 204] (:status response)) {:ok (:body response)}
          :else {:error (:status response)}))))

(defn log-out []
  (go (let [response (<! (http/delete "/api/auth/logout" ))]
        (cond
          (contains? [200 201 204] (:status response)) {:ok (:body response)}
          :else {:error (:body response)}))))

(defn register [request]
  (go (let [response (<! (http/post "/api/auth/register" {:json-params request}))]
        (cond
          (contains? [200 201 204] (:status response)) {:ok (:body response)}
          :else {:error (:status response)}))))