%author: nate alberti
%date: november 2021
%description: this takes the user thru a second person adventure,
%where their car breaks down and have to make a series of decisions.


% assign the state that will start the program

start_state(car).

% define the edges of the finite state diagram

next_state(car,a,hitchhike).
next_state(car,b,gas_station).
next_state(car,c,house).

next_state(hitchhike,a,kidnap).
next_state(hitchhike,b,safety).

next_state(gas_station,a,kidnap).
next_state(gas_station,b,safety).

next_state(house,a,car).
next_state(house,b,car).

% code to be executed at the beginning...

display_intro :-
  write('Youre driving down a small dirt road in a forest in the evening.'),nl,
  write('Suddenly, you hear some sputters from your engine... and your car stops.'),nl,
  write('You pull over to the side of the road.'),nl,nl.
  
initialize :-

% code to be executed at the end...

goodbye :-
  write( 'THANK YOU FOR PLAYING THE GAME.'),nl.
  
% code to be executed upon reaching each_state

show_state(car) :- 
  write( 'Its getting dark out... what are your options?' ), nl,
  write( '(a) Try and hitchhike.'),nl,
  write( '(b) Try and make it to the nearest gas station.'),nl,
  write( '(c) Check out a nearby abandoned-looking home.'),nl,
  write( '(q) Quit the program'),nl,nl,nl.

show_state(hitchhike) :- 
  write( 'A sketchy-looking truck stops by, and rolls down their window...' ), nl,
  write( 'A man offers you a ride to the nearest town.'), nl,
  write( '(a) Accept the offer.'),nl,
  write( '(b) Politely decline... maybe you can walk anyways.'),nl,
  write( '(q) Quit the program'),nl,nl,nl.
  
show_state(gas_station) :-
  write( 'A sketchy-looking truck stops by, and rolls down their window...' ), nl,
  write( 'A man offers you a ride to the nearest town.'), nl,
  write( '(a) Accept the offer.'),nl,
  write( '(b) Politely decline... maybe you can walk anyways.'),nl,
  write( '(q) Quit the program'),nl,nl,nl.
  
show_state(house) :-
  write( 'The house is empty, nothing of value nor any people are here.' ),nl,
  write( '(a) Go back to your car.'),nl,
  write( '(b) Sleep at the house.'),nl,
  write( '(q) Quit the program'),nl,nl,nl.
  
% final states do not display a menu 

%  - they automatically quit ('q')

show_state(kidnap) :- 
  write( 'Unfortunately youre night is cut short...' ), nl,
  write( 'The driver takes you into the forest, and youre never seen again.' ),nl,nl,nl.
  
show_state(safety) :-
  write( 'The gas station has a phone so you can call a family member.'),nl,
  write( 'Fortunately, you make it past this horrible day.' ),nl,nl,nl.
  
get_choice(kidnap, q).
get_choice(safety,q).

% code to be executed for each choice of action from each state...

show_transition(car,a) :- 
  write( 'Hitchhiking can be dangerous... but what other options do you have?'),nl,nl.
  
show_transition(car,b) :- 
  write( 'You decide to try to make it to the gas station, despite it being several miles away'),nl,
  write( 'By the time youre halfway there, it is pitch black out.'),nl,
  write( 'You have no flashlight.'),nl,nl.
  
show_transition(car,c) :- 
  write( 'Maybe there is somebody with a phone?'),nl,
  write( 'It would be great to call a family member.'),nl,
  write( 'At least, you think the building may be safer than sleeping in your car.'),nl,nl.
  
show_transition(hitchhike,a) :- 
  write('You get in the car and ask the driver to take you.'),nl.
  write('to the nearest gas station.'),nl,nl.
  
show_transition(hitchhike,b) :- 
  write( 'You decline the offer, and continue.'),nl.
  write('After an hour of walking, you finally make it to the gas station.'),nl,nl.
  
show_transition(gas_station,a) :- 
  write('You get in the car and ask the driver to take you.'),nl,
  write('to the nearest gas station.'),nl,nl.
  
show_transition(gas_station,b) :- 
  write( 'You think the driver cant be up to any good this late at night.'),nl,
  write('You decline and continue walking.'),nl,nl.
  
show_transition(house,a) :- 
  write( 'Its not safe to sleep at the house...'),nl,
  write( 'You return to your car to clear your mind.'),nl,nl.
  
show_transition(house,b) :- 
  write( 'Youre too frightened to return to the car.'),nl,
  write( 'It may be dangerous, but your sleep at the house.'),nl,nl,
  write('When you wake, you find youve slept most of the day!'),nl,
  write('Your family must be worried sick.'),nl,
  write('Eventually you find your way back to your car from the previous night.'),nl,nl.
  
% basic finite state machine engine

go :-
	intro,
	start_state(X),
	show_state(X),
	get_choice(X,Y),
	go_to_next_state(X,Y).

intro :-
	display_intro,
	clear_stored_answers,
	initialize,
      asserta(stored_answer(moves,0)).
      
go_to_next_state(_,q) :-
      stored_answer(moves,Count),
      write( 'You made ' ),
      write( Count ), nl,
      write('moves.'),
	goodbye.

go_to_next_state(S1,Cin) :-
	next_state(S1,Cin,S2),
	show_transition(S1,Cin),
	show_state(S2),
	stored_answer(moves,K),
	OneMoreMove is K + 1,
	retract(stored_answer(moves,_)),
	asserta(stored_answer(moves,OneMoreMove)),
	get_choice(S2,Cnew),
	go_to_next_state(S2,Cnew).

go_to_next_state(S1,Cin) :-
	\+ next_state(S1,Cin,_),
	show_transition(S1,fail),
	get_choice(S1,Cnew),
	go_to_next_state(S1,Cnew).

get_choice(_,C) :-
    write('Next entry (letter '),
      write('followed by a period )? '),
    read(C).
    
% case knowledge base - user responses
:- dynamic(stored_answer/2).

% procedure to get rid of previous responses
% without abolishing the dynamic declaration

clear_stored_answers :- 
	retract(stored_answer(_,_)),fail.
    
clear_stored_answers.
