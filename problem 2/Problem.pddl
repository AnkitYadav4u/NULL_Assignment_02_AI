(define (problem mars-sample-original)
  (:domain mars-rover)
  (:objects
    base sitea siteb sitec sited sitee sitef - location
    curiosity - rover
    drill1 - equipment
    rock1 rock2 rock3 rock4 rock5 - rock
    bay1 bay2 - bay
  )
  (:init
    (at-rover curiosity base)
    (at-base base)
    (at-drill drill1 sitee)
    (empty-bay bay1) (empty-bay bay2)

    (at-rock rock1 sitea) (soft-rock rock1)
    (at-rock rock2 siteb) (soft-rock rock2)
    (at-rock rock3 sitec) (hard-rock rock3)
    (at-rock rock4 sited) (soft-rock rock4)
    (at-rock rock5 sitef) (hard-rock rock5)

    (connected base sitea) (connected sitea base)
    (connected base siteb) (connected siteb base)
    (connected sitea sitec) (connected sitec sitea)
    (connected siteb sited) (connected sited siteb)
    (connected sitec sitee) (connected sitee sitec)
    (connected sited sitee) (connected sitee sited)
    (connected sitee sitef) (connected sitef sitee)
    (connected sitec sited)
  )
  (:goal (and
    (rock-at-base rock1) (rock-at-base rock2) (rock-at-base rock3)
    (rock-at-base rock4) (rock-at-base rock5)
    (empty-bay bay1) (empty-bay bay2)
    (at-rover curiosity base)
  ))
)
