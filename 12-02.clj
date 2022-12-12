;; yes, maybe the code is horrible, but that's ok, you know why? 
;; because we need to accept ourselves, he accepted being ugly, 
;; and that's a good thing

(ns aoc.core
  (:gen-class)
  (:require [clojure.string :as str]
            [clojure.set :as set]))

(defn read-file [file-name]
  (->>
   file-name
   slurp
   str/split-lines
   (mapv #(mapv int %))))

(defn parse [hs]
  (let [pos (->> 
             (map #(case (get-in hs %) 
                     83 {:start %} 
                     69 {:end %} nil) 
                  (for [x (range (count hs)) y (range (count (first hs)))] [x y])) 
             (filter identity) (into {}))]
    (into {:hs (-> 
                hs 
                (assoc-in (:start pos) (int \a)) 
                (assoc-in (:end pos) (int \z)))} 
          pos)))

(defn neighbours [hs [x y :as pos]]
  (let [min-h (dec (get-in hs pos))]
    (->>
     [[(dec x) y] [(inc x) y] [x (dec y)] [x (inc y)]]
     (filter #(if-let [new-h (get-in hs %)] (<= min-h new-h))))))

(defn solve [part {:keys [hs start end]}]
  (letfn [(start-reached? [current]
            (if (= part 1)
              (current start)
              (->>
               current
               (filter #(= (get-in hs %) (int \a)))
               not-empty)))
          (step [[seen current]] 
                (let [neighbours 
                      (->> current 
                           (map #(neighbours hs %)) 
                           (apply concat) 
                           (into #{}))] 
                  [(set/union neighbours seen) 
                   (set/difference neighbours seen)]))] 
    (->> 
     (iterate step [#{end} #{end}]) 
     (map-indexed vector) 
     (filter (fn [[_index [_seen current]]] (start-reached? current))) 
     first 
     first)))

(defn -main
  "I don't do a whole lot ... yet."
  [& _]
  (let [input (parse (read-file "resources/input.txt"))]
    (doall (map #(println (solve % input)) [2]))))
