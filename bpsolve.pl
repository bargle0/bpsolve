% Copyright (C) 2025, bargle0
%
% Spoiler Warning:
% This solves a class of puzzles from the Blue Prince video game.
%
% Rules:
% * There are three boxes, colored blue, white, and black
% * Each box has a label
% * Each label has one or more clauses on it
% * Clauses can refer to other clauses ("The above statement is false")
% * Clauses can refer to other labels ("The blue box is false")
% * There is always at least one true label
% * There is always at least one false label
% * Exactly one box is full
% * There are two empty boxes
% * A box cannot be both full and empty
%
% The goal of the game is to figure out which box is full.
%
% Usage:
% 1. Rewrite the clauses (c1, c2) to reflect the state of
%    the puzzle.
% 2. For each of blue, white, and black, re-write the
%    hypothesis and invoke solve(_).
% 3. If solve(_) is true for a given hypothesis, then the
%    gems are in the box of that color.

% Hypothesis?
% This is the first problem with the program. I don't want
% to assert a hypothesis and test it. Rather, I want the
% program to enumerate all possible values of full(X) that
% satisfy the label ond box constraints.
%
% What I'm doing now technically works, but it's awkward to
% adjust which box is full and test. Moreover, this is a
% pattern that won't work when the solution space is any
% bigger. For example, you wouldn't want to interact with a
% Sudoku solver this way.
%
% That I don't understand how to do this probably means that
% there is something about Prolog that I fundamentally do
% not understand.
full(blue).

% Assume at most two clauses per label
c1(blue) :- full(blue).
c1(white).
c1(black) :- full(black).
c2(blue) :- empty(black).
c2(white) :- \+ c1(white).
c2(black) :- full(white).

% Define emptiness
empty(X) :- \+ full(X).

% Label truth
t(blue) :- c1(blue), c2(blue).
t(white) :- c1(white), c2(white).
t(black) :- c1(black), c2(black).

% Negation of label truth
f(X) :- \+ t(X).

% One label is always true, one label is always false
balance :- t(blue), t(white), f(black).
balance :- t(blue), f(white), f(black).
balance :- t(blue), f(white), t(black).
balance :- f(blue), f(white), t(black).
balance :- f(blue), t(white), t(black).
balance :- f(blue), t(white), f(black).

% Exactly one box is full
one_box :- full(blue), \+ full(white), \+ full(black).
one_box :- \+ full(blue), full(white), \+ full(black).
one_box :- \+ full(blue), \+ full(white), full(black).

solve(X) :- balance, one_box, full(X).

% There is one more rule I haven't figured out how to deal with:
%
% * A label may be indeterminate (blank).
