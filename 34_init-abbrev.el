;; -*- coding: utf-8; -*-


(define-abbrev-table
  'global-abbrev-table
  `(
    ;; math/unicode symbols
    ("8in" "∈")
    ("8nin" "∉")
    ("8inf" "∞")
    ("8luv" "♥")
    ("8smly" "☺")
    ("8rh" "☛")
    ("8si" "∑")
    ("8in" "⚠")
    ("8ne1" "⛔")
    ("8ne2" "🚫")
    ("8there4" "∴")
    ("8th" "⚡")
    ("8empty"  "∅")
    ("8because" "∵")
    ("8degree" "°")
    ( "8e" "ℯ" )
    ("8xor" "⊻")
    ("8nand" "⊼")
    ("8nor" "⊽")
    ("8ratiopp" "∝")
    ("8partial" "∂")
("8forall"       "∀")
("8exist"        "∃")
("8not"          "¬")
("8and"          "∧")
("8or"           "∨")
("8nand"         "⋀")
("8nor"          "⋁")
("8lceil"        "⌈")
("8rceil"        "⌉")
("8lfloor"       "⌊")
("8rfloor"       "⌋")
("8inc"          "∆")
("8crossproduct" "⨯")
("8conmat"       "⊹")
("8nsum"         "∑")
("8almost"        "≈")
("8ident"         "≡")
("8ge"            "≧")
("8le"            "≦")
("8join"          "⨝")
("8nintersection" "⋂")
("8nunion"        "⋃")
("8union"         "∪")
("8intersection"  "∩")
("8subset"        "⊂")
("8superset"      "⊃")
("8elem"          "∈")
("8contain"       "∋")
("8alef"          "ℵ")
("8hmul"          "✖")
("8div"           "÷")
("8pi"            "π")
("8theta"         "θ")
("8lambda"        "λ")
("8mu"            "μ")
("8DELTA"         "Δ")
("8LAMBDA"        "Λ")
("8XI"            "Ξ")
("8PI"            "Π")
("8PHI"           "Φ")
("8PSI"           "Ψ")
("8OMETA"         "Ω")
("8nabla"         "∇")
("8ohm"           "Ω")
    
    ;; ("8ts")
    ;; ("8ts1" ) 
    
    ("8tri" "▲")
    ("8tril" "◀")
    ("8trir" "▶")
    ("8trid" "▼")

    ("8square" "■")
    ("8circle" "●")
    ("8diamond" "◆")


    ( "8bio" "☣" )
    ("8recycle" "♲")
    ("8shift" "⇧")
    ("8tab" "↹")
    ("8watch" "⌚")
    ("8hourglass" "⧖") ;;⧗ ⌛ ⏳ ⧗ ⧖ 
    ("8cursor" "⌖")
    ("8ibeam" "⌶")
    ("8wifi" "📶")
    ("8cross" "✚")
    
    ("8hyper" "✦")
    ("8enter" "↵")

    ;; star
    ("8s1" "★")
    ("8s2" "☆")
    ("8s3" "⚝")
    ("8s4" "✡")

    ;; hexagrams
    ("8h1"  "⎈" ) 
    ("8h2"  "✽" ) 
    ("8h3"  "✲" ) 
    ("8h4"  "✱" ) 
    ("8h5"  "✻" ) 
    ("8h6"  "✼" ) 
    ("8h7"  "✽" ) 
    ("8h8"  "✡" ) 
    ("8h9"  "✾" ) 
    ("8h10"  "✿" ) 
    ("8h11"  "❀" ) 
    ("8h12"  "❁" ) 
    ("8h13"  "❂" ) 
    ("8h14"  "❃" ) 
    ("8h15"  "❄" ) 
    ("8h16"  "❅" ) 
    ("8h17"  "❆" ) 
    ("8h18"  "❇" ) 
    ;; circles
    ("8c1"  "○")
    ("8c2"  "☉")
    ("8c3"  "◎")
    ("8c4"  "◉")
    ("8c5"  "○")
    ("8c6"  "◌")
    ("8c7"  "◎")
    ("8c8"  "●")
    ("8c9"  "◦")
    ("8c10"  "◯")
    ("8c11"  "⚪")
    ("8c12"  "⚫")
    ("8c13"  "⚬")
    ("8c14"  "❍")
    ("8c15"  "￮")
    ("8c16"  "⊙")
    ("8c17"  "⊚")
    ("8c18"  "⊛")
    ("8c19"  "∙")
    ("8c20"  "∘")
    ;; special circles
    ("8sc1"  "◐") 
    ("8sc2"  "◑") 
    ("8sc3"  "◒") 
    ("8sc4"  "◓") 
    ("8sc5"  "◴") 
    ("8sc6"  "◵") 
    ("8sc7"  "◶") 
    ("8sc8"  "◷") 
    ("8sc9"  "⚆") 
    ("8sc10"  "⚇") 
    ("8sc11"  "⚈") 
    ("8sc12"  "⚉") 
    ("8sc13"  "♁") 
    ("8sc14"  "⊖") 
    ("8sc15"  "⊗") 
    ("8sc16"  "⊘") 
    ;; crosses

    ("8cr1"  "✙")
    ("8cr2"  "♱")
    ("8cr3"  "♰")
    ("8cr4"  "☥")
    ("8cr5"  "✞")
    ("8cr6"  "✟")
    ("8cr7"  "✝")
    ("8cr8"  "†")
    ("8cr9"  "✠")
    ("8cr10"  "✚")
    ("8cr11"  "✜")
    ("8cr12"  "✛")
    ("8cr13"  "✢")
    ("8cr14"  "✣")
    ("8cr15"  "✤")
    ("8cr16"  "✥")

    ;; poker sybmols
    ("8p1"  "♠")
    ("8p2"  "♣")
    ("8p3"  "♥")
    ("8p4"  "♦")
    ("8p5"  "♤")
    ("8p6"  "♧")
    ("8p7"  "♡")
    ("8p8"  "♢")
    ;; special symbols

    ("8ss1"  "▶")
    ("8ss2"  "◈")
    ("8ss3"  "◀")
    ("8ss4"  "☀")
    ("8ss5"  "♼")
    ("8ss6"  "☼")
    ("8ss7"  "☾")
    ("8ss8"  "☽")
    ("8ss9"  "☣")
    ("8ss10"  "§")
    ("8ss11"  "¶")
    ("8ss12"  "‡")
    ("8ss13"  "※")
    ("8ss14"  "✕")
    ("8ss15"  "△")
    ("8ss16"  "◇")


    ( "8dollar" "$")
    ( "8cent" "¢")
    ( "8euro" "€" )
    ( "8yen" "¥")
    ( "8pound" "£")
    ( "8cedi" "₵")
    ( "8colon" "₡")
    ( "8austral" "₳")
    ( "8baht" "฿")
    ( "8cruzeiro" "₢")
    ( "8dong" "₫")
    ( "8bengali" "৳")
    ( "8drachma" "₯")
    ( "8frac"  "₣")
    ( "8guarani" "₲")
    ( "8hryvnia" "₴")
    ( "8kip" "₭")
    ( "8mill" "₥")
    ( "8naira" "₦")
    ( "8peseta" "₧")
    ( "8peso" "₱")
    ( "8german"  "₰")
    ( "8rupee" "₨")
    ( "8tugrik" "₮")
    ( "8won" "₩")

    ( "8cs" "⍟")

    ("8a1" "←")
    ("8a2" "→")
    ("8a3" "↑")
    ("8a4" "↓")
    ("8a5" "◀")
    ("8a6" "▶")
    ("8a7" "▲")
    ("8a8" "▼")
    ("8a9" "◁")
    ("8a10" "▷")
    ("8a11" "△")
    ("8a12" "▽")
    ("8a13" "⇦" )
    ("8a14" "⇨" )
    ("8a15" "⇧" )
    ("8a16" "⇩" )
    ("8a17" "⬅" )
    ("8a18" "➡" )
    ("8a19" "⬆" )
    ("8a20" "⬇" )

( "8fence1" "⦀")
( "8fence2" "⦙")
( "8fence3" "⦚")
( "8fence4" "⧘")
( "8fence5" "⧙")
( "8fence6" "⧚")
( "8fence7" "⧛")
("8X" "⤬") 

    

,@(-map-indexed (lambda (index ch8) (list (format "81c%d"  index) ch8)) '("⓪" "①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧" "⑨" "⑩" "⑪" "⑫" "⑬" "⑭" "⑮" "⑯" "⑰" "⑱" "⑲" "⑳"))
,@(-map-indexed (lambda (index ch8) (list (format "8c%d" (+ 1 index)) ch8)) '( "⓵" "⓶" "⓷" "⓸" "⓹" "⓺" "⓻" "⓼" "⓽" "⓾"))
,@(-map-indexed (lambda (index ch8) (list (format "82c%d" (+ 1 index)) ch8)) '( "❶" "❷" "❸" "❹" "❺" "❻" "❼" "❽" "❾" "❿"))
,@(-map-indexed (lambda (index ch8) (list (format "83c%d"  index) ch8)) '( "⓿" "➊" "➋" "➌" "➍" "➎" "➏" "➐" "➑" "➒" "➓" "⓫" "⓬" "⓭" "⓮" "⓯" "⓰" "⓱" "⓲" "⓳" "⓴"))
,@(-map-indexed (lambda (index ch8) (list (format "8c%c"  (+  ?A index)) ch8)) '( "Ⓐ" "Ⓑ" "Ⓒ" "Ⓓ" "Ⓔ" "Ⓕ" "Ⓖ" "Ⓗ" "Ⓘ" "Ⓙ" "Ⓚ" "Ⓛ" "Ⓜ" "Ⓝ" "Ⓞ" "Ⓟ" "Ⓠ" "Ⓡ" "Ⓢ" "Ⓣ" "Ⓤ" "Ⓥ" "Ⓦ" "Ⓧ" "Ⓨ" "Ⓩ"))
,@(-map-indexed (lambda (index ch8) (list (format "8c%c"  (+  ?a index)) ch8)) '( "ⓐ" "ⓑ" "ⓒ" "ⓓ" "ⓔ" "ⓕ" "ⓖ" "ⓗ" "ⓘ" "ⓙ" "ⓚ" "ⓛ" "ⓜ" "ⓝ" "ⓞ" "ⓟ" "ⓠ" "ⓡ" "ⓢ" "ⓣ" "ⓤ" "ⓥ" "ⓦ" "ⓧ" "ⓨ" "ⓩ"))

    ,@(-map-indexed (lambda (index ch8) (list (format "81a%d" (+ 1 index)) ch8)) '("←" "→" "↑" "↓" "↔" "↕" "↖" "↗" "↘" "↙" "↚" "↛" "↮" "⟵" "⟶" "⟷"))
    ,@(-map-indexed (lambda (index ch8) (list (format "82a%d" (+ 1 index)) ch8))  '("⇐" "⇒" "⇑" "⇓" "⇔" "⇕" "⇖" "⇗" "⇘" "⇙" "⇍" "⇏" "⇎" "⟸" "⟹" "⟺"))
    ,@(-map-indexed (lambda (index ch8) (list (format "83a%d" (+ 1 index)) ch8))  '("⇦" "⇨" "⇧" "⇩" "⬄" "⇳" "⬀" "⬁" "⬂" "⬃"))
    ,@(-map-indexed (lambda (index ch8) (list (format "84a%d" (+ 1 index)) ch8))  '("⬅" "(" "⮕" "➡" ")" "⬆" "⬇" "⬈" "⬉" "⬊" "⬋" "⬌" "⬍"))
    ,@(-map-indexed (lambda (index ch8) (list (format "85a%d" (+ 1 index)) ch8))  '("🡐" "🡒" "🡑" "🡓" "🡔" "🡕" "🡖" "🡗" "🡘" "🡙"))
    ,@(-map-indexed (lambda (index ch8) (list (format "86a%d" (+ 1 index)) ch8))  '("🡠" "🡢" "🡡" "🡣" "🡤" "🡥" "🡦" "🡧"))
    ,@(-map-indexed (lambda (index ch8) (list (format "87a%d" (+ 1 index)) ch8))  '("🡨" "🡪" "🡩" "🡫" "🡬" "🡭" "🡮" "🡯"))
    ,@(-map-indexed (lambda (index ch8) (list (format "88a%d" (+ 1 index)) ch8))  '("🡰" "🡲" "🡱" "🡳" "🡴" "🡵" "🡶" "🡷"))
    ,@(-map-indexed (lambda (index ch8) (list (format "89a%d" (+ 1 index)) ch8))  '("🡸" "🡺" "🡹" "🡻" "🡼" "🡽" "🡾" "🡿"))
    ,@(-map-indexed (lambda (index ch8) (list (format "810a%d" (+ 1 index)) ch8))  '("🢀" "🢂" "🢁" "🢃" "🢄" "🢅" "🢆" "🢇"))
    ,@(-map-indexed (lambda (index ch8) (list (format "811a%d" (+ 1 index)) ch8))  '("⇆" "⇄" "⇅" "⇵" "⇈" "⇊" "⇇" "⇉"))
    ,@(-map-indexed (lambda (index ch8) (list (format "812a%d" (+ 1 index)) ch8))  '("⬱" "⇶"))
    ,@(-map-indexed (lambda (index ch8) (list (format "813a%d" (+ 1 index)) ch8))  '("⇠" "⇢" "⇡" "⇣"))
    ,@(-map-indexed (lambda (index ch8) (list (format "814a%d" (+ 1 index)) ch8))  '("⇚" "⇛" "⤊" "⤋" "⭅" "⭆" "⟰" "⟱"))
    ,@(-map-indexed (lambda (index ch8) (list (format "815a%d" (+ 1 index)) ch8))  '("↢" "↣"))
    ,@(-map-indexed (lambda (index ch8) (list (format "816a%d" (+ 1 index)) ch8))  '("↼" "⇀" "↽" "⇁" "↿" "↾" "⇃" "⇂"))
    ,@(-map-indexed (lambda (index ch8) (list (format "817a%d" (+ 1 index)) ch8))  '("⇋" "⇌"))
    ,@(-map-indexed (lambda (index ch8) (list (format "818a%d" (+ 1 index)) ch8))  '("⟻" "⟼"))
    ,@(-map-indexed (lambda (index ch8) (list (format "819a%d" (+ 1 index)) ch8))  '("⇽" "⇾" "⇿"))
    ,@(-map-indexed (lambda (index ch8) (list (format "820a%d" (+ 1 index)) ch8))  '("⇜" "⇝"))
    ,@(-map-indexed (lambda (index ch8) (list (format "821a%d" (+ 1 index)) ch8))  '("⬳" "⟿"))
    ,@(-map-indexed (lambda (index ch8) (list (format "822a%d" (+ 1 index)) ch8))  '("⥊" "⥋" "⥌" "⥍" "⥎" "⥏" "⥐" "⥑"))
    ,@(-map-indexed (lambda (index ch8) (list (format "823a%d" (+ 1 index)) ch8))  '("⥒" "⥓" "⥔" "⥕" "⥖" "⥗" "⥘" "⥙"))
    ,@(-map-indexed (lambda (index ch8) (list (format "824a%d" (+ 1 index)) ch8))  '("⥚" "⥛" "⥜" "⥝" "⥞" "⥟" "⥠" "⥡"))
    ,@(-map-indexed (lambda (index ch8) (list (format "825a%d" (+ 1 index)) ch8))  '("⥢" "⥤" "⥣" "⥥" "⥦" "⥨" "⥧" "⥩" "⥮" "⥯"))
    ,@(-map-indexed (lambda (index ch8) (list (format "826a%d" (+ 1 index)) ch8))  '("⥪" "⥬" "⥫" "⥭"))
    ,@(-map-indexed (lambda (index ch8) (list (format "827a%d" (+ 1 index)) ch8))  '("↤" "↦" "↥" "↧"))
    ,@(-map-indexed (lambda (index ch8) (list (format "828a%d" (+ 1 index)) ch8))  '("⇤" "⇥" "⤒" "⤓" "↨"))
    ,@(-map-indexed (lambda (index ch8) (list (format "829a%d" (+ 1 index)) ch8))  '("↞" "↠" "↟" "↡"))
    ,@(-map-indexed (lambda (index ch8) (list (format "830a%d" (+ 1 index)) ch8))  '("⇷" "⇸" "⤉" "⤈" "⇹"))
    ,@(-map-indexed (lambda (index ch8) (list (format "831a%d" (+ 1 index)) ch8))  '("⇺" "⇻" "⇞" "⇟" "⇼"))
    ,@(-map-indexed (lambda (index ch8) (list (format "832a%d" (+ 1 index)) ch8))  '("⬴" "⤀" "⬵" "⤁"))
    ,@(-map-indexed (lambda (index ch8) (list (format "833a%d" (+ 1 index)) ch8))  '("⬹" "⤔"))
    ,@(-map-indexed (lambda (index ch8) (list (format "834a%d" (+ 1 index)) ch8))  '("⬺" "⤕"))
    ,@(-map-indexed (lambda (index ch8) (list (format "835a%d" (+ 1 index)) ch8))  '("⤂" "⤃" "⤄"))
    ,@(-map-indexed (lambda (index ch8) (list (format "836a%d" (+ 1 index)) ch8))  '("⬶" "⤅"))
    ,@(-map-indexed (lambda (index ch8) (list (format "837a%d" (+ 1 index)) ch8))  '("⬻" "⤖"))
    ,@(-map-indexed (lambda (index ch8) (list (format "838a%d" (+ 1 index)) ch8))  '("⬷" "⤐"))
    ,@(-map-indexed (lambda (index ch8) (list (format "839a%d" (+ 1 index)) ch8))  '("⬼" "⤗" "⬽" "⤘"))
    ,@(-map-indexed (lambda (index ch8) (list (format "840a%d" (+ 1 index)) ch8))  '("⤆" "⤇"))
    ,@(-map-indexed (lambda (index ch8) (list (format "841a%d" (+ 1 index)) ch8))  '("⤌" "⤍" "⤎" "⤏"))
    ,@(-map-indexed (lambda (index ch8) (list (format "842a%d" (+ 1 index)) ch8))  '("⬸" "⤑"))
    ,@(-map-indexed (lambda (index ch8) (list (format "843a%d" (+ 1 index)) ch8))  '("⤝" "⤞" "⤟" "⤠"))
    ,@(-map-indexed (lambda (index ch8) (list (format "844a%d" (+ 1 index)) ch8))  '("⤙" "⤚" "⤛" "⤜"))
    ,@(-map-indexed (lambda (index ch8) (list (format "845a%d" (+ 1 index)) ch8))  '("⤡" "⤢" "⤣" "⤤" "⤥" "⤦" "⤪" "⤨" "⤧" "⤩" "⤭" "⤮" "⤯" "⤰" "⤱" "⤲" "⤫" "⤬"))
    ,@(-map-indexed (lambda (index ch8) (list (format "846a%d" (+ 1 index)) ch8))  '("↰" "↱" "↲" "↳" "⬐" "⬎" "⬑" "⬏" "↴" "↵"))
    ,@(-map-indexed (lambda (index ch8) (list (format "847a%d" (+ 1 index)) ch8))  '("⤶" "⤷" "⤴" "⤵"))
    ,@(-map-indexed (lambda (index ch8) (list (format "848a%d" (+ 1 index)) ch8))  '("↩" "↪" "↫" "↬"))
    ,@(-map-indexed (lambda (index ch8) (list (format "849a%d" (+ 1 index)) ch8))  '("⥼" "⥽" "⥾" "⥿"))
    ,@(-map-indexed (lambda (index ch8) (list (format "850a%d" (+ 1 index)) ch8))  '("⥂" "⥃" "⥄" "⭀" "⥱" "⥶" "⥸" "⭂" "⭈" "⭊" "⥵" "⭁" "⭇" "⭉" "⥲" "⭋" "⭌" "⥳" "⥴" "⥆" "⥅"))
    ,@(-map-indexed (lambda (index ch8) (list (format "851a%d" (+ 1 index)) ch8))  '("⥹" "⥻"))
    ,@(-map-indexed (lambda (index ch8) (list (format "852a%d" (+ 1 index)) ch8))  '("⬰" "⇴" "⥈" "⬾" "⥇" "⬲" "⟴"))
    ,@(-map-indexed (lambda (index ch8) (list (format "853a%d" (+ 1 index)) ch8))  '("⥷" "⭃" "⥺" "⭄"))
    ,@(-map-indexed (lambda (index ch8) (list (format "854a%d" (+ 1 index)) ch8))  '("⇱" "⇲"))
    ,@(-map-indexed (lambda (index ch8) (list (format "855a%d" (+ 1 index)) ch8))  '("↸" "↹" "↯" "↭" "⥉" "⥰"))
    ,@(-map-indexed (lambda (index ch8) (list (format "856a%d" (+ 1 index)) ch8))  '("⬿" "⤳"))
    ,@(-map-indexed (lambda (index ch8) (list (format "857a%d" (+ 1 index)) ch8))  '("↜" "↝"))
    ,@(-map-indexed (lambda (index ch8) (list (format "858a%d" (+ 1 index)) ch8))  '("⤼" "⤽"))
    ,@(-map-indexed (lambda (index ch8) (list (format "859a%d" (+ 1 index)) ch8))  '("↶" "↷" "⤾" "⤿" "⤸" "⤹" "⤺" "⤻"))
    ,@(-map-indexed (lambda (index ch8) (list (format "860a%d" (+ 1 index)) ch8))  '("↺" "↻" "⥀" "⥁" "⟲" "⟳"))
    ,@(-map-indexed (lambda (index ch8) (list (format "861a%d" (+ 1 index)) ch8))  '("🠀" "🠂" "🠁" "🠃" "🠄" "🠆" "🠅" "🠇" "🠈" "🠊" "🠉" "🠋"))
    ,@(-map-indexed (lambda (index ch8) (list (format "862a%d" (+ 1 index)) ch8))  '(""))
    ,@(-map-indexed (lambda (index ch8) (list (format "863a%d" (+ 1 index)) ch8))  '("🠐" "🠒" "🠑" "🠓" "🠔" "🠖" "🠕" "🠗" "🠘" "🠚" "🠙" "🠛" "🠜" "🠞" "🠝" "🠟"))
    ,@(-map-indexed (lambda (index ch8) (list (format "864a%d" (+ 1 index)) ch8))  '(""))
    ,@(-map-indexed (lambda (index ch8) (list (format "865a%d" (+ 1 index)) ch8))  '("🠠" "🠱" "🠢" "🠳" "🠤" "🠵" "🠦" "🠷" "🠨" "🠹" "🠪" "🠻" "🠬" "🠽" "🠮" "🠿" "🠰" "🡁" "🠲" "🡃" "🠴" "🡅" "🠶" "🡇" "🠸" "🠹" "🠺" "🠻" "🠼" "🠽" "🠾" "🠿" "🡀" "🡁" "🡂" "🡃" "🡄" "🡆" "🡅" "🡇"))
    ,@(-map-indexed (lambda (index ch8) (list (format "866a%d" (+ 1 index)) ch8))  '(""))
    ,@(-map-indexed (lambda (index ch8) (list (format "867a%d" (+ 1 index)) ch8))  '("🢐" "🢑" "🢒" "🢓" "🢔" "🢕" "🢖" "🢗" "🢘" "🢙" "🢚" "🢛" "🢜" "🢝" "🢞" "🢟" "🢬" "🢭" ""))

    ("8ha1" "☚" )
    ("8ha2" "☛" )
    ("8ha3" "☜")
    ("8ha4" "☝" )
    ("8ha5" "☞")
    ("8ha6" "☟" )
    ("8ha7" "👆" )
    ("8ha8" "👇" )
    ("8ha9" "👈" )
    ("8ha10" "👉")
    ("8ha11" "🖗")
    ("8ha12" "🖘")
    ("8ha13" "🖙")
    ("8ha14" "🖚")
    ("8ha15" "🖛")
    ("8ha16" "🖜")
    ("8ha17" "🖝")
    ("8ha18" "🖞")
    ("8ha19" "🖟")
    ("8ha20" "🖠")
    ("8ha21" "🖡")
    ("8ha22" "🖢")
    ("8ha23" "🖣")

    ( "8draft"          "⚒")
    ( "8flagged"        "✚")
    ( "8new"            "✱")
    ( "8passed"         "❯")
    ( "8replied"        "❮")
    ( "8seen"           "✔")
    ( "8trashed"        "⏚")
    ( "8attach"         "⚓")
    ( "8encrypted"      "⚴")
    ( "8signed"         "☡")
    ( "8unread"         "⎕")
    ( "8equiv"  "≡")


    ( "8r1" "⁑")
    ( "8r2" "⁕")
    ( "8r3" "⁖")
    ( "8r4" "⁘")
    ( "8r5" "⁙")
    ( "8r6" "⁛")
    ( "8r7" "⁜")
    ( "8r8" "⁂")
    ( "8r9" "¶" )
    ( "8r10" "§" )
    ( "8return" "⏎")
    ;; email
    ("8wdy" "wordy-english@yahoogroups.com")

    ;; computing tech
    ("8l11" "Link-11 DLP")
    ("8is" "ISDL DLP")
    ("8tp" "토픽")
    ("8qt" "QuickTime")
    ("8it" "IntelliType")
    ("8msw" "Microsoft Windows")
    ("8win" "Windows")
    ("8ie" "Internet Explorer")
    ("8ahk" "AutoHotkey")
    ("8pr" "POV-Ray")
    ("8ps" "PowerShell")
    ("8mma" "Mathematica")
    ("8js" "javascript")
    ("8vb" "Visual Basic")
    ("8yt" "YouTube")
    ("8ff" "Firefox")
    ("8sl" "Second Life")
    ("8ll" "Linden Labs")
    ("8ee" "ErgoEmacs")


    ;; normal english words
    ("8alt" "alternative")
    ("8char" "character")
    ("8def" "definition")
    ("8bg" "background")
    ("8kb" "keyboard")
    ("8ex" "example")
    ("8kbd" "keybinding")
    ("8env" "environment")
    ("8var" "variable")
    ("8ev" "environment variable")
    ("8cp" "computer")

    ("8dt" "표적정보상세탭")
    ("8ㅣㅓ" "표적정보상세탭")
    ("8sim" "시뮬레이터")
    ("8ㄴㅁㅎ" "시뮬레이터")
    ;; sig
    ("8xl" "Xah Lee")

    ;; url
    ("8uxl" "http://xahlee.org/")
    ("8uee" "http://ergoemacs.org/")
    ("8uvmm" "http://VirtualMathMuseum.org/")
    ("8u3dxm" "http://3D-XplorMath.org/")

    ;; emacs regex
    ("8num" "\\([0-9]+?\\)")
    ("8str" "\\([^\"]+?\\)\"")
    ("8curly" "“\\([^”]+?\\)”")

    ;; shell commands
    ("8ditto" "ditto -ck --sequesterRsrc --keepParent src dest")
    ("8im" "convert -quality 85% ")
    ("8ims" "convert -size  -quality 85% ")
    ("8im256" "convert +dither -colors 256 ")
    ("8imf" "find . -name \"*png\" | xargs -l -i basename \"{}\" \".png\" | xargs -l -i  convert -quality 85% \"{}.png\" \"{}.jpg\"")

    ("8f0" "find . -type f -empty")
    ("8f00" "find . -type f -size 0 -exec rm {} ';'")
    ("8chmod" "find . -type f -exec chmod 644 {} ';'")
    ("8chmod2" "find . -type d -exec chmod 755 {} ';'")

    ("8unison" "unison -servercmd /usr/bin/unison c:/Users/xah/web ssh://xah@example.com//Users/xah/web")
    ("8sftp" "sftp xah@xahlee.org")
    ("8ssh" "ssh xah@xahlee.org")
    ("8rsync" "rsync -z -r -v -t --exclude=\"*~\" --exclude=\".DS_Store\" --exclude=\".bash_history\" --exclude=\"**/xx_xahlee_info/*\"  --exclude=\"*/_curves_robert_yates/*.png\" --exclude=\"logs/*\"  --exclude=\"xlogs/*\" --delete --rsh=\"ssh -l xah\" ~/web/ xah@example.com:~/")

    ("8rsync2" "rsync -r -v -t --delete --rsh=\"ssh -l xah\" ~/web/ xah@example.com:~/web/")
    ("8rsync3" "rsync -r -v -t --delete --exclude=\"**/My *\" --rsh=\"ssh -l xah\" ~/Documents/ xah@example.com:~/Documents/")
    ))

;; stop asking whether to save newly added abbrev when quitting emacs
;;(setq save-abbrevs nil)





;; https://www.emacswiki.org/emacs/AbbrevMode
(defun define-abbrev-function (table abbrev func)
  (put func 'no-self-insert t)
  (define-abbrev table abbrev "" `(lambda () (call-interactively ',func)))
)

(defmacro defun-abbrev (funcname abbrev &rest body)
  "Defun a function and define an abbrev.
Note that `table' is abbrev table to use."
  `(progn
     (defun ,funcname () ,@body)
     (define-abbrev-function global-abbrev-table ,abbrev ',funcname)))

(defun-abbrev
  timestamp-with-name1
  "8ts1"
  (interactive)
  (insert
   (with-temp-buffer 
     (org-insert-time-stamp (org-read-date nil t "+0d"))
     (insert " 김동일")
     (buffer-string))))



;; turn on abbrev mode globally
(setq-default abbrev-mode t)

