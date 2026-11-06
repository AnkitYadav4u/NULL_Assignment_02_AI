import re
from pathlib import Path

OUT=Path(__file__).parent/"planner_output"

locations={"base","sitea","siteb","sitec","sited","sitee","sitef"}
two_way={
 ("base","sitea"),("sitea","base"),("base","siteb"),("siteb","base"),
 ("sitea","sitec"),("sitec","sitea"),("siteb","sited"),("sited","siteb"),
 ("sitec","sitee"),("sitee","sitec"),("sited","sitee"),("sitee","sited"),("sitee","sitef"),("sitef","sitee")}

class State:
 def __init__(self,extended=False):
  self.rover="base"; self.drill_location="sitee"; self.drill=False
  rocks={"rock1":"sitea","rock2":"siteb","rock3":"sitec","rock4":"sited","rock5":"sitef"}
  if extended: rocks.update({"rock6":"sitee","rock7":"sitef"})
  self.rocks=rocks; self.bays={"bay1":None,"bay2":None}; self.rock_base=set(); self.extended=extended
 def apply(self,line,i):
  parts=line.strip().strip("()").split()
  name=parts[0]; args=parts[1:]
  if name=="move":
   r,src,dst=args
   assert r=="curiosity" and self.rover==src,(i,line,"rover not at source")
   routes=set(two_way)
   routes.add(("sitec","sited"))
   if self.extended: routes.discard(("base","siteb")); routes.discard(("siteb","base"))
   assert (src,dst) in routes,(i,line,"invalid route")
   self.rover=dst
  elif name=="pick-drill":
   r,d,l=args; assert r=="curiosity" and self.rover==l and self.drill_location==l,(i,line)
   self.drill=True; self.drill_location=None
  elif name.startswith("collect"):
   r,k,l,b,*rest=args
   assert self.rover==l and self.rocks.get(k)==l,(i,line,"rock not at location")
   assert self.bays[b] is None,(i,line,"bay occupied")
   if k in {"rock3","rock5","rock7"}: assert self.drill,(i,line,"hard rock without drill")
   self.bays[b]=k; del self.rocks[k]
  elif name=="deposit":
   r,k,l,b=args
   assert self.rover==l=="base" and self.bays[b]==k,(i,line,"invalid deposit")
   self.bays[b]=None; self.rock_base.add(k)

def check(filename,extended):
 txt=(OUT/filename).read_text().strip()
 lines=[x.strip() for x in txt.splitlines() if x.strip()]
 s=State(extended)
 for i,line in enumerate(lines,1): s.apply(line,i)
 wanted={"rock1","rock2","rock3","rock4","rock5"}|({"rock6","rock7"} if extended else set())
 assert s.rock_base==wanted,(s.rock_base,wanted)
 assert s.bays=={"bay1":None,"bay2":None}
 assert s.rover=="base"
 return len(lines),s

if __name__=="__main__":
 for fn,ext in [("original_gbf.soln",False),("original_astar.soln",False),("extended_gbf.soln",True),("extended_astar.soln",True)]:
  n,s=check(fn,ext)
  print(f"{fn}: VERIFIED — {n} actions; all rocks at Base={sorted(s.rock_base)}; bays empty={s.bays}; rover={s.rover}")
