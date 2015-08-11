from epics import caget, caput
from epics import PV


#pv1 = PV('SR01C:BPM')

print caget('spr:v4g11/am')
