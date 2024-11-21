extensions[nw]

turtles-own [
  infected?
  checked
]

to setup
  clear-all
  ask patches [set pcolor white]
  create-turtles num-nodes [
    set color blue
    set shape "circle"
  ]

  reset-ticks
end

;to random-graph
;  refresh
;  create-turtles num-nodes [
;    set color blue
;    set shape "circle"
;    set checked false
;  ]
;  ask turtles [
;    let this-turtle self
;    ask other turtles with [link-neighbor? myself = false] [
;      if random-float 1 < p and not checked [
;        create-link-with this-turtle
;      ]
;    ]
;    set checked true
;  ]
;
;  layout-circle turtles 15
;  tick
;end

;to watts-strogatz
;  refresh
;  create-turtles num-nodes [
;    set color blue
;    set shape "circle"
;  ]
;  let max-who 0
;  let min-who [who] of one-of turtles
;  ask turtles [
;    let this-turtle self
;    ask turtles with [who = [who] of this-turtle + 1] [
;      create-link-with this-turtle
;    ]
;    set max-who max (list who max-who)
;    set min-who min (list who min-who)
;  ]
;  ask turtles with [who = max-who] [
;    let this-turtle self
;    ask turtles with [who = min-who] [
;      create-link-with this-turtle
;    ]
;  ]
;  layout-circle turtles 15
;  tick
;end

to compare-networks
  refresh
  nw:generate-random turtles links num-nodes p [ set color red ]
  nw:generate-watts-strogatz turtles links num-nodes 2 p [
    fd 10
    set color blue
  ]
  nw:generate-preferential-attachment turtles links num-nodes 1 [ set color green ]
  layout-circle turtles 15
  tick
end

to compare-networks-with-n
  refresh
  reset-ticks
  set num-nodes 5
  while [num-nodes < 100] [
    clear-turtles
    nw:generate-random turtles links num-nodes p [ set color red ]
    set-current-plot "apl"
    set-current-plot-pen "random"
    ifelse nw:mean-path-length = False [
      plotxy ticks 0
    ] [
      plotxy ticks nw:mean-path-length
    ]
    set-current-plot "clustering"
    set-current-plot-pen "random"
    plotxy ticks mean [ nw:clustering-coefficient ] of turtles

    clear-turtles
    nw:generate-watts-strogatz turtles links num-nodes small-world-initial-neighbors small-world-rewiring-p [
      fd 10
      set color blue
    ]
    set-current-plot "apl"
    set-current-plot-pen "small-world"
    ifelse nw:mean-path-length = False [
      plotxy ticks 0
    ] [
      plotxy ticks nw:mean-path-length
    ]
    set-current-plot "clustering"
    set-current-plot-pen "small-world"
    plotxy ticks mean [ nw:clustering-coefficient ] of turtles

    clear-turtles
    nw:generate-preferential-attachment turtles links num-nodes barabasi-edges-per-node [ set color green ]
    set-current-plot "apl"
    set-current-plot-pen "barabasi"
    ifelse nw:mean-path-length = False [
      plotxy ticks 0
    ] [
      plotxy ticks nw:mean-path-length
    ]
    set-current-plot "clustering"
    set-current-plot-pen "barabasi"
    plotxy ticks mean [ nw:clustering-coefficient ] of turtles

    set num-nodes num-nodes + 1
    tick
  ]
  layout-circle turtles 15
  tick
end

to layoutspring
  repeat 30 [layout-spring turtles links 0.2 5 1]
end

to complete-graph
  refresh
    ask  turtles [
    if count other turtles with [link-neighbor? myself = false] > 0 [
     create-links-with other turtles with [link-neighbor? myself = false]
    ]
  ]
  layout-circle turtles 15
  tick

end

to launch-virus
  ask turtles [
    set color blue
    set infected? false]

  ask one-of turtles [
    set color red
    set infected? true
  ]
end

to make-step-simple

  ask turtles [
    if count link-neighbors with [color = red] > 0 [
      repeat count link-neighbors with [color = red] [
        if random-float 1 < transmission [
          set infected? true
        ]
      ]
    ]
  ]

  ask turtles [
    if infected? = true [set color red]
  ]
  tick
end

to make-step-complex
  ask turtles [
    if count link-neighbors with [color = red] > 0 [
      if count link-neighbors with [color = red] / count link-neighbors > threshold [
          set color red
        ]
      ]
    ]
  tick
end

to refresh
  clear-all
  reset-ticks
  ask patches [set pcolor white]
end

to friendship-paradox
  ask turtles [
    let count-neighbors-friends mean [ count link-neighbors ] of link-neighbors
    let count-friends count link-neighbors
    ifelse count-friends < count-neighbors-friends [
      let how-bad 19.9 - count-friends / count-neighbors-friends * 4
      set color how-bad
    ] [
      let how-good 69.9 - count-neighbors-friends / count-friends * 4
      set color how-good
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
237
12
943
719
-1
-1
13.7
1
10
1
1
1
0
0
0
1
-25
25
-25
25
0
0
1
ticks
30.0

BUTTON
32
32
98
65
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
4
84
176
117
num-nodes
num-nodes
0
100
83.0
1
1
NIL
HORIZONTAL

SLIDER
4
215
176
248
p
p
0
1
0.1
0.01
1
NIL
HORIZONTAL

PLOT
955
16
1463
316
Degree distribution
NIL
NIL
0.0
10.0
0.0
12.0
true
true
"" ""
PENS
"random" 1.0 1 -955883 true "" "histogram [count link-neighbors] of turtles with [color = red]"
"small-world" 1.0 1 -13345367 true "" "histogram [count link-neighbors] of turtles with [color = blue]"
"barabasi" 1.0 1 -10899396 true "" "histogram [count link-neighbors] of turtles with [color = green]"

MONITOR
969
346
1150
391
NIL
count links
17
1
11

BUTTON
5
466
115
499
NIL
layoutspring
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
969
393
1149
438
NIL
nw:mean-path-length
2
1
11

BUTTON
23
569
155
602
NIL
complete-graph
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
969
439
1149
484
mean clustering
mean [ nw:clustering-coefficient ] of turtles
2
1
11

BUTTON
958
698
1069
731
NIL
launch-virus
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
958
732
1130
765
transmission
transmission
0
1
1.0
0.01
1
NIL
HORIZONTAL

BUTTON
1070
699
1214
732
NIL
make-step-simple
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
958
766
1162
924
infected-healthy
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"infected" 1.0 0 -2674135 true "" "plot count turtles with [color = red]"
"healthy" 1.0 0 -13345367 true "" "plot count turtles with [color = blue]"

BUTTON
2
181
149
218
random
refresh\nnw:generate-random turtles links num-nodes p [ set color orange ]\nlayout-circle turtles 15
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
3
165
153
183
nw extension
11
0.0
1

BUTTON
3
121
85
154
refresh
clear-all\nreset-ticks\nask patches [set pcolor white]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
3
250
152
285
small-world
refresh\nnw:generate-watts-strogatz turtles links num-nodes small-world-initial-neighbors small-world-rewiring-p [ fd 10 ]\nask turtles [set color blue]\nlayout-circle turtles 15\ntick
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
122
465
225
498
layoutcircle
layout-circle turtles 15
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
4
359
155
395
barabasi
refresh\nnw:generate-preferential-attachment turtles links num-nodes barabasi-edges-per-node [ set color green ]\nlayout-circle turtles 15\ntick
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
23
535
86
568
ring
nw:generate-ring turtles links num-nodes [ set color blue ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
97
537
163
570
wheel
nw:generate-wheel turtles links num-nodes [ set color blue ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1215
699
1372
732
NIL
make-step-complex
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1140
732
1312
765
threshold
threshold
0
1
0.45
0.01
1
NIL
HORIZONTAL

BUTTON
951
310
1103
343
NIL
compare-networks
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1490
18
1867
304
apl
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"random" 1.0 2 -955883 true "" ""
"small-world" 1.0 2 -13345367 true "" ""
"barabasi" 1.0 2 -10899396 true "" ""

BUTTON
1490
286
1800
319
compare networks with different n of nodes
compare-networks-with-n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
2
287
203
320
small-world-initial-neighbors
small-world-initial-neighbors
0
20
2.0
1
1
NIL
HORIZONTAL

SLIDER
3
322
201
355
small-world-rewiring-p
small-world-rewiring-p
0
1
0.1
0.05
1
NIL
HORIZONTAL

SLIDER
3
400
220
433
barabasi-edges-per-node
barabasi-edges-per-node
0
20
2.0
1
1
NIL
HORIZONTAL

PLOT
1490
317
1868
585
clustering
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"random" 1.0 0 -2674135 true "" ""
"small-world" 1.0 0 -13345367 true "" ""
"barabasi" 1.0 0 -10899396 true "" ""

TEXTBOX
958
680
1108
698
some stuff from prac
12
0.0
1

BUTTON
965
549
1244
582
n-friends/mean-n-friends-of-neighbors
friendship-paradox
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
967
515
1117
549
the greener - the better\nthe redder - the worse
12
0.0
1

MONITOR
965
587
1082
632
number of green
count turtles with [color > 60 and color < 70]
0
1
11

MONITOR
1082
587
1184
632
number of red
count turtles with [color > 10 and color < 20]
17
1
11

MONITOR
965
634
1058
679
mean friends
mean [count link-neighbors] of turtles
2
1
11

MONITOR
1060
635
1234
680
mean friends of neighbors
mean [mean [ count link-neighbors ] of link-neighbors] of turtles
2
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
