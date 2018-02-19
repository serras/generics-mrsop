%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% Haskell Styling
%%
%% TODO: Figure out spacing!

%% Colors (from duo-tone light syntax)
\definecolor{hsblack}{RGB}{45,32,3}
\definecolor{hsgold1}{RGB}{179,169,149}
\definecolor{hsgold2}{RGB}{177,149,90}
\definecolor{hsgold3}{RGB}{190,106,13}%{192,96,4}%{132,97,19}
\definecolor{hsblue1}{RGB}{173,176,182}
\definecolor{hsblue2}{RGB}{113,142,205}
\definecolor{hsblue3}{RGB}{0,33,132}
\definecolor{hsblue4}{RGB}{97,108,132}
\definecolor{hsblue5}{RGB}{34,50,68}
\definecolor{hsred2}{RGB}{191,121,103}
\definecolor{hsred3}{RGB}{171,72,46}

%% LaTeX Kerning nastiness. By using curly braces to delimit color group,
%% it breaks spacing. The following seems to work:
%%
%% https://tex.stackexchange.com/questions/85033/colored-symbols/85035#85035
%%
\newcommand*{\mathcolor}{}
\def\mathcolor#1#{\mathcoloraux{#1}}
\newcommand*{\mathcoloraux}[3]{%
  \protect\leavevmode
  \begingroup
    \color#1{#2}#3%
  \endgroup
}
\newcommand{\HSKeyword}[1]{\mathcolor{hsgold3}{\textbf{#1}}}
\newcommand{\HSNumeral}[1]{\mathcolor{hsred3}{#1}}
\newcommand{\HSChar}[1]{\mathcolor{hsred2}{#1}}
\newcommand{\HSString}[1]{\mathcolor{hsred2}{#1}}
\newcommand{\HSSpecial}[1]{\mathcolor{hsblue4}{#1}}
\newcommand{\HSSym}[1]{\mathcolor{hsblue4}{#1}}
\newcommand{\HSManualSym}[1]{\mathcolor{hsblue4}{#1}}
\newcommand{\HSCon}[1]{\mathcolor{hsblue3}{#1}}
\newcommand{\HSVar}[1]{\mathcolor{hsblue5}{#1}}

%subst keyword a = "\HSKeyword{" a "}"
%subst conid a   = "\HSCon{" a "}"
%subst varid a   = "\HSVar{" a "}"
%subst varsym a  = "\HSSym{" a "}" 
%subst consym a  = "\HSSym{" a "}"
%subst numeral a = "\HSNumeral{" a "}"
%subst char a    = "\HSChar{''" a "''}"
%subst string a  = "\HSString{``" a "\char34 }"
%subst special a = "\HSSpecial{" a "}"

%format :          = "\HSCon{\mathbin{:}}"
%format nil        = "\HSCon{[]}"

%format family     = "\HSKeyword{family}"
%format _          = "\HSManualSym{\anonymous} "
%format ->         = "\HSManualSym{\to} "
%format <-         = "\HSManualSym{\leftarrow} "
%format =>         = "\HSManualSym{\Rightarrow} "
%format \          = "\HSManualSym{\lambda} "
%format |          = "\HSManualSym{\mid} "
%format {          = "\HSManualSym{\{\mskip1.5mu} "
%format }          = "\HSManualSym{\mskip1.5mu\}}"
%format [          = "\HSManualSym{[\mskip1.5mu} "
%format ]          = "\HSManualSym{\mskip1.5mu]}"
%format =          = "\HSManualSym{\mathrel{=}}"
%format ..         = "\HSManualSym{\mathinner{\ldotp\ldotp}}"
%format ~          = "\HSManualSym{\mathord{\sim}}"
%format @          = "\HSManualSym{\mathord{@}}"
%format .          = "\HSManualSym{\mathbin{\circ}}"
%format !!         = "\HSManualSym{\mathbin{!!}}"
%format ^          = "\HSManualSym{\mathbin{\uparrow}}"
%format ^^         = "\HSManualSym{\mathbin{\uparrow\uparrow}}"
%format **         = "\HSManualSym{\mathbin{**}}"
%format /          = "\HSManualSym{\mathbin{/}}"
%format `quot`     = "\HSManualSym{\mathbin{`quot`}}"
%format `rem`      = "\HSManualSym{\mathbin{`rem`}}"
%format `div`      = "\HSManualSym{\mathbin{`div`}}"
%format `mod`      = "\HSManualSym{\mathbin{`mod`}}"
%format :%         = "\HSManualSym{\mathbin{:\%}}"
%format %          = "\HSManualSym{\mathbin{\%}}"
%format ++         = "\HSManualSym{\plus} "
%format ==         = "\HSManualSym{\equiv} "
%format /=         = "\HSManualSym{\not\equiv} "
%format <=         = "\HSManualSym{\leq} "
%format >=         = "\HSManualSym{\geq} "
%format `elem`     = "\HSManualSym{\in} "
%format `notElem`  = "\HSManualSym{\notin} "
%format &&         = "\HSManualSym{\mathrel{\wedge}}"
%format ||         = "\HSManualSym{\mathrel{\vee}}"
%format >>         = "\HSManualSym{\sequ} "
%format >>=        = "\HSManualSym{\bind} "
%format =<<        = "\HSManualSym{\rbind} "
%format $          = "\HSManualSym{\mathbin{\$}}"
%format `seq`      = "\HSManualSym{\mathbin{`seq`}}"
%format !          = "\HSManualSym{\mathbin{!}}"
%format //         = "\HSManualSym{\mathbin{//}}"
%format undefined  = "\HSManualSym{\bot} "
%format not	   = "\HSManualSym{\neg} "