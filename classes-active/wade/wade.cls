%------------------------------------------------------------
% INITIALIZING & HANDLING CLASS OPTIONS
%------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
% \ProvidesClass{wade}[2024/03/29 A simple, personalised letter class]
\ProvidesClass{wade}[2026/05/02 v2 A simple, personalised letter class]

\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{article}} %default (in the article cls)
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{article}} %default (in the article cls)
\DeclareOption{fleqn}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{leqno}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption*{\ClassError{wade}{Unknown Option: '\CurrentOption'}{}}

\ProcessOptions\relax
\LoadClass{article} % Base class: article

%------------------------------------------------------------
% GENERAL HANDY PACKAGES
%------------------------------------------------------------
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}
\RequirePackage[strict]{changepage}
% \RequirePackage{calc}

%------------------------------------------------------------
% STANDARD PAGE LAYOUT
%------------------------------------------------------------
\RequirePackage[
  a4paper,
  nomarginpar,
  margin={28mm, 28mm},
  headheight=7mm,
  headsep=7mm,
  footskip=10mm,
  ]{geometry}

%------------------------------------------------------------
% GLOBAL TYPOGRAPHY
%------------------------------------------------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage{setspace}
\RequirePackage{parskip}
\RequirePackage{microtype}

%------------------------------------------------------------
% COLOURS
%------------------------------------------------------------
\RequirePackage{xcolor}
\definecolor{lightgray}{RGB}{211,211,211}
\definecolor{darkgray}{RGB}{64,64,79}
\definecolor{gold}{RGB}{255,204,0}
\definecolor{orange}{RGB}{255,103,0}
\definecolor{red}{RGB}{255,0,0}
\definecolor{pink}{RGB}{255,182,193}
\definecolor{crimson}{RGB}{211,0,63}
\definecolor{trueblue}{RGB}{0,47,167}
\definecolor{teal}{RGB}{0,128,128}
\definecolor{truegreen}{RGB}{0,102,0}

%------------------------------------------------------------
% AUXILIARY MACROS
%------------------------------------------------------------
\def\@openingvspace{0.75em}
\def\@closingvspace{0.75em}

%------------------------------------------------------------
% DOCUMENT-WIDE COMMANDS
%------------------------------------------------------------
\providecommand\ufromaddress{}
\providecommand\utoaddress{}
\DeclareDocumentCommand{\fromaddress}{m}{ \renewcommand{\ufromaddress}{#1\par\vspace{\@closingvspace}} }
\DeclareDocumentCommand{\toaddress}{m}{ \renewcommand{\utoaddress}{#1\par\vspace{\@closingvspace}} }

\let\usubject\relax
\let\usubjectraw\relax
\let\udate\relax
\let\usenderinfo\relax

\DeclareDocumentCommand{\subject}{m}{ \newcommand{\usubjectraw}{#1}\newcommand{\usubject}{\par\vspace{\@closingvspace} {\centering\bfseries#1\par}} }
\DeclareDocumentCommand{\date}{m}{ \newcommand{\udate}{#1} }
\DeclareDocumentCommand{\greeting}{m}{ \newcommand{\ugreeting}{#1} }

\newcommand\uclosingtag{Yours sincerely,}
\DeclareDocumentCommand{\closingtag}{m}{ \renewcommand{\uclosingtag}{#1} }
\DeclareDocumentCommand{\sender}{m}{ \newcommand{\usenderraw}{#1}\newcommand{\usender}{\textbf{#1}} }
\DeclareDocumentCommand{\senderinfo}{m}{ \newcommand{\usenderinfo}{\newline#1} }


\providecommand\usignatureblock{}
\DeclareDocumentCommand{\signatureblock}{m}{ \ifblank{#1}{}{\renewcommand{\usignatureblock}{#1\par\vspace{\@closingvspace}}} }

%------------------------------------------------------------
% OPENING SECTOR
%------------------------------------------------------------
\newcommand{\@osleftright}{
  \begin{flushright}\ufromaddress\end{flushright}
  \utoaddress
  \udate
  \usubject
  \par\vspace{\@closingvspace}
  \ugreeting
  \par\vspace{\@closingvspace}
}

\newcommand{\@osleft}{
  \ufromaddress
  \utoaddress
  \udate
  \usubject
  \par\vspace{\@closingvspace}
  \ugreeting
  \par\vspace{\@closingvspace}
}

\newcommand{\@osmin}{
  \udate
  \par\vspace*{2mm}
  \par\ugreeting
  \par\vspace*{2mm}
}

\let\@osdefault\@osleft

%------------------------------------------------------------
% CLOSING SECTOR
%------------------------------------------------------------
\newcommand{\@closingsector}{
  \par\vspace{\@closingvspace}
  \uclosingtag
  \par\vspace{\@closingvspace}
  \usignatureblock
  \usender
  \usenderinfo
}

%------------------------------------------------------------
% SOME FINAL TOUCHES
%------------------------------------------------------------
\setlength{\parskip}{0.5em}
\pagestyle{empty}

\DeclareDocumentCommand{\printopening}{O{default}}{
  \expandafter\ifstrequal\expandafter{#1}{default}{\@osdefault}{}
  \expandafter\ifstrequal\expandafter{#1}{leftright}{\@osleftright}{}
  \expandafter\ifstrequal\expandafter{#1}{left}{\@osleft}{}
  \expandafter\ifstrequal\expandafter{#1}{min}{\@osmin}{}
}
\newcommand{\printclosing}{\@closingsector}

%------------------------------------------------------------
% TABLES, LISTS, CAPTIONS
%------------------------------------------------------------
\RequirePackage[font=small,labelfont=bf,labelsep=endash]{caption}

\RequirePackage{enumitem}
\setlist[itemize,1]{label=$\bullet$}
\setlist[itemize,2]{leftmargin=6mm}
\setlist[itemize,3]{leftmargin=6mm, label=$\ast$}

\RequirePackage{booktabs,tabularx}
\newcolumntype{C}{>{\centering\arraybackslash}X}
\newcolumntype{R}{>{\raggedleft\arraybackslash}X}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcolumntype{D}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{U}[1]{>{\raggedleft\arraybackslash}p{#1}} % R with custom width
\newcolumntype{V}[1]{>{\raggedright\arraybackslash}p{#1}} % L with custom width
\newcommand{\ra}[1]{\renewcommand{\arraystretch}{#1}}

%------------------------------------------------------------
% HEADER & FOOTER
%------------------------------------------------------------
\RequirePackage{fancyhdr}
  % Header-Footer style for the first page
  \fancypagestyle{hf-first}{
    \fancyhf{}
    \fancyfoot[C]{-- \thepage\ --}
    \renewcommand{\headrulewidth}{0pt}
  }
  % Header-Footer style for the rest of the document
  \fancypagestyle{hf-general}{
    \fancyhf{}
    \fancyhead[L]{{\slshape\protect\usubjectraw}}
    \fancyhead[R]{{\slshape\protect\usenderraw}}
    \fancyfoot[C]{-- \thepage\ --}
    \renewcommand{\headrulewidth}{0pt}
  }

% Activating the default header-footer style
\pagestyle{hf-first}

%------------------------------------------------------------
% HYPERLINKS (WHY WOULD YOU ADD HYPERLINKS IN YOUR LETTER???)
%------------------------------------------------------------
\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  linktoc=all,
  allcolors=trueblue,
  linkcolor=crimson,
  citecolor=trueblue,
  urlcolor=crimson,
}