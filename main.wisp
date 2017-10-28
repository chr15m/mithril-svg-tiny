(defn partial [f & args]
  (let [args-stored (.slice args)]
    (fn [& args-new]
      (let [args-all (.concat [] args-stored args-new)]
        (apply f args-all)))))

(def view-box (str (* (/ (.-innerWidth window) 2) -1) " " (* (/ (.-innerHeight window) 2) -1) " " (.-innerWidth window) " " (.-innerHeight window)))
(def ww (.-innerWidth window))
(def wh (.-innerHeight window))

(def entities [])

(defn now []
  (.getTime (Date.)))

(defn siney [rx ry mx my s]
  (let [t (now)]
    {:x (* (Math.sin (* (/ t 1000) rx)) mx)
     :y (* (Math.cos (* (/ t 1000) ry)) my)}))

(set! entities
      [{:draw (fn [s] (m :rect {:x -0.1 :y -0.1 :width 0.2 :height 0.2 :fill (if (:on s) "#000" "#888") :onclick (fn [ev] (set! (:on s) (not (:on s))))}))
        :state {}}
       {:draw (fn [s] (m :circle {:cx (:x s) :cy (:y s) :r 0.03 :fill "#596"}))
        :update (partial siney 2 3 0.25 0.25)}
       {:draw (fn [s] (m :rect {:x (- (:x s) 0.04) :y (- (:y s) 0.02) :width 0.08 :height 0.04 :fill "#66f"}))
        :update (partial siney 2.5 2 0.3 0.45)
        :state {:x 0 :y 0}}
       {:draw (fn [s] (m :circle {:cx (:x s) :cy (:y s) :r 0.025 :fill "#965"}))
        :update (partial siney 2.3 4.5 0.4 0.1)}])

(defn view []
  (m :svg {:width ww :height wh :viewBox "-0.5 -0.5 1 1" :xmlns "http://www.w3.org/2000/svg"}
    (m :g (.map entities (fn [e i] ((:draw e) (:state e)))))))

(defn mainloop []
  (.map entities (fn [e i] (if (:update e) (set! (:state e) ((:update e) (:state e))))))
  (m.redraw))

(m.mount (document.getElementById "app") {"view" view})
(setInterval mainloop 16)
