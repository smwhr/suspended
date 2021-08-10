You control Mr Red, Ms Blue and their kid, Purple.
Switch characters using the buttons.

LIST characters = (MrRed), (MsBlue), (KidPurple)
LIST toys = (MonsieurPatate), (ToyCar)
LIST girlyObjects = (MakeUp), (Skirt)
LIST manlyObjects = (Hammer), (Tie)

VAR outside = (MrRed, MsBlue, KidPurple)
VAR kitchen = (Hammer)
VAR bedroom = (MakeUp, Tie, Skirt)
VAR corridor = (MonsieurPatate)
VAR living_room = (Skirt, ToyCar)

// -> blue

== red ==
Hello I'm {MrRed}
-> moveTo(MrRed, outside, corridor) ->
-> room_corridor(MrRed) ->

-> DONE

== blue ==
Good Morning I'm {MsBlue}
-> moveTo(MsBlue, outside, corridor) ->
-> room_corridor(MsBlue) ->

-> DONE

== purple ==
Hello I'm {KidPurple}
-> moveTo(KidPurple, outside, corridor) ->
-> room_corridor(KidPurple) ->

-> DONE

== otherPresent(character, room) ==
~ temp others = (room ^ characters) - character

<> {LIST_COUNT(others):
    - 0 : There's no one here.
    - else : You can see {list_with_commas(others)} {LIST_COUNT(others) > 1: are|is} here.
    }
->->

== objectOfInterest(character, room) ==
~ temp objects = ()
{character:
    - MrRed:
        ~ objects = (room ^ manlyObjects)
    - MsBlue:
        ~ objects = (room ^ girlyObjects)
    - KidPurple:
        ~ objects = (room ^ toys)
    }
<> {LIST_COUNT(objects):
    - 0 : There's nothing of interest here.
    - else : Objects of interest to you : {list_with_commas(objects)}.
    }
->->

== moveTo(character, ref from, ref towards) ==
    ~ from = from - character
    ~ towards = towards + character
    ->->

== room_corridor(character) ==
-(enter)
You {came_from(->room_corridor): enter|are in} the corridor.
-> otherPresent(character, corridor) ->
-> objectOfInterest(character, corridor) ->
-(exits)
+ [Look]
    -> enter
+ [Exit: living room]
    -> moveTo(character, corridor, living_room) ->
    -> room_living_room(character)
+ [Exit: kitchen]
    -> moveTo(character, corridor, kitchen) ->
    -> room_kitchen(character)
+ [Exit: bedroom]
    -> moveTo(character, corridor, bedroom) ->
    -> room_bedroom(character)
->->


== room_living_room(character) ==
-(enter)
You {came_from(->room_living_room): enter|are in} the living room..
-> otherPresent(character, living_room) ->
-> objectOfInterest(character, living_room) ->
-(exits)
+ [Look]
    -> enter
+ [Exit: corridor]
    -> moveTo(character, living_room, corridor) ->
    -> room_corridor(character)
+ [Exit: bedroom]
    -> moveTo(character, living_room, bedroom) ->
    -> room_bedroom(character)

== room_bedroom(character) ==
-(enter)
You {came_from(->room_bedroom): enter|are in} the bedroom.
-> otherPresent(character, bedroom) ->
-> objectOfInterest(character, bedroom) ->
-(exits)
+ [Look]
    -> enter
+ [Exit: corridor]
    -> moveTo(character, bedroom, corridor ) ->
    -> room_corridor(character)
+ [Exit: living room]
    -> moveTo(character, bedroom, living_room) ->
    -> room_living_room(character)

== room_kitchen(character) ==
-(enter)
You {came_from(->room_kitchen): enter|are in} the kitchen.
-> otherPresent(character, kitchen) ->
-> objectOfInterest(character, kitchen) ->
-(exits)
+ [Look]
    -> enter
+ [Exit: corridor]
    -> moveTo(character, kitchen, corridor) ->
    -> room_corridor(character)
    
    
=== function list_with_commas(list)
	{ list:
		{_list_with_commas(list, LIST_COUNT(list))}
	}

=== function _list_with_commas(list, n)
	{pop(list)}{ n > 1:{n == 2: and |, }{_list_with_commas(list, n-1)}}


=== function pop(ref _list) 
    ~ temp el = LIST_MIN(_list) 
    ~ _list -= el
    ~ return el 

=== function came_from(-> x) 
    ~ return TURNS_SINCE(x) == 0

