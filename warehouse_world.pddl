(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?l1 - location ?l2 - location ?r - robot)
      :precondition (and (free ?r)(at ?r ?l1) (no-robot ?l2)(connected ?l1 ?l2))
      :effect (and (at ?r ?l2)(not(at ?r ?l1))(no-robot ?l1)(not(no-robot ?l2)))
   )

   (:action robotMoveWithPallette
      :parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?l1)(at ?p ?l1)(no-robot ?l2)(no-pallette ?l2)(connected ?l1 ?l2))
      :effect (and (no-robot ?l1)(no-pallette ?l1)(at ?r ?l2)(at ?p ?l2)(not(at ?r ?l1))(not(at ?p ?l1))(not(no-robot ?l2))(not(no-pallette ?l2)))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (packing-location ?l)(contains ?p ?si)(packing-at ?s ?l)(orders ?o ?si)(ships ?s ?o)(at ?p ?l))
      :effect (and (not(contains ?p ?si))(includes ?s ?si))
   )

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s)(not (complete ?s))(packing-at ?s ?l)(packing-location ?l)(ships ?s ?o))
      :effect (and (complete ?s)(available ?l))
   )

)
