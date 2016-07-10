;; -*-mode: emacs-lisp; coding: cp949; buffer-read-only: t;-*-

;; �ＺŻ���� �ڵ� ���Ĵٵ�

(defun ins-body-header()
  (interactive)
  (insert "/////////////////////////////////////////////////////////////////\n")
  (insert "// Subsystem   :\n" )
  (insert "// Class       :\n")
  (insert (format "// File        : %s\n" (buffer-name)))
  (insert "// Description :\n")
  (insert "// See Also    : \n")
  (insert "// Author      : �赿��\n")
  (insert "// Dept.       : �ý�����\n")
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
  ( insert "// Author       : �赿��\n")
  ( insert "// Dept.        : �ý�����\n")
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

 




;; �� Scope Tags
;; �������Ϸ� Ȯ�� �� �� �ִ�. 
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
;; �� Return Type Tags
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
;; �� Access Level Control
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
;; �� Class Naming Convention
;; 
;; - Naming Convention : <Class Name>[Expt] 
;; - ������ ������ Class Name�� Default�̸�, '[Expt]'�κ��� Optional
;;   �κ����μ� ���� �ش�Class�� ExceptionClass�ΰ�� Class Name ������"
;;   Expt"��� ����Ѵ�.
;; - Class name�� ù���ڴ� �빮�ڷ��Ѵ�.
;; - ����word�� ������ ClassName�� ��word�� ù���ڸ� �빮�ڷ� �������¼ҹ��ڷ�
;;   �����Ѵ�.
;; - underscore("_")����������ʴ´�.
;; - Class name�� ������ ��쿡�� ��� �빮�ڷ� �Ѵ�.
;; 
;; �� Struct Naming Convention
;; 
;; 
;; - Naming Convention : tag<Struct Name>
;; - Struct Name�� ù ���ڴ� �빮�ڷ� �Ѵ�.
;; - ���� word�� ������ Struct Name�� �� word�� ù ���ڴ� �빮�ڷ� �������� �ҹ��ڷ�
;;   �����Ѵ�.
;; - underscore("_")�� ������� �ʴ´�.
;; - Struct Name�� ������ ��쿡�� ��� �빮�ڷ� �Ѵ�.
;; 
;; examples) :
;; struct tagCustomer
;; struct tagOderItem
;; struct tagATV
;; 
;; �� Non-Class Member Function
;; 
;; 
;; - Naming Convention
;; 
;;   : f_<Return Type Tags><[Debug|Get|Set|Flag|Fact]Funtion Name>
;; 
;; - Debug ���� Function�� ��� : "Debug"��� ����Ѵ�.
;; - Get ���õ� Function�� ��� : "Get"��� ����Ѵ�.
;; - Set ���õ� Function�� ��� : "Set"��� ����Ѵ�.
;; - Boolean return type�� Function�� ��� : "Flag"��� ����Ѵ�.
;; - Factory ���� Function�� ��� : "Fact"��� ����Ѵ�.
;; 
;; Example :
;; f_iGetState(); // int Non-Class Member Function for Get
;; f_iSetState(); // int Non-Class Member Function for Set
;; f_iDebugState(); // int Non-Class Member Function for Debug
;; f_iFactCpuWidget(); // int Non-Class Member Function for Factory
;; f_bFlagCpuAlarm(); // boolean Non-Class Member Function
;; 
;; �� Class Member Function
;; 
;; 
;; - Naming Convention
;; 
;;   : m_<Return Type Tags><[Debug|Get|Set|Flag|Fact]Funtion Name>
;; 
;; - Debug ���� Function�� ��� : "Debug"��� ����Ѵ�.
;; - Get ���õ� Function�� ��� : "Get"��� ����Ѵ�.
;; - Set ���õ� Function�� ��� : "Set"��� ����Ѵ�.
;; - Boolean return type�� Function�� ��� : "Flag"��� ����Ѵ�.
;; - Factory ���� Function�� ��� : "Fact"��� ����Ѵ�.
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
;; �� Non-Class Data Members
;; 
;; - Naming Convention : <Scope Tags>_[k]<Data Type Tags><Data Member Name>
;; - 2 �ܾ� �̻����� �����Ǿ� �ִ� ���� �� word�� ù ���ڸ� �빮�ڷ� �ϰ� ��������
;;    �ҹ��ڷ� �����Ѵ�.
;; - ���� Constant�� ���� "k"��� ����Ѵ�.
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
;; �� Class Data Members
;; 
;; - Naming Convention
;; 
;;     : <Access Level Control Tags>_<Data Type Tags><Data Member Name>
;; 
;; - 2 �ܾ� �̻����� �����Ǿ� �ִ� ���� �� word�� ù ���ڸ� �빮�ڷ� �ϰ� ��������
;;   �ҹ��ڷ� �����Ѵ�.
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
;; �� Object Variables
;; 
;; - Naming Convention : <Scope Tags>_<obj><Class Name>[Expt]
;; - 2 �ܾ� �̻����� �����Ǿ� �ִ� ���� �� word�� ù ���ڸ� �빮�ڷ� �ϰ� ��������
;;   �ҹ��ڷ� �����Ѵ�.
;; - Exception Class�� ���� "Expt"��� ����Ѵ�.
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
;; �� Type Defined Structure, Enum Type Definition, Object Variables, Top
;; 
;; - Naming Convention : new<Struct Name>
;; �� Enum Type Definition,  , Type Defined Structure, Top
;; 
;; - Type Naming Convention : en<enum name>
;; - Element Naming Convention : E_<element name>
;; - enum name : �� word�� ��� �빮�ڷ� �����Ѵ�.
;; - element name : �� word�� ��� �빮�ڷ� �����ϰ� "_"�� �����Ѵ�.
;; 
;; Example :
;; 
;; enum enSYSTEM_ERROR
;; {
;;     E_FILE_NOT_FOUND = 0,
;;     E_FILE_OPEN_ERROR = 1
;; } ;

