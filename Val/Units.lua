-- Definitions for units known to val
-- File format is two strings and a return statement with them in it:
-- string in quotes [=[ ... builtin_units ... ]=].
-- string in quotes [=[ ... builtin_units_long_scale ... ]=].
-- First string, builtin_units, is short-scale, second string is long scale.

-- Entry format:
-- One record per line, starting in first column, having 2-4 fields.
-- Field separator: two or more spaces
-- Between first and second fields: two or more spaces
-- Between all other fields: two or more spaces, or one or more tabs
-- Entries without two spaces in them are ignored.

-- There must be a blank line before the first entry and after the last.
-- I.e. the first two and last two characters of the string must be newlines.

-- Format of entry. Two record types:
--
-- One record type is a wikilink:
-- Unit-code        [[ pagename | Symbol-accepts-HTML-only ]]
-- Text-field separator is still two spaces.  Two spaces not allowed in wikilink.
--
-- The other record type is all fields:
-- Unit-code        symbol-accepts-HTML-only        pagename#section-OK
--
-- Plus there is an optional field that goes at the end after two or more spaces.
-- Whether it is a number or an equation or the letters SI,
-- any of these three has the same function: a wikitable sorting "scale".
-- It is for sorting, and it works for either record type.
-- Difference is SI can't accept HTML. But SI correctly scales any SI prefix.
-- (Optional fields ALIAS and NOSPACE and ANGLE are for advanced users.)

-- "Invalid unit" error:
-- Using SI requires that the symbol equal unit-code, so never allows HTML.
-- Any difference between SI or symbol must be an SI prefix, such as k, M, or G.
-- A space at the end of an entry is an error. No space at each EOL.

local builtin_units = [=[

== Test ==
Foo  [[w:Hz|<samp>Foo</samp>]]
Baz  [[w:Hertz|baz<sub>0</sub>]]
Baz  [[w:Kelvins|baz<sub>0</sub>]]
Bar  [[w:Foobar|bar<abbr title="super duper">0</abbr>]]
quux  [[w:Foobar|<span title="super duper 2">bar0</span>]]

== Unsorted units ==
c0  [[w:Speed of light#Numerical value, notation, and units|''c''<sub>0</sub>]]
lbf  [[w:Pound (force)|<span title="pound-force">lb<sub>F</sub></span>]]
N.s  [[w:Newton-second|N&sdot;s]]
J.K-1  [[w:Joule per kelvin|J&sdot;K<sup>−1</sup>]]
C.mol-1  [[w:Faraday constant|C&sdot;mol<sup>−1</sup>]]
C/mol  [[w:Faraday constant|C/mol]]
C.kg-1  [[w:Roentgen (unit)|C&sdot;kg<sup>−1</sup>]]
C/kg  [[w:Roentgen (unit)|C/kg]]
F.m-1  [[w:vacuum permittivity|F&sdot;m<sup>−1</sup>]]
F/m  [[w:vacuum permittivity|F/m]]
e  [[w:Elementary charge|''e'']]
kB  [[w:Kilobyte|kB]]  8e3
KB  [[w:Kilobyte|KB]]  8e3
MB  [[w:Megabyte|MB]]  8e6
GB  [[w:Gigabyte|GB]]  8e9
TB  [[w:Terabyte|TB]]  8e12
lx  [[w:Lux (unit)|lx]]
nat  [[w:nat (unit)|nat]]

== Time and frequency ==
byte/s  [[w:Data rate units|byte/s]]  8
kB/s  [[w:Data rate units#Kilobyte per second|<span title="Kilobytes per second">kB/s</span>]]  8e3
MB/s  [[w:Data rate units#Megabyte per second|<span title="Megabytes per second">MB/s</span>]]  8e6
GB/s  [[w:Data rate units#Gigabyte per second|<span title="Gigabytes per second">GB/s</span>]]  8e9
TB/s  [[w:Data rate units#Terabyte per second|<span title="Terabytes per second">TB/s</span>]]  8e12
bit/s  [[w:Bit per second|bit/s]]  1
bps  [[w:Bit per second|bit/s]]  1
kbit/s  [[w:Kilobit per second|kbit/s]]  1e3
Mbit/s  [[w:Megabit per second|Mbit/s]]  1e6
Gbit/s  [[w:Gigabit per second|Gbit/s]]  1e9
Tbit/s  [[w:Terabit per second|Tbit/s]]  1e12
kT/s  [[w:Transfer (computing)|<span title="Kilotransfers per second">kT/s</span>]]  1e3
MT/s  [[w:Transfer (computing)|<span title="Megatransfers per second">MT/s</span>]]  1e6
GT/s  [[w:Transfer (computing)|<span title="Gigatransfers per second">GT/s</span>]]  1e9
year  [[w:Year|year]]  31557600
years  [[w:Year|years]]  31557600
yr  [[w:Year#Symbols and abbreviations|yr]]  31557600
y  [[w:Year|y]]  31557600
a  [[w:Annum|a]]  31557600
Ga  [[w:Gigaannum|Ga]]  31557600000000000
Ma  [[w:Megaannum|Ma]]  31557600000000
ka  [[w:Kiloannum|ka]]  31557600000
kyr  [[w:kyr|kyr]]  31557600000
kya  [[w:kyr|kya]]  31557600000
myr  [[w:myr|myr]]  31557600000000
mya  [[w:Mya (unit)|mya]]  31557600000000
byr  [[w:Billion years|byr]]  31557600000000000
bya  [[w:Billion years ago|bya]]  31557600000000000
Gyr  [[w:billion years|Gyr]]  31557600000000000
BP  [[w:Before present|BP]]
uBP  [[w:Radiocarbon dating#Calibration|<sup>14</sup>C yr BP]]
BC  [[w:Before Christ|BC]]  -1
AD  [[w:Anno Domini|AD]]  1
BCE  [[w:Before the Common Era|BCE]]  -1
CE  [[w:Common Era|CE]]  1
JD  [[w:Julian date|JD]]  1
MJD  [[w:Modified Julian date|MJD]]  1

s-1  [[w:Second|s<sup>−1</sup>]]
s-2  [[w:Second|s<sup>−2</sup>]]
s2  [[w:Second|s<sup>2</sup>]]

s  [[w:Second|s]]  SI
as  [[w:Attosecond|s]]  SI
cs  [[w:Second|s]]  SI
das  [[w:Second|s]]  SI
ds  [[w:Second|s]]  SI
Es  [[w:Second|s]]  SI
fs  [[w:Femtosecond|s]]  SI
Gs  [[w:Second|s]]  SI
hs  [[w:Second|s]]  SI
ks  [[w:Second|s]]  SI
ms  [[w:Millisecond|s]]  SI
µs  [[w:Microsecond|s]]  SI
us  [[w:Microsecond|s]]  SI
Ms  [[w:Second|s]]  SI
ns  [[w:Nanosecond|s]]  SI
ps  [[w:Picosecond|s]]  SI
Ps  [[w:Second|s]]  SI
Ts  [[w:Second|s]]  SI
Ys  [[w:Second|s]]  SI
ys  [[w:Yoctosecond|s]]  SI
Zs  [[w:Second|s]]  SI
zs  [[w:Zeptosecond|s]]  SI

Hz  [[w:Hertz|Hz]]  SI
aHz  [[w:Hertz|Hz]]  SI
cHz  [[w:Hertz|Hz]]  SI
daHz  [[w:Hertz|Hz]]  SI
dHz  [[w:Hertz|Hz]]  SI
EHz  [[w:Hertz|Hz]]  SI
fHz  [[w:Hertz|Hz]]  SI
hHz  [[w:Hertz|Hz]]  SI
GHz  [[w:Gigahertz|Hz]]  SI
kHz  [[w:Kilohertz|Hz]]  SI
MHz  [[w:Megahertz|Hz]]  SI
mHz  [[w:Hertz|Hz]]  SI
uHz  [[w:Hertz|Hz]]  SI
µHz  [[w:Hertz|Hz]]  SI
nHz  [[w:Hertz|Hz]]  SI
pHz  [[w:Hertz|Hz]]  SI
PHz  [[w:Hertz|Hz]]  SI
THz  [[w:Hertz|Hz]]  SI
yHz  [[w:Hertz|Hz]]  SI
YHz  [[w:Hertz|Hz]]  SI
zHz  [[w:Hertz|Hz]]  SI
ZHz  [[w:Hertz|Hz]]  SI

ips  [[w:Inch per second|ips]]

== Length, area, volume ==
Å3   [[w:Ångström|Å<sup>3</sup>]]
fb-1  [[w:Barn (unit)#Inverse femtobarn|fb<sup>−1</sup>]]
m-1  [[w:Metre|m<sup>−1</sup>]]
m-2  [[w:Square metre|m<sup>−2</sup>]]
m-3  [[w:Cubic metre|m<sup>−3</sup>]]
km2  [[w:Square kilometre|km<sup>2</sup>]]
km3  [[w:Cubic kilometre|km<sup>3</sup>]]
µm2  [[w:Square metre|µm<sup>2</sup>]]
um2  [[w:Square metre|µm<sup>2</sup>]]
am2  [[w:Square metre|am<sup>2</sup>]]
cm2  [[w:Square centimetre|cm<sup>2</sup>]]
dam2  [[w:Square metre|dam<sup>2</sup>]]
dm2  [[w:Square metre|dm<sup>2</sup>]]
Em2  [[w:Square metre|Em<sup>2</sup>]]
fm2  [[w:Square metre|fm<sup>2</sup>]]
Gm2  [[w:Square metre|Gm<sup>2</sup>]]
hm2  [[w:Square metre|hm<sup>2</sup>]]
mm2  [[w:Square metre|mm<sup>2</sup>]]
Mm2  [[w:Square metre|Mm<sup>2</sup>]]
nm2  [[w:Square metre|nm<sup>2</sup>]]
pm2  [[w:Square metre|pm<sup>2</sup>]]
Pm2  [[w:Square metre|Pm<sup>2</sup>]]
Tm2  [[w:Square metre|Tm<sup>2</sup>]]
ym2  [[w:Square metre|ym<sup>2</sup>]]
Ym2  [[w:Square metre|Ym<sup>2</sup>]]
zm2  [[w:Square metre|zm<sup>2</sup>]]
Zm2  [[w:Square metre|Zm<sup>2</sup>]]
gal  [[w:Gallon|gal]]
Gal  [[w:Gal (unit)|Gal]]
uGal  [[w:Gal (unit)|µGal]]
µGal  [[w:Gal (unit)|µGal]]
mGal  [[w:Gal (unit)|mGal]]

b  [[w:Barn (unit)|b]]  SI
ab  [[w:Barn (unit)|b]]  SI
cb  [[w:Barn (unit)|b]]  SI
dab  [[w:Barn (unit)|b]]  SI
db  [[w:Barn (unit)|b]]  SI
Eb  [[w:Barn (unit)|b]]  SI
fb  [[w:Barn (unit)|b]]  SI
Gb  [[w:Barn (unit)|b]]  SI
hb  [[w:Barn (unit)|b]]  SI
kb  [[w:Barn (unit)|b]]  SI
mb  [[w:Barn (unit)|b]]  SI
µb  [[w:Barn (unit)|b]]  SI
ub  [[w:Barn (unit)|b]]  SI
Mb  [[w:Barn (unit)|b]]  SI
nb  [[w:Barn (unit)|b]]  SI
pb  [[w:Barn (unit)|b]]  SI
Pb  [[w:Barn (unit)|b]]  SI
Tb  [[w:Barn (unit)|b]]  SI
Yb  [[w:Barn (unit)|b]]  SI
yb  [[w:Barn (unit)|b]]  SI
Zb  [[w:Barn (unit)|b]]  SI
zb  [[w:Barn (unit)|b]]  SI

== Velocity and acceleration ==
m.s-2  [[w:Metre per second squared|m&sdot;s<sup>−2</sup>]]
m/s2  [[w:Metre per second squared|m/s<sup>2</sup>]]
m.s-1  [[w:Metre per second|m&sdot;s<sup>−1</sup>]]
m/s  [[w:Metre per second|m/s]]
km.s-1  [[w:Metre per second|km&sdot;s<sup>−1</sup>]]
km/s  [[w:Metre per second|km/s]]

== Mass and energy ==
lbm  [[w:Pound (mass)|<span title="pound-mass">lb<sub>m</sub></span>]]
uJ  [[w:Joule|µJ]]
J.s  [[w:Joule-second|J&sdot;s]]
kWh  [[w:Kilowatt hour|kWh]]
kW.h  [[w:Kilowatt hour|kW&sdot;h]]
J/C  [[w:Volt|J/C]]
J/kg  [[w:Joule|J/kg]]

Da  [[w:Dalton (unit)|Da]]  SI
EDa  [[w:Dalton (unit)|Da]]  SI
PDa  [[w:Dalton (unit)|Da]]  SI
TDa  [[w:Dalton (unit)|Da]]  SI
GDa  [[w:Dalton (unit)|Da]]  SI
MDa  [[w:Dalton (unit)|Da]]  SI
kDa  [[w:Dalton (unit)|Da]]  SI
mDa  [[w:Dalton (unit)|Da]]  SI
uDa  [[w:Dalton (unit)|Da]]  SI
μDa  [[w:Dalton (unit)|Da]]  SI
nDa  [[w:Dalton (unit)|Da]]  SI
pDa  [[w:Dalton (unit)|Da]]  SI
fDa  [[w:Dalton (unit)|Da]]  SI
aDa  [[w:Dalton (unit)|Da]]  SI

g  [[w:Gram|g]]  SI
ag  [[w:Attogram|g]]  SI
cg  [[w:Centigram|g]]  SI
dag  [[w:Gram|g]]  SI
dg  [[w:Decigram|g]]  SI
Eg  [[w:Exagram|g]]  SI
fg  [[w:Femtogram|g]]  SI
Gg  [[w:Gigagram|g]]  SI
hg  [[w:Kilogram#SI multiples|g]]  SI
kg  [[w:Kilogram|g]]  SI
mcg  [[w:Microgram|g]]  SI
Mg  [[w:Megagram|g]]  SI
mg  [[w:Milligram|g]]  SI
ug  [[w:Microgram|g]]  SI
µg  [[w:Microgram|g]]  SI
ng  [[w:Nanogram|g]]  SI
Pg  [[w:Petagram|g]]  SI
pg  [[w:Picogram|g]]  SI
Tg  [[w:Tonne|g]]  SI
yg  [[w:Yoctogram|g]]  SI
Yg  [[w:Yottagram|g]]  SI
zg  [[w:Zeptogram|g]]  SI
Zg  [[w:Zettagram|g]]  SI

== Pressure and density ==
psi  [[w:Pounds per square inch|psi]]
g.cm-3  [[w:Gram per cubic centimetre|g&sdot;cm<sup>−3</sup>]]
g/cm3  [[w:Gram per cubic centimetre|g/cm<sup>3</sup>]]
kg.m-3  [[w:Kilogram per cubic metre|kg&sdot;m<sup>−3</sup>]]
kg/m3  [[w:Kilogram per cubic metre|kg/m<sup>3</sup>]]
kg/cm3  [[w:Density#Formula and common units|kg/cm<sup>3</sup>]]
g/L  [[w:Gram per litre|g/L]]
g/l  [[w:Gram per litre|g/l]]
mcg/dL  [[w:Gram per litre|µg/dL]]
mcg/dl  [[w:Gram per litre|µg/dl]]
mg/mL  [[w:Gram per litre|mg/mL]]
mg/ml  [[w:Gram per litre|mg/ml]]
ug/dL  [[w:Gram per litre|µg/dL]]
ug/dl  [[w:Gram per litre|µg/dl]]
μg/dL  [[w:Gram per litre|μg/dL]]
μg/dl  [[w:Gram per litre|μg/dl]]
mg.L-1  [[w:Gram per litre|<abbr title="milligrams per liter">mg/L</abbr>]]
mg/L  [[w:Gram per litre|<abbr title="milligrams per liter">mg/L</abbr>]]
mg.l-1  [[w:Gram per litre|<abbr title="milligrams per liter">mg/l</abbr>]]
mg/l  [[w:Gram per litre|<abbr title="milligrams per liter">mg/l</abbr>]]

== Fracture toughness ==
MPa.m.5  [[w:Fracture toughness|MPa&sdot;m<sup>1/2</sup>]]
kPa.m.5  [[w:Fracture toughness|kPa&sdot;m<sup>1/2</sup>]]
Pa.m.5  [[w:Fracture toughness|Pa&sdot;m<sup>1/2</sup>]]

== Temperature ==
degC  °C  ALIAS
degF  °F  ALIAS
degR  °R  ALIAS

K  [[w:Kelvin|K]]  SI
YK  [[w:Yottakelvin|K]]  SI
ZK  [[w:Zettakelvin|K]]  SI
EK  [[w:Kelvin|K]]  SI
PK  [[w:Petakelvin|K]]  SI
TK  [[w:Terakelvin|K]]  SI
GK  [[w:Gigakelvin|K]]  SI
MK  [[w:Megakelvin|K]]  SI
kK  [[w:Kilokelvin|K]]  SI
hK  [[w:Hectokelvin|K]]  SI
daK  [[w:Decakelvin|K]]  SI
dK  [[w:Decikelvin|K]]  SI
cK  [[w:Centikelvin|K]]  SI
mK  [[w:Millikelvin|K]]  SI
µK  [[w:Microkelvin|K]]  SI
uK  [[w:Microkelvin|K]]  SI
nK  [[w:Nanokelvin|K]]  SI
pK  [[w:Picokelvin|K]]  SI
fK  [[w:Femtokelvin|K]]  SI
aK  [[w:Attokelvin|K]]  SI
zK  [[w:Zeptokelvin|K]]  SI
yK  [[w:Yoctokelvin|K]]  SI

== Electromagnetism ==
Wb  [[w:Weber (unit)|Wb]]
N.A-2  [[w:Permeability (electromagnetism)|N&sdot;A<sup>−2</sup>]]
H.m-1  [[w:Permeability (electromagnetism)|H&sdot;m<sup>−1</sup>]]
V.m-1  [[w:Electric field|V&sdot;m<sup>−1</sup>]]
V/m  [[w:Electric field|V/m]]

C  [[w:Coulomb|C]]  SI
YC  [[w:Coulomb|C]]  SI
ZC  [[w:Coulomb|C]]  SI
EC  [[w:Coulomb|C]]  SI
PC  [[w:Coulomb|C]]  SI
TC  [[w:Coulomb|C]]  SI
GC  [[w:Coulomb|C]]  SI
MC  [[w:Coulomb|C]]  SI
kC  [[w:Coulomb|C]]  SI
hC  [[w:Coulomb|C]]  SI
daC  [[w:Coulomb|C]]  SI
dC  [[w:Coulomb|C]]  SI
cC  [[w:Coulomb|C]]  SI
mC  [[w:Coulomb|C]]  SI
µC  [[w:Coulomb|C]]  SI
uC  [[w:Coulomb|C]]  SI
nC  [[w:Coulomb|C]]  SI
pC  [[w:Coulomb|C]]  SI
fC  [[w:Coulomb|C]]  SI
aC  [[w:Coulomb|C]]  SI
zC  [[w:Coulomb|C]]  SI
yC  [[w:Coulomb|C]]  SI

F  [[w:Farad|F]]  SI
YF  [[w:Farad|F]]  SI
ZF  [[w:Farad|F]]  SI
EF  [[w:Farad|F]]  SI
PF  [[w:Farad|F]]  SI
TF  [[w:Farad|F]]  SI
GF  [[w:Farad|F]]  SI
MF  [[w:Farad|F]]  SI
kF  [[w:Farad|F]]  SI
hF  [[w:Farad|F]]  SI
daF  [[w:Farad|F]]  SI
dF  [[w:Farad|F]]  SI
cF  [[w:Farad|F]]  SI
mF  [[w:Farad|F]]  SI
µF  [[w:Farad|F]]  SI
uF  [[w:Farad|F]]  SI
nF  [[w:Farad|F]]  SI
pF  [[w:Farad|F]]  SI
fF  [[w:Farad|F]]  SI
aF  [[w:Farad|F]]  SI
zF  [[w:Farad|F]]  SI
yF  [[w:Farad|F]]  SI

H  [[w:Henry (unit)|H]]  SI
YH  [[w:Henry (unit)|H]]  SI
ZH  [[w:Henry (unit)|H]]  SI
EH  [[w:Henry (unit)|H]]  SI
PH  [[w:Henry (unit)|H]]  SI
TH  [[w:Henry (unit)|H]]  SI
GH  [[w:Henry (unit)|H]]  SI
MH  [[w:Henry (unit)|H]]  SI
kH  [[w:Henry (unit)|H]]  SI
hH  [[w:Henry (unit)|H]]  SI
daH  [[w:Henry (unit)|H]]  SI
dH  [[w:Henry (unit)|H]]  SI
cH  [[w:Henry (unit)|H]]  SI
mH  [[w:Henry (unit)|H]]  SI
µH  [[w:Henry (unit)|H]]  SI
uH  [[w:Henry (unit)|H]]  SI
nH  [[w:Henry (unit)|H]]  SI
pH  [[w:Henry (unit)|H]]  SI
fH  [[w:Henry (unit)|H]]  SI
aH  [[w:Henry (unit)|H]]  SI
zH  [[w:Henry (unit)|H]]  SI
yH  [[w:Henry (unit)|H]]  SI

A  [[w:Ampere|A]]  SI
YA  [[w:Ampere|A]]  SI
ZA  [[w:Ampere|A]]  SI
EA  [[w:Ampere|A]]  SI
PA  [[w:Ampere|A]]  SI
TA  [[w:Ampere|A]]  SI
GA  [[w:Ampere|A]]  SI
MA  [[w:Ampere|A]]  SI
kA  [[w:Ampere|A]]  SI
hA  [[w:Ampere|A]]  SI
daA  [[w:Ampere|A]]  SI
dA  [[w:Ampere|A]]  SI
cA  [[w:Ampere|A]]  SI
mA  [[w:Ampere|A]]  SI
µA  [[w:Ampere|A]]  SI
uA  [[w:Ampere|A]]  SI
nA  [[w:Ampere|A]]  SI
pA  [[w:Ampere|A]]  SI
fA  [[w:Ampere|A]]  SI
aA  [[w:Ampere|A]]  SI
zA  [[w:Ampere|A]]  SI
yA  [[w:Ampere|A]]  SI

V  [[w:Volt|V]]  SI
YV  [[w:Volt|V]]  SI
ZV  [[w:Volt|V]]  SI
EV  [[w:Volt|V]]  SI
PV  [[w:Volt|V]]  SI
TV  [[w:Volt|V]]  SI
GV  [[w:Volt|V]]  SI
MV  [[w:Volt|V]]  SI
kV  [[w:Volt|V]]  SI
hV  [[w:Volt|V]]  SI
daV  [[w:Volt|V]]  SI
dV  [[w:Volt|V]]  SI
cV  [[w:Volt|V]]  SI
mV  [[w:Volt|V]]  SI
µV  [[w:Volt|V]]  SI
uV  [[w:Volt|V]]  SI
nV  [[w:Volt|V]]  SI
pV  [[w:Volt|V]]  SI
fV  [[w:Volt|V]]  SI
aV  [[w:Volt|V]]  SI
zV  [[w:Volt|V]]  SI
yV  [[w:Volt|V]]  SI

VA  [[w:Volt-ampere|VA]]  SI
YVA  [[w:Volt-ampere|VA]]  SI
ZVA  [[w:Volt-ampere|VA]]  SI
EVA  [[w:Volt-ampere|VA]]  SI
PVA  [[w:Volt-ampere|VA]]  SI
TVA  [[w:Volt-ampere|VA]]  SI
GVA  [[w:Volt-ampere|VA]]  SI
MVA  [[w:Volt-ampere|VA]]  SI
kVA  [[w:Volt-ampere|VA]]  SI
hVA  [[w:Volt-ampere|VA]]  SI
daVA  [[w:Volt-ampere|VA]]  SI
dVA  [[w:Volt-ampere|VA]]  SI
cVA  [[w:Volt-ampere|VA]]  SI
mVA  [[w:Volt-ampere|VA]]  SI
µVA  [[w:Volt-ampere|VA]]  SI
uVA  [[w:Volt-ampere|VA]]  SI
nVA  [[w:Volt-ampere|VA]]  SI
pVA  [[w:Volt-ampere|VA]]  SI
fVA  [[w:Volt-ampere|VA]]  SI
aVA  [[w:Volt-ampere|VA]]  SI
zVA  [[w:Volt-ampere|VA]]  SI
yVA  [[w:Volt-ampere|VA]]  SI

Ω  [[w:Ohm|Ω]]  SI

YΩ.m  [[w:Electrical resistivity and conductivity#Definition|YΩ&sdot;m]]  1e24
ZΩ.m  [[w:Electrical resistivity and conductivity#Definition|ZΩ&sdot;m]]  1e21
EΩ.m  [[w:Electrical resistivity and conductivity#Definition|EΩ&sdot;m]]  1e18
PΩ.m  [[w:Electrical resistivity and conductivity#Definition|PΩ&sdot;m]]  1e15
TΩ.m  [[w:Electrical resistivity and conductivity#Definition|TΩ&sdot;m]]  1e12
GΩ.m  [[w:Electrical resistivity and conductivity#Definition|GΩ&sdot;m]]  1e9
MΩ.m  [[w:Electrical resistivity and conductivity#Definition|MΩ&sdot;m]]  1e6
kΩ.m  [[w:Electrical resistivity and conductivity#Definition|kΩ&sdot;m]]  1e3
Ω.m  [[w:Electrical resistivity and conductivity#Definition|Ω&sdot;m]]    1
mΩ.m  [[w:Electrical resistivity and conductivity#Definition|mΩ&sdot;m]]  1e-3
µΩ.m  [[w:Electrical resistivity and conductivity#Definition|µΩ&sdot;m]]  1e-6
uΩ.m  [[w:Electrical resistivity and conductivity#Definition|µΩ&sdot;m]]  1e-6
nΩ.m  [[w:Electrical resistivity and conductivity#Definition|nΩ&sdot;m]]  1e-9
pΩ.m  [[w:Electrical resistivity and conductivity#Definition|pΩ&sdot;m]]  1e-12
fΩ.m  [[w:Electrical resistivity and conductivity#Definition|fΩ&sdot;m]]  1e-15
aΩ.m  [[w:Electrical resistivity and conductivity#Definition|aΩ&sdot;m]]  1e-18
zΩ.m  [[w:Electrical resistivity and conductivity#Definition|zΩ&sdot;m]]  1e-21
yΩ.m  [[w:Electrical resistivity and conductivity#Definition|yΩ&sdot;m]]  1e-24

R  [[w:Rayleigh (unit)|R]]  SI

G  [[w:Gauss (unit)|G]]  SI
aG  [[w:Attogauss|G]]  SI
cG  [[w:Centigauss|G]]  SI
daG  [[w:Decagauss|G]]  SI
dG  [[w:Decigauss|G]]  SI
EG  [[w:Exagauss|G]]  SI
fG  [[w:Femtogauss|G]]  SI
GG  [[w:Gigagauss|G]]  SI
hG  [[w:Hectogauss|G]]  SI
kG  [[w:Kilogauss|G]]  SI
MG  [[w:Megagauss|G]]  SI
mG  [[w:Milligauss|G]]  SI
uG  [[w:Microgauss|G]]  SI
µG  [[w:Microgauss|G]]  SI
nG  [[w:Nanogauss|G]]  SI
PG  [[w:Petagauss|G]]  SI
pG  [[w:Picogauss|G]]  SI
TG  [[w:Teragauss|G]]  SI
yG  [[w:Yoctogauss|G]]  SI
YG  [[w:Yottagauss|G]]  SI
zG  [[w:Zeptogauss|G]]  SI
ZG  [[w:Zettagauss|G]]  SI

T  [[w:Tesla (unit)|T]]  SI
aT  [[w:Attotesla|T]]  SI
cT  [[w:Centitesla|T]]  SI
daT  [[w:Decatesla|T]]  SI
dT  [[w:Decitesla|T]]  SI
ET  [[w:Exatesla|T]]  SI
fT  [[w:Femtotesla|T]]  SI
GT  [[w:Gigatesla|T]]  SI
hT  [[w:Hectotesla|T]]  SI
kT  [[w:Kilotesla|T]]  SI
MT  [[w:Megatesla|T]]  SI
mT  [[w:Millitesla|T]]  SI
uT  [[w:Microtesla|T]]  SI
µT  [[w:Microtesla|T]]  SI
nT  [[w:Nanotesla|T]]  SI
PT  [[w:Petatesla|T]]  SI
pT  [[w:Picotesla|T]]  SI
TT  [[w:Teratesla|T]]  SI
yT  [[w:Yoctotesla|T]]  SI
YT  [[w:Yottatesla|T]]  SI
zT  [[w:Zeptotesla|T]]  SI
ZT  [[w:Zettatesla|T]]  SI

== Astrophysics ==
au  [[w:Astronomical unit|au]]
c  [[w:Speed of light|''c'']]
ly  [[w:Light-year|ly]]
Earth mass  [[w:Earth mass|''M''<sub>🜨</sub>]]
Earth radius  [[w:Earth radius|''R''<sub>🜨</sub>]]
M_Earth  [[w:Earth mass|''M''<sub>🜨</sub>]]
R_Earth  [[w:Earth radius|''R''<sub>🜨</sub>]]
M+  [[w:Earth mass|''M''<sub>🜨</sub>]]
R+  [[w:Earth radius|''R''<sub>🜨</sub>]]
Jupiter mass  [[w:Jupiter mass|''M''<sub>J</sub>]]
Jupiter radius  [[w:Jupiter radius|''R''<sub>J</sub>]]
Jy  [[w:Jansky|Jy]]
M_Jupiter  [[w:Jupiter mass|''M''<sub>J</sub>]]
R_Jupiter  [[w:Jupiter radius|''R''<sub>J</sub>]]
Solar mass  [[w:Solar mass|''M''<sub>&#x2609;</sub>]]
solar mass  [[w:Solar mass|''M''<sub>&#x2609;</sub>]]
M_Solar  [[w:Solar mass|''M''<sub>&#x2609;</sub>]]
M_solar  [[w:Solar mass|''M''<sub>&#x2609;</sub>]]
R_Solar  [[w:Solar radius|''R''<sub>&#x2609;</sub>]]
R_solar  [[w:Solar radius|''R''<sub>&#x2609;</sub>]]
Solar radius  [[w:Solar radius|''R''<sub>&#x2609;</sub>]]
solar radius  [[w:Solar radius|''R''<sub>&#x2609;</sub>]]
Solar luminosity  [[w:Solar luminosity|''L''<sub>&#x2609;</sub>]]
solar luminosity  [[w:Solar luminosity|''L''<sub>&#x2609;</sub>]]
L_solar  [[w:Solar luminosity|''L''<sub>&#x2609;</sub>]]
L_Solar  [[w:Solar luminosity|''L''<sub>&#x2609;</sub>]]
Lo  [[w:Solar luminosity|''L''<sub>&#x2609;</sub>]]
pc2  [[w:Parsec|pc<sup>2</sup>]]
pc3  [[w:Parsec|pc<sup>3</sup>]]
kpc2  [[w:Parsec#Parsecs and kiloparsecs|kpc<sup>2</sup>]]
kpc3  [[w:Parsec#Parsecs and kiloparsecs|kpc<sup>3</sup>]]
kpc  [[w:Parsec#Parsecs and kiloparsecs|kpc]]
Mpc2  [[w:Parsec#Megaparsecs and gigaparsecs|Mpc<sup>2</sup>]]
Mpc3  [[w:Parsec#Megaparsecs and gigaparsecs|Mpc<sup>3</sup>]]
Mpc  [[w:Parsec#Megaparsecs and gigaparsecs|Mpc]]
Gpc2  [[w:Parsec#Megaparsecs and gigaparsecs|Gpc<sup>2</sup>]]
Gpc3  [[w:Parsec#Megaparsecs and gigaparsecs|Gpc<sup>3</sup>]]
Gpc  [[w:Parsec#Megaparsecs and gigaparsecs|Gpc]]

== Nuclear physics and chemistry ==
cm-1  [[w:Wavenumber|cm<sup>−1</sup>]]
u  [[w:Unified atomic mass unit|u]]
osmol  [[w:Osmole (unit)|osmol]]
Osm  [[w:Osmole (unit)|Osm]]
M  [[w:Molarity|M]]
TM  [[w:Molarity|M]]  SI
GM  [[w:Molarity|M]]  SI
MM  [[w:Molarity|M]]  SI
kM  [[w:Molarity|M]]  SI
hM  [[w:Molarity|M]]  SI
daM  [[w:Molarity|M]]  SI
dM  [[w:Molarity|M]]  SI
cM  [[w:Molarity|M]]  SI
mM  [[w:Molarity|M]]  SI
uM  [[w:Molarity|M]]  1e-6
nM  [[w:Molarity|M]]  SI
pM  [[w:Molarity|M]]  SI
kg.mol-1  [[w:Molar mass|kg&sdot;mol<sup>−1</sup>]]
kg/mol  [[w:Molar mass|kg/mol]]
g.mol-1  [[w:Molar mass|g&sdot;mol<sup>−1</sup>]]
g/mol  [[w:Molar mass|g/mol]]
eV/c2  [[w:Electronvolt#Mass|eV/''c''<sup>2</sup>]]
keV/c2  [[w:Electronvolt#Mass|keV/''c''<sup>2</sup>]]
MeV/c2  [[w:Electronvolt#Mass|MeV/''c''<sup>2</sup>]]
GeV/c2  [[w:Electronvolt#Mass|GeV/''c''<sup>2</sup>]]
TeV/c2  [[w:Electronvolt#Mass|TeV/''c''<sup>2</sup>]]
eV  [[w:Electronvolt|eV]]
meV  [[w:Electronvolt|meV]]
keV  [[w:Electronvolt|keV]]
MeV  [[w:Electronvolt|MeV]]
GeV  [[w:Electronvolt|GeV]]
TeV  [[w:Electronvolt|TeV]]
mol-1  [[w:Avogadro constant|mol<sup>−1</sup>]]
J.mol-1  [[w:Joule per mole|J&sdot;mol<sup>−1</sup>]]
J/mol  [[w:Joule per mole|J/mol]]
kJ.mol-1  [[w:Joule per mole|kJ&sdot;mol<sup>−1</sup>]]
kJ/mol  [[w:Joule per mole|kJ/mol]]
MJ.mol-1  [[w:Joule per mole|MJ&sdot;mol<sup>−1</sup>]]
MJ/mol  [[w:Joule per mole|MJ/mol]]
GJ.mol-1  [[w:Joule per mole|GJ&sdot;mol<sup>−1</sup>]]
GJ/mol  [[w:Joule per mole|GJ/mol]]
TJ.mol-1  [[w:Joule per mole|TJ&sdot;mol<sup>−1</sup>]]
TJ/mol  [[w:Joule per mole|TJ/mol]]
μB  [[w:Bohr magneton|''μ''<sub>B</sub>]]

== Numbers and phrases ==
pp  [[w:Page (paper)|pp]]
ppb  [[w:Parts per billion|ppb]]  1e-9
ppm  [[w:Parts per million|ppm]]  1e-6
billiard  [[w:Orders of magnitude (numbers)#1015|billiard]]  1e15
billion  [[w:1,000,000,000|billion]]  1e9
billionth  [[w:1,000,000,000|billionth]]  1e-9
billionths  [[w:1,000,000,000|billionths]]  1e-9
decilliard  [[w:Orders of magnitude (numbers)#1063|decilliard]]  1e63
decillion  [[w:Orders of magnitude (numbers)#1033|decillion]]  1e33
decillionth  [[w:Orders of magnitude (numbers)#1033|decillionth]]  1e-33
decillionths  [[w:Orders of magnitude (numbers)#1033|decillionths]]  1e-33
milliard  [[w:1,000,000,000|milliard]]  1e9
million  [[w:Million|million]]  1e6
millionth  [[w:Million|millionth]]  1e-6
millionths  [[w:Million|millionths]]  1e-6
nonilliard  [[w:Orders of magnitude (numbers)#1057|nonilliard]]  1e57
nonillion  [[w:Orders of magnitude (numbers)#1030|nonillion]]  1e30
nonillionth  [[w:Orders of magnitude (numbers)#1030|nonillionth]]  1e-30
nonillionths  [[w:Orders of magnitude (numbers)#1030|nonillionths]]  1e-30
octilliard  [[w:Orders of magnitude (numbers)#1051|octilliard]]  1e51
octillion  [[w:Orders of magnitude (numbers)#1027|octillion]]  1e27
octillionth  [[w:Orders of magnitude (numbers)#1027|octillionth]]  1e-27
octillionths  [[w:Orders of magnitude (numbers)#1027|octillionths]]  1e-27
quadrilliard  [[w:Orders of magnitude (numbers)#1027|quadrilliard]]  1e27
quadrillion  [[w:Orders of magnitude (numbers)#1015|quadrillion]]  1e15
quadrillionth  [[w:Orders of magnitude (numbers)#1015|quadrillionth]]  1e-15
quadrillionths  [[w:Orders of magnitude (numbers)#1015|quadrillionths]]  1e-15
quintilliard  [[w:Orders of magnitude (numbers)#1033|quintilliard]]  1e33
quintillion  [[w:Orders of magnitude (numbers)#1018|quintillion]]  1e18
quintillionth  [[w:Orders of magnitude (numbers)#1018|quintillionth]]  1e-18
quintillionths  [[w:Orders of magnitude (numbers)#1018|quintillionths]]  1e-18
septilliard  [[w:Orders of magnitude (numbers)#1045|septilliard]]  1e45
septillion  [[w:Orders of magnitude (numbers)#1024|septillion]]  1e24
septillionth  [[w:Orders of magnitude (numbers)#1024|septillionth]]  1e-24
septillionths  [[w:Orders of magnitude (numbers)#1024|septillionths]]  1e-24
sextilliard  [[w:Orders of magnitude (numbers)#1039|sextilliard]]  1e39
sextillion  [[w:Orders of magnitude (numbers)#1021|sextillion]]  1e21
sextillionth  [[w:Orders of magnitude (numbers)#1021|sextillionth]]  1e-21
sextillionths  [[w:Orders of magnitude (numbers)#1021|sextillionths]]  1e-21
trilliard  [[w:Orders of magnitude (numbers)#1021|trilliard]]  1e21
trillion  [[w:Orders of magnitude (numbers)#1012|trillion]]  1e12
trillionth  [[w:Orders of magnitude (numbers)#1012|trillionth]]  1e-12
trillionths  [[w:Orders of magnitude (numbers)#1012|trillionths]]  1e-12

== Angles ==
%                  %                                     Percent                                ANGLE   0.01
percent            %                                     Percent                                ANGLE   0.01
per cent           %                                     Percent                                ANGLE   0.01
‰                  ‰                                     Per mil                                ANGLE   1e-3
per mil            ‰                                     Per mil                                ANGLE   1e-3
per mill           ‰                                     Per mil                                ANGLE   1e-3
per mille          ‰                                     Per mil                                ANGLE   1e-3
permil             ‰                                     Per mil                                ANGLE   1e-3
permill            ‰                                     Per mil                                ANGLE   1e-3
permille           ‰                                     Per mil                                ANGLE   1e-3
°                  °                                     Degree (angle)                         ANGLE   pi/180
deg                °                                     Degree (angle)                         ANGLE   pi/180
degree             °                                     Degree (angle)                       NOSPACE   pi/180    -- for a degree symbol that does not repeat
'                  ′                                     Minute of arc                          ANGLE   pi/10800
′                  ′                                     Minute of arc                          ANGLE   pi/10800
arcmin             ′                                     Minute of arc                          ANGLE   pi/10800
arcminute          ′                                     Minute of arc                          ANGLE   pi/10800
"                  ″                                     Second of arc                          ANGLE   pi/648000
″                  ″                                     Second of arc                          ANGLE   pi/648000
arcsec             ″                                     Second of arc                          ANGLE   pi/648000
arcsecond          ″                                     Second of arc                          ANGLE   pi/648000
mas  [[w:Milliarcsecond|mas]]  pi/648000000

]=]

-- If val has "|long scale=on" the following definitions are used
-- (then, if not found here, the normal definitions are used).
-- Unit code  [[w:Link|Symbol]]  Flags/Scale
local builtin_units_long_scale = [=[

== Long scale numbers and phrases ==
billion  [[w:Orders of magnitude (numbers)#1012|billion]]  1e12
billionth  [[w:Orders of magnitude (numbers)#1012|billionth]]  1e-12
billionths  [[w:Orders of magnitude (numbers)#1012|billionths]]  1e-12
decillion  [[w:Orders of magnitude (numbers)#1060|decillion]]  1e60
decillionth  [[w:Orders of magnitude (numbers)#1060|decillionth]]  1e-60
decillionths  [[w:Orders of magnitude (numbers)#1060|decillionths]]  1e-60
nonillion  [[w:Orders of magnitude (numbers)#1054|nonillion]]  1e54
nonillionth  [[w:Orders of magnitude (numbers)#1054|nonillionth]]  1e-54
nonillionths  [[w:Orders of magnitude (numbers)#1054|nonillionths]]  1e-54
octillion  [[w:Orders of magnitude (numbers)#1048|octillion]]  1e48
octillionth  [[w:Orders of magnitude (numbers)#1048|octillionth]]  1e-48
octillionths  [[w:Orders of magnitude (numbers)#1048|octillionths]]  1e-48
quadrillion  [[w:Orders of magnitude (numbers)#1024|quadrillion]]  1e24
quadrillionth  [[w:Orders of magnitude (numbers)#1024|quadrillionth]]  1e-24
quadrillionths  [[w:Orders of magnitude (numbers)#1024|quadrillionths]]  1e-24
quintillion  [[w:Orders of magnitude (numbers)#1030|quintillion]]  1e30
quintillionth  [[w:Orders of magnitude (numbers)#1030|quintillionth]]  1e-30
quintillionths  [[w:Orders of magnitude (numbers)#1030|quintillionths]]  1e-30
septillion  [[w:Orders of magnitude (numbers)#1042|septillion]]  1e42
septillionth  [[w:Orders of magnitude (numbers)#1042|septillionth]]  1e-42
septillionths  [[w:Orders of magnitude (numbers)#1042|septillionths]]  1e-42
sextillion  [[w:Orders of magnitude (numbers)#1036|sextillion]]  1e36
sextillionth  [[w:Orders of magnitude (numbers)#1036|sextillionth]]  1e-36
sextillionths  [[w:Orders of magnitude (numbers)#1036|sextillionths]]  1e-36
trillion  [[w:Orders of magnitude (numbers)#1018|trillion]]  1e18
trillionth  [[w:Orders of magnitude (numbers)#1018|trillionth]]  1e-18
trillionths  [[w:Orders of magnitude (numbers)#1018|trillionths]]  1e-18

]=]

return { builtin_units = builtin_units, builtin_units_long_scale = builtin_units_long_scale }
