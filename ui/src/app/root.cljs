(ns app.root
  (:require [reagent.core :as r]))

(defn click-counter [click-count]
  [:div
   "The atom " [:code "click-count"] " has value: "
   @click-count ". "
   [:input {:type "button" :value "Click me!"
            :on-click #(swap! click-count inc)}]])

(defonce click-count (r/atom 0))

(defn kek [a]
  (let [double (* 2 a)]
    double))


(defn login []
  [:section.section
   [:div.container.has-text-centered
    [:div.columns.is-centered
     [:div.column.is-5.is-4-desktop
      [:form
       [:div.field
        [:div.control
         [:input.input {:placeholder "Email", :type "email"}]]]
       [:div.field
        [:div.control
         [:input.input {:placeholder "Name", :type "text"}]]]
       [:div.field
        [:div.control
         [:input.input {:placeholder "Password", :type "password"}]]]
       [:div.field.is-grouped
        [:div.control.is-expanded
         [:button.button.is-primary.is-outlined.is-fullwidth
          "Sign In!"]]
        [:div.control.is-expanded
         [:button.button.is-primary.is-fullwidth "Sign up!"]]]
       [:p
        "By signing in you agree with the "
        [:a {:href "#"} "Terms and Conditions"]
        " and "
        [:a {:href "#"} "Privacy Policy"]
        "."]]]]]])
(defn navbar []
  [:nav.navbar
   [:div.container
    [:div.navbar-brand
     [:a.navbar-item {:href "#"} "Pied Piper"]
     [:a.navbar-burger
      {:aria-expanded "false", :aria-label "menu", :role "button"}
      [:span {:aria-hidden "true"}]
      [:span {:aria-hidden "true"}]
      [:span {:aria-hidden "true"}]]]
    [:div.navbar-menu
     [:div.navbar-start
      [:a.navbar-item {:href "#"} "Features"]
      [:a.navbar-item {:href "#"} "Enterprise"]
      [:a.navbar-item {:href "#"} "Support"]
      [:div.navbar-item.has-dropdown.is-hoverable
       [:a.navbar-link "ICO"]
       [:div.navbar-dropdown
        [:a.navbar-item.navbar-item-dropdown {:href "#"} "Whitepaper"]
        [:a.navbar-item.navbar-item-dropdown {:href "#"} "Token"]]]]
     [:div.navbar-end
      [:div.navbar-item
       [:div.buttons
        [:a.button.is-light {:href "#"} "Log in"]
        [:a.button.is-primary {:href "#"} "Sign up"]]]]]]])
(defn root []
  [:<>
   (navbar)
   (login)
   [:div {:class "field"}
    [:div {:class "control"}
     [:input {:class "input is-primary", :type "text", :placeholder "Primary input"}]]]
   [:div {:class "field"}
    [:div {:class "control"}
     [:input {:class "input is-info", :type "text", :placeholder "Info input"}]]]
   [:div {:class "field"}
    [:div {:class "control"}
     [:input {:class "input is-success", :type "text", :placeholder "Success input"}]]]
   [:div {:class "field"}
    [:div {:class "control"}
     [:input {:class "input is-warning", :type "text", :placeholder "Warning input"}]]]
   [:div {:class "field"}
    [:div {:class "control"}
     [:input {:class "input is-danger", :type "text", :placeholder "Danger input"}]]]
   [click-counter click-count]])
