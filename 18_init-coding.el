;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

;; 삼성탈래스 코딩 스탠다드

(defun ins-body-header()
  (interactive)
  (insert "/////////////////////////////////////////////////////////////////\n")
  (insert "// Subsystem   :\n" )
  (insert "// Class       :\n")
  (insert (format "// File        : %s\n" (buffer-name)))
  (insert "// Description :\n")
  (insert "// See Also    : \n")
  (insert "// Author      : 김동일\n")
  (insert "// Dept.       : 시스템팀\n")
  (insert (format "// Created     : %s\n" (date-string))) 
  (insert "// Version     :\n")
  (insert "// Revision history :\n")
  (insert "// date revised by revised information:\n")
  (insert "// ========== ============ =========================\n")
  (insert "// 2001/12/26\n")
  (insert "///////////////////////////////////////////////////////////////////////\n"))


(defun ins-inc-header()
  (interactive)
  ( insert "/////////////////////////////////////////////////////////////////\n")
  ( insert "// Subsystem    : \n")
  ( insert "// Class        : \n")
  ( insert (format "// File         : %s\n" (buffer-name)))
  ( insert "// Description  : \n")
  ( insert "// See Also     : \n")
  ( insert "// Author       : 김동일\n")
  ( insert "// Dept.        : 시스템팀\n")
  ( insert (format "// Created      : %s\n" (date-string)))
  ( insert "// Version :\n")
  ( insert "// Revision history : \n")
  ( insert "// date revised by revised information:\n")
  ( insert "// ========== ============ =========================\n")
  ( insert "// 2001/12/26\n")
  ( insert "///////////////////////////////////////////////////////////////////////\n") )

(defun ins-fun-header()
  (interactive)
  (insert "//////////////////////////////////////////////////////////////////////\n")
  (insert "// Operation       : \n")
  (insert "// Description     : \n")
  (insert "// Pre-conditions  : \n")
  (insert "// Post-conditions : \n")
  (insert "// Exceptions      : \n")
  (insert "//////////////////////////////////////////////////////////////////////\n"))

 




;; ※ Scope Tags
;; 인포파일로 확인 할 수 있다. 
;; +--------------+------------------------------+
;; |Scope Tags    |Description                   |
;; |              |                              |
;; +--------------+------------------------------+
;; |g             |Global Scope                  |
;; +--------------+------------------------------+
;; |gs            |gs Global Static Scope        |
;; +--------------+------------------------------+
;; |ls            |Local Static Scope            |
;; +--------------+------------------------------+
;; |z or null     |Auto(Local) Scope ( optional )|
;; |              |                              |
;; |              |                              |
;; +--------------+------------------------------+
;; 
;; ※ Return Type Tags
;; +-------------+------------+----------------------------+--------------+
;; |category data|normal      |unsigned                    |prointer      |
;; |types        |            |                            |              |
;; |             |            |                            |              |
;; +-------------+------------+----------------------------+--------------+
;; |    void     |     v      |             -              |     vp       |
;; +-------------+------------+----------------------------+--------------+
;; |    int      |     i      |             ui             |     ip       |
;; +-------------+------------+----------------------------+--------------+
;; |    handle   |     h      |             -              |     hp       |
;; +-------------+------------+----------------------------+--------------+
;; |    long     |     l      |             ul             |     lp       |
;; +-------------+------------+----------------------------+--------------+
;; |    float    |     f      |             uf             |     fp       |
;; +-------------+------------+----------------------------+--------------+
;; |    double   |     d      |             ud             |     dp       |
;; +-------------+------------+----------------------------+--------------+
;; |    char     |     c      |             uc             |    cp,cpp    |
;; +-------------+------------+----------------------------+--------------+
;; |    boolean  |     b      |             -              |      n       |
;; +-------------+------------+----------------------------+--------------+
;; |             |  sz : NULL terminated char string       |              |
;; | char string |                                         |              |
;; |             +-----------------------------------------+--------------+
;; |             |  s : None NULL terminated char string   |              |
;; |             |                                         |              |
;; +-------------+------------+----------------------------+--------------+
;; |    struct   |     st     |              -             |      stp     |
;; +-------------+------------+----------------------------+--------------+
;; |    union    |     un     |              -             |      unp     |
;; +-------------+------------+----------------------------+--------------+
;; |    Object   |    obj     |              -             |      objp    |
;; +-------------+------------+----------------------------+--------------+
;; 
;; ※ Access Level Control
;; 
;; +-------------+---------------+
;; |access level |               |
;; |tags         |description    |
;; |             |               |
;; +-------------+---------------+
;; |     b       |   public      |
;; +-------------+---------------+
;; |     t       |   protected   |
;; +-------------+---------------+
;; |     p       |   private     |
;; +-------------+---------------+
;; 
;; ※ Class Naming Convention
;; 
;; - Naming Convention : <Class Name>[Expt] 
;; - 위에서 정의한 Class Name은 Default이며, '[Expt]'부분은 Optional
;;   부분으로서 만일 해당Class가 ExceptionClass인경우 Class Name 다음에"
;;   Expt"라고 명시한다.
;; - Class name의 첫글자는 대문자로한다.
;; - 여러word로 구성된 ClassName은 각word의 첫글자를 대문자로 나머지는소문자로
;;   정의한다.
;; - underscore("_")를사용하지않는다.
;; - Class name이 약자인 경우에는 모두 대문자로 한다.
;; 
;; ※ Struct Naming Convention
;; 
;; 
;; - Naming Convention : tag<Struct Name>
;; - Struct Name의 첫 글자는 대문자로 한다.
;; - 여러 word로 구성된 Struct Name은 각 word의 첫 글자는 대문자로 나머지는 소문자로
;;   정의한다.
;; - underscore("_")를 사용하지 않는다.
;; - Struct Name이 약자인 경우에는 모두 대문자로 한다.
;; 
;; examples) :
;; struct tagCustomer
;; struct tagOderItem
;; struct tagATV
;; 
;; ※ Non-Class Member Function
;; 
;; 
;; - Naming Convention
;; 
;;   : f_<Return Type Tags><[Debug|Get|Set|Flag|Fact]Funtion Name>
;; 
;; - Debug 관련 Function인 경우 : "Debug"라고 명시한다.
;; - Get 관련된 Function인 경우 : "Get"라고 명시한다.
;; - Set 관련된 Function인 경우 : "Set"라고 명시한다.
;; - Boolean return type의 Function인 경우 : "Flag"라고 명시한다.
;; - Factory 관련 Function인 경우 : "Fact"라고 명시한다.
;; 
;; Example :
;; f_iGetState(); // int Non-Class Member Function for Get
;; f_iSetState(); // int Non-Class Member Function for Set
;; f_iDebugState(); // int Non-Class Member Function for Debug
;; f_iFactCpuWidget(); // int Non-Class Member Function for Factory
;; f_bFlagCpuAlarm(); // boolean Non-Class Member Function
;; 
;; ※ Class Member Function
;; 
;; 
;; - Naming Convention
;; 
;;   : m_<Return Type Tags><[Debug|Get|Set|Flag|Fact]Funtion Name>
;; 
;; - Debug 관련 Function인 경우 : "Debug"라고 명시한다.
;; - Get 관련된 Function인 경우 : "Get"라고 명시한다.
;; - Set 관련된 Function인 경우 : "Set"라고 명시한다.
;; - Boolean return type의 Function인 경우 : "Flag"라고 명시한다.
;; - Factory 관련 Function인 경우 : "Fact"라고 명시한다.
;; 
;; Example :
;; 
;; class NcCPU {
;; public :
;;     m_iGetState(); // int Class Member Function for Get
;;     m_iSetState(); // int Class Member Function for Set
;;     m_iDebugState(); // int Class Member Function for Debug
;;     m_iFactCpuWidget(); // int Class Member Function for Factory
;;     m_bFlagCpuAlarm(); // boolean Class Member Function
;; };
;; 
;; 
;; ※ Non-Class Data Members
;; 
;; - Naming Convention : <Scope Tags>_[k]<Data Type Tags><Data Member Name>
;; - 2 단어 이상으로 구성되어 있는 것은 각 word의 첫 글자를 대문자로 하고 나머지는
;;    소문자로 구성한다.
;; - 만약 Constant인 경우는 "k"라고 명시한다.
;; 
;; 
;; Example :
;; 
;; int g_iCpuState; // global int Non-Class Data Member
;; static int gs_iCpuState; // global static int Non-Class Data Member
;; function() {
;;     int z_iCpuState;// local int
;;     int iCpuValue; // local int
;;     const int kiCpuNo = 2; // constant int
;; }
;; 
;; ※ Class Data Members
;; 
;; - Naming Convention
;; 
;;     : <Access Level Control Tags>_<Data Type Tags><Data Member Name>
;; 
;; - 2 단어 이상으로 구성되어 있는 것은 각 word의 첫 글자를 대문자로 하고 나머지는
;;   소문자로 구성한다.
;; 
;; 
;; Example :
;; 
;; classNcCpuState : public NcKernelState {
;; public :
;;     int b_iGetState; // public acccess level & int
;; protected :
;;     int t_iGetState; // protected access level & int
;; private :
;;     int p_iGetState; // private access level & int
;; }
;; 
;; ※ Object Variables
;; 
;; - Naming Convention : <Scope Tags>_<obj><Class Name>[Expt]
;; - 2 단어 이상으로 구성되어 있는 것은 각 word의 첫 글자를 대문자로 하고 나머지는
;;   소문자로 구성한다.
;; - Exception Class인 경우는 "Expt"라고 명시한다.
;; 
;; 
;; 
;; 
;; Example :
;; 
;; WidgetClass g_objWidgetClass;
;; NcNmsExpt g_objNcNmsExpt;
;; 
;; function() {
;;     NcCpu z_objNcCpu("RISC","CISC");
;; }
;; 
;; ※ Type Defined Structure, Enum Type Definition, Object Variables, Top
;; 
;; - Naming Convention : new<Struct Name>
;; ※ Enum Type Definition,  , Type Defined Structure, Top
;; 
;; - Type Naming Convention : en<enum name>
;; - Element Naming Convention : E_<element name>
;; - enum name : 각 word를 모두 대문자로 구성한다.
;; - element name : 각 word를 모두 대문자로 구성하고 "_"로 연결한다.
;; 
;; Example :
;; 
;; enum enSYSTEM_ERROR
;; {
;;     E_FILE_NOT_FOUND = 0,
;;     E_FILE_OPEN_ERROR = 1
;; } ;

