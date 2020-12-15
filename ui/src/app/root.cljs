(ns app.root
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [reagent.core :as r]
            [app.api :as api]
            [app.utils :as u]
            [cljs.core.async :refer [<!]]
            [app.chore-list :as chore-list]))



;; :page -> [:login :sign-up :chores-list]
(defonce app-state (r/atom {:logged-in false
                            :page :login}))

(defn update-is-logged-in [is-logged-in]
  (fn [state]
    (let [page (if is-logged-in :chores-list :login)]
      (assoc state :logged-in is-logged-in :page page))))

(defn reload-logged-in []
  (go (let [is-logged-in (<! (api/is-logged-in))]
        (swap! app-state (update-is-logged-in is-logged-in)))))

(defn change-page [page]
  (swap! app-state  #(assoc-in %1 [:page] page)))

(defn login []
  (let [form (r/atom {:login ""
                      :password ""})
        on-log-in (fn [_] (go (let [_ (<! (api/log-in @form))
                                    _ (<! (reload-logged-in))])))]
    (fn []
      [:section.section
       [:p (str @form)]
       [:div.container.has-text-centered
        [:div.columns.is-centered
         [:div.column.is-5.is-4-desktop
          [:form
           [:div.field
            [:div.control
             [:input.input {:placeholder "Login"
                            :type "text"
                            :on-change (u/update-form-at form [:login])}]]]
           [:div.field
            [:div.control
             [:input.input {:placeholder "Password"
                            :type "password"
                            :on-change (u/update-form-at form [:password])}]]]

           [:div.field.is-grouped
            [:div.control.is-expanded
             [:button.button.is-primary.is-outlined.is-fullwidth
              {:href "#" :on-click on-log-in}
              "Sign In!"]]]]]]]])))

(defn sign-up []
  (let [form (r/atom {:login ""
                      :password ""
                      :secret ""})]
    (fn []
      (let [on-sign-up (fn [_] (go (let [_ (<! (api/register @form))
                                         _ (<! (reload-logged-in))])))]

        [:section.section
         [:p (str @form)]
         [:div.container.has-text-centered
          [:div.columns.is-centered
           [:div.column.is-5.is-4-desktop
            [:form
             [:div.field
              [:div.control
               [:input.input {:placeholder "Login"
                              :type "text"
                              :on-change (u/update-form-at form [:login])}]]]
             [:div.field
              [:div.control
               [:input.input {:placeholder "Password"
                              :type "password"
                              :on-change (u/update-form-at form [:password])}]]]
             [:div.field
              [:div.control
               [:input.input {:placeholder "Secret"
                              :type "password"
                              :on-change (u/update-form-at form [:secret])}]]]
             [:div.field.is-grouped
              [:div.control.is-expanded
               [:button.button.is-primary.is-fullwidth {:on-click on-sign-up} "Sign up!"]]]]]]]]))))

(defn navbar []
  (fn []
    (let [state @app-state
          on-log-out (fn [_] (go (let [_ (<! (api/log-out))
                                       _ (<! (reload-logged-in))])))
          log-in-buttons  (if (:logged-in state)
                            [:div.buttons
                             [:a.button.is-primary {:href "#" :on-click on-log-out} "Log out"]]
                            [:div.buttons
                             [:a.button.is-light
                              {:href "#" :on-click #(change-page :login)}
                              "Log in"]
                             [:a.button.is-primary
                              {:href "#" :on-click #(change-page :sign-up)}
                              "Sign up"]])]
      [:nav.navbar
       [:div.container
        [:div.navbar-brand
         [:a.navbar-item {:href "#"} "CH"]
         [:a.navbar-burger
          {:aria-expanded "false", :aria-label "menu", :role "button"}
          [:span {:aria-hidden "true"}]
          [:span {:aria-hidden "true"}]
          [:span {:aria-hidden "true"}]]]
        [:div.navbar-menu
         [:div.navbar-start
          [:a.navbar-item {:href "#"} "Chores"]]
         [:div.navbar-end
          [:div.navbar-item
           log-in-buttons]]]]])))

(defn router []
  (fn []
    (let [state @app-state
          page (:page state)]
      (prn page)
      (case page
        :chores-list (chore-list/chore-list)
        :sign-up [sign-up]
        :login [login]))))

(defn root []
  (let [_ (reload-logged-in)]
    (fn [] [:<>
            [navbar]
            [router]
            [str @app-state]])))
