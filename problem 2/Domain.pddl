(define (domain mars-rover)
  (:requirements :strips :typing)
  (:types location rover equipment rock bay)

  (:constants)

  (:predicates
    (at-rover ?r - rover ?l - location)
    (at-rock ?k - rock ?l - location)
    (rock-at-base ?k - rock)
    (at-drill ?d - equipment ?l - location)
    (carrying-drill ?r - rover ?d - equipment)
    (empty-bay ?b - bay)
    (in-bay ?k - rock ?b - bay)
    (soft-rock ?k - rock)
    (hard-rock ?k - rock)
    (at-base ?l - location)
    (connected ?from - location ?to - location)
  )

  (:action move
    :parameters (?r - rover ?from - location ?to - location)
    :precondition (and (at-rover ?r ?from) (connected ?from ?to))
    :effect (and (not (at-rover ?r ?from)) (at-rover ?r ?to))
  )

  (:action pick-drill
    :parameters (?r - rover ?d - equipment ?l - location)
    :precondition (and (at-rover ?r ?l) (at-drill ?d ?l))
    :effect (and (not (at-drill ?d ?l)) (carrying-drill ?r ?d))
  )

  (:action collect-soft
    :parameters (?r - rover ?k - rock ?l - location ?b - bay)
    :precondition (and (at-rover ?r ?l) (at-rock ?k ?l)
                       (soft-rock ?k) (empty-bay ?b))
    :effect (and (not (at-rock ?k ?l)) (not (empty-bay ?b)) (in-bay ?k ?b))
  )

  (:action collect-hard
    :parameters (?r - rover ?k - rock ?l - location ?b - bay ?d - equipment)
    :precondition (and (at-rover ?r ?l) (at-rock ?k ?l)
                       (hard-rock ?k) (empty-bay ?b)
                       (carrying-drill ?r ?d))
    :effect (and (not (at-rock ?k ?l)) (not (empty-bay ?b)) (in-bay ?k ?b))
  )

  (:action deposit
    :parameters (?r - rover ?k - rock ?l - location ?b - bay)
    :precondition (and (at-rover ?r ?l) (at-base ?l) (in-bay ?k ?b))
    :effect (and (not (in-bay ?k ?b)) (rock-at-base ?k) (empty-bay ?b))
  )
)
