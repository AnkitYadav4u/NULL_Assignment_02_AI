/*
  File: royal_archive_access.pl
  Problem: Royal Archive Access Verification using Resolution Refutation
  Intended to run with SWI-Prolog.

  Run:
      swipl -s royal_archive_access.pl
  Then at the ?- prompt:
      run_proof.
      halt.

  The resolution engine below uses Prolog unification to resolve two clauses.
  Literals are represented as pos(Atom) and neg(Atom).
*/

% ============================================================
% Step 1: Predicate logic representation
% ============================================================
%
% Predicates:
%   archivist(Person)
%   verifies(Person, Record)
%   trusted(Person)
%   has_access(Person, Record)
%   permitted_to_inspect(Person, Record)
%   inspects(Person, Record)
%   finds_hidden_mark(Person, Record)
%   stored_in_royal_archive(Record)
%   sealed(Record)
%
% Constants:
%   mira, scroll_7
%
% Variables:
%   X = person; R = record
%
% FOL rules and facts:
% 1. forall X,R: (archivist(X) AND verifies(X,R)) -> trusted(X)
% 2. forall X,R: (trusted(X) AND sealed(R) AND has_access(X,R))
%               -> permitted_to_inspect(X,R)
% 3. forall X,R: (inspects(X,R) AND finds_hidden_mark(X,R))
%               -> verifies(X,R)
% 4. forall R: stored_in_royal_archive(R) -> sealed(R)
% 5. stored_in_royal_archive(scroll_7)
% 6. has_access(mira, scroll_7)
% 7. inspects(mira, scroll_7)
% 8. finds_hidden_mark(mira, scroll_7)
% 9. archivist(mira)
%
% Goal: trusted(mira)

% Optional Prolog representation of the original knowledge base.
fol_rule(1, forall([x,r],
    implies(and(archivist(x), verifies(x,r)), trusted(x)))).
fol_rule(2, forall([x,r],
    implies(and(trusted(x), and(sealed(r), has_access(x,r))),
            permitted_to_inspect(x,r)))).
fol_rule(3, forall([x,r],
    implies(and(inspects(x,r), finds_hidden_mark(x,r)),
            verifies(x,r)))).
fol_rule(4, forall([r],
    implies(stored_in_royal_archive(r), sealed(r)))).

fol_fact(stored_in_royal_archive(scroll_7)).
fol_fact(has_access(mira, scroll_7)).
fol_fact(inspects(mira, scroll_7)).
fol_fact(finds_hidden_mark(mira, scroll_7)).
fol_fact(archivist(mira)).
fol_goal(trusted(mira)).

% ============================================================
% Step 2: Negation of the goal
% ============================================================
% Goal: trusted(mira)
% Negated goal added to the knowledge base:
%       not trusted(mira)
%
% In the clause representation below this is:
%       neg(trusted(mira))

% ============================================================
% Step 3: Implication removal
% ============================================================
% General equivalence:
%       (A AND B) -> C  ===  not A OR not B OR C
%
% (1) not archivist(X) OR not verifies(X,R) OR trusted(X)
% (2) not trusted(X) OR not sealed(R) OR not has_access(X,R)
%       OR permitted_to_inspect(X,R)
% (3) not inspects(X,R) OR not finds_hidden_mark(X,R)
%       OR verifies(X,R)
% (4) not stored_in_royal_archive(R) OR sealed(R)
%
% Facts have no implications and remain positive unit clauses.

% ============================================================
% Step 4: Negation movement
% ============================================================
% The formulas above contain negations only immediately before
% predicates. Thus negations are already in negation normal form.
% No De Morgan transformation is needed.

% ============================================================
% Step 5: Standardization apart
% ============================================================
% Variables in different clauses are independent. In the clauses
% below, X1/R1, X2/R2, X3/R3 and R4 name variables in separate
% clauses, so no accidental variable sharing occurs.

% ============================================================
% Step 6: Skolemization
% ============================================================
% No existentially quantified variables occur in the knowledge base.
% Therefore, no Skolem constants or functions are required.
% Universal quantifiers are omitted in clause form.

% ============================================================
% Step 7: CNF / clause-form knowledge base
% ============================================================
% Clause IDs:
% C1: not archivist(X1) OR not verifies(X1,R1) OR trusted(X1)
% C2: not trusted(X2) OR not sealed(R2) OR not has_access(X2,R2)
%     OR permitted_to_inspect(X2,R2)
% C3: not inspects(X3,R3) OR not finds_hidden_mark(X3,R3)
%     OR verifies(X3,R3)
% C4: not stored_in_royal_archive(R4) OR sealed(R4)
% C5: stored_in_royal_archive(scroll_7)
% C6: has_access(mira, scroll_7)
% C7: inspects(mira, scroll_7)
% C8: finds_hidden_mark(mira, scroll_7)
% C9: archivist(mira)
% C10 (negated goal): not trusted(mira)
%
% A clause is a list of literals. pos(A) means A; neg(A) means not A.

cnf_clause(c1, [
    neg(archivist(X1)),
    neg(verifies(X1, _Record1)),
    pos(trusted(X1))
]).

cnf_clause(c2, [
    neg(trusted(X2)),
    neg(sealed(R2)),
    neg(has_access(X2, R2)),
    pos(permitted_to_inspect(X2, R2))
]).

cnf_clause(c3, [
    neg(inspects(X3, R3)),
    neg(finds_hidden_mark(X3, R3)),
    pos(verifies(X3, R3))
]).

cnf_clause(c4, [
    neg(stored_in_royal_archive(R4)),
    pos(sealed(R4))
]).

cnf_clause(c5, [pos(stored_in_royal_archive(scroll_7))]).
cnf_clause(c6, [pos(has_access(mira, scroll_7))]).
cnf_clause(c7, [pos(inspects(mira, scroll_7))]).
cnf_clause(c8, [pos(finds_hidden_mark(mira, scroll_7))]).
cnf_clause(c9, [pos(archivist(mira))]).
cnf_clause(c10, [neg(trusted(mira))]).

% ============================================================
% Step 8: Resolution implementation and execution
% ============================================================

% complementary/2 succeeds when literals have opposite signs.
% Their atoms are unified by Prolog during resolution.
complementary(pos(Atom), neg(Atom)).
complementary(neg(Atom), pos(Atom)).

% resolve_clauses(+ClauseA, +ClauseB, -Resolvent)
% Select one literal from each clause that unifies with opposite
% polarity, remove both literals, and combine the remaining literals.
% copy_term/2 makes fresh copies so each resolution step has fresh
% variables (standardizing the parent clauses apart).
resolve_clauses(ClauseA, ClauseB, Resolvent) :-
    copy_term(ClauseA-ClauseB, A-B),
    select(LitA, A, RestA),
    select(LitB, B, RestB),
    complementary(LitA, LitB),
    append(RestA, RestB, Resolvent).

% Resolve two named CNF clauses from the knowledge base.
resolve_named(IdA, IdB, Resolvent) :-
    cnf_clause(IdA, ClauseA),
    cnf_clause(IdB, ClauseB),
    resolve_clauses(ClauseA, ClauseB, Resolvent).

% Pretty-print clauses, including [] for the empty clause.
print_clause([]) :-
    write('[]'), !.
print_clause(Clause) :-
    write('['),
    print_literals(Clause),
    write(']').

print_literals([]).
print_literals([Literal]) :-
    print_literal(Literal).
print_literals([Literal|Rest]) :-
    print_literal(Literal),
    write(' v '),
    print_literals(Rest).

print_literal(pos(Atom)) :-
    write(Atom).
print_literal(neg(Atom)) :-
    write('~'),
    write(Atom).

print_step(Label, Clause) :-
    write(Label),
    write(': '),
    print_clause(Clause),
    nl.

% run_proof/0 follows a valid resolution-refutation path.
% It prints the resolvent after every step and succeeds only if [] is
% derived at the end.
run_proof :-
    nl,
    writeln('ROYAL ARCHIVE: RESOLUTION REFUTATION'),
    writeln('Initial clauses used in this proof:'),
    cnf_clause(c3, C3),
    print_step('C3', C3),
    cnf_clause(c7, C7),
    print_step('C7', C7),
    cnf_clause(c8, C8),
    print_step('C8', C8),
    cnf_clause(c1, C1),
    print_step('C1', C1),
    cnf_clause(c9, C9),
    print_step('C9', C9),
    cnf_clause(c10, C10),
    print_step('C10 (negated goal)', C10),
    nl,

    % Step R1: Resolve C3 with C7 using inspects(mira,scroll_7).
    resolve_clauses(C3, C7, R1),
    print_step('R1 = resolve(C3, C7)', R1),
    R1 = [neg(finds_hidden_mark(mira, scroll_7)),
          pos(verifies(mira, scroll_7))],

    % Step R2: Resolve R1 with C8 using finds_hidden_mark(mira,scroll_7).
    resolve_clauses(R1, C8, R2),
    print_step('R2 = resolve(R1, C8)', R2),
    R2 = [pos(verifies(mira, scroll_7))],

    % Step R3: Resolve C1 with C9 using archivist(mira).
    resolve_clauses(C1, C9, R3),
    print_step('R3 = resolve(C1, C9)', R3),
    R3 = [neg(verifies(mira, scroll_7)), pos(trusted(mira))],

    % Step R4: Resolve R3 with R2 using verifies(mira,scroll_7).
    resolve_clauses(R3, R2, R4),
    print_step('R4 = resolve(R3, R2)', R4),
    R4 = [pos(trusted(mira))],

    % Step R5: Resolve trusted(mira) with the negated goal.
    resolve_clauses(R4, C10, R5),
    print_step('R5 = resolve(R4, C10)', R5),

    ( R5 == [] ->
        nl,
        writeln('SUCCESS: the empty clause [] was derived.'),
        writeln('Therefore the negated goal is inconsistent with the KB,'),
        writeln('so the original goal trusted(mira) is proved.')
    ;
        writeln('FAILURE: the empty clause was not derived.'),
        fail
    ).

% Convenience predicate: list all clause-form clauses.
show_cnf :-
    forall(cnf_clause(Id, Clause),
           (write(Id), write(': '), print_clause(Clause), nl)).
