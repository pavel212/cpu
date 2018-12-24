require ("asm")

PC	= mem(0)
CG	= mem(1)
TST 	= mem(2)
ADD 	= mem(3)
SUB 	= mem(4)
PORT	= mem(5)

cnt	= mem(7)

function jmp(l)
  CG 	= l
  PC 	= CG
end

label "start"
CG 	= 0
cnt	= CG
PORT 	= CG

label "loop"
CG 	= 1
ADD 	= cnt   -- add = cnt + 1
cnt	= ADD
PORT 	= ADD

CG 	= -5
ADD 	= ADD       --add = add + 256 - 5
CG 	= "loop"
TST 	= ADD       --skip "exit" if not 0
CG 	= "exit"
PC 	= CG

label "exit"
jmp "exit"