def d1(t): return (t+2) % 5 == 0
def d2(t): return (t+7) % 13 == 0
def d3(t): return (t+10) % 17 == 0
def d4(t): return (t+2) % 3 == 0
def d5(t): return (t+9) % 19 == 0
def d6(t): return (t+0) % 7 == 0
def d7(t): return (t+0) % 11 == 0

t = 0
while True:
    if d1(t+1) and d2(t+2) and d3(t+3) and d4(t+4) and d5(t+5) and d6(t+6):
        print(t)
        break
    t += 1

t = 0
while True:
    if d1(t+1) and d2(t+2) and d3(t+3) and d4(t+4) and d5(t+5) and d6(t+6) and d7(t+7):
        print(t)
        break
    t += 1