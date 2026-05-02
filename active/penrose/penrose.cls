
%------------------------------------------------------------
% INITIALIZING & HANDLING CLASS OPTIONS
%------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
% \ProvidesClass{penrose}[2023/12/29 A simple article class for maths and physics]
\ProvidesClass{penrose}[2026/05/01 v2 Personalised, customizable, clean article class]

\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{article}} %default (in the article cls)
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{article}} %default (in the article cls)
\DeclareOption{fleqn}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{leqno}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption*{\ClassError{penrose}{Unknown Option: '\CurrentOption'}{}}

\ProcessOptions\relax
\LoadClass{article} % Base class: article

%------------------------------------------------------------
% GENERAL HANDY PACKAGES
%------------------------------------------------------------
\RequirePackage{xparse}
\RequirePackage[strict]{changepage}
% \RequirePackage{etoolbox}
% \RequirePackage{calc}

%------------------------------------------------------------
% STANDARD PAGE LAYOUT
%------------------------------------------------------------
\RequirePackage[
  a4paper,
  nomarginpar,
  includeall,
  top=16mm,
  bottom=22mm,
  left=30mm,
  right=30mm,
  headheight=7mm,
  headsep=7mm,
  footskip=8mm,
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
% CLASS WIDE COMMON SETUP: DOCUMENT INFORMATION COMMANDS
%------------------------------------------------------------
\newcommand{\utitle}{}
\newcommand{\ushorttitle}{}
\newcommand{\usubtitle}{}
\newcommand{\uauthor}{}
\newcommand{\uaffiliation}{}
\newcommand{\udate}{}
\newcommand{\@dateline}{}

\DeclareDocumentCommand{\title}{om}{
  \renewcommand{\utitle}{#2}
  \IfValueTF{#1}
    {\renewcommand{\ushorttitle}{#1}}
    {\renewcommand{\ushorttitle}{#2}}
    \gdef\@title{#2}
}

\DeclareDocumentCommand{\subtitle}{m}{
  \renewcommand{\usubtitle}{#1}
}
\DeclareDocumentCommand{\author}{m}{
  \renewcommand{\uauthor}{#1}
  \gdef\@author{#1}
}
\DeclareDocumentCommand{\affiliation}{m}{
  \renewcommand{\uaffiliation}{#1}
}

\DeclareDocumentCommand{\date}{sm}{
  \renewcommand{\udate}{#2}
  \renewcommand{\@dateline}{
    \IfBooleanTF{#1}{#2}{(Date: #2)}\par
  }
  \gdef\@date{#2}
}

%------------------------------------------------------------
% MAIN TITLE DESIGN & ABSTRACT
%------------------------------------------------------------
\renewcommand{\maketitle}{
  \begingroup
  \thispagestyle{hf-first}
  \begin{adjustwidth}{-13mm}{-13mm}
    \centering
    {\Large\bfseries\utitle\par}\vspace*{0.2em}
    {\large\usubtitle\par}\vspace*{0.7em}
    {\uauthor\par}
    {\itshape\uaffiliation\par}
    \@dateline\vspace*{0.5em}
  \end{adjustwidth}
  \endgroup
}

\renewenvironment{abstract}
  {\begin{adjustwidth}{11mm}{11mm}}
  {\vspace*{0.5em}\end{adjustwidth}}

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
    \fancyhead[L]{{\slshape\protect\ushorttitle}}
    \fancyhead[R]{{\slshape\protect\uauthor}}
    \fancyfoot[C]{-- \thepage\ --}
    \renewcommand{\headrulewidth}{0pt}
  }

% Activating the default header-footer style
\pagestyle{hf-general}

%------------------------------------------------------------
% BIBLIOGRAPHY/REFERENCES
%------------------------------------------------------------
\RequirePackage[square,numbers,comma,sort&compress]{natbib}
\bibliographystyle{naturemag}
\let\openbox\relax

%------------------------------------------------------------
% GLOBAL SNIPPETS
%------------------------------------------------------------
\renewenvironment{quote}{\begin{adjustwidth}{11mm}{11mm}}{\end{adjustwidth}}
\newenvironment{widetext}{\begin{adjustwidth}{-13mm}{-13mm}}{\end{adjustwidth}}

%------------------------------------------------------------
% THE LISTS
%------------------------------------------------------------
\RequirePackage{enumitem}

\setlist[itemize,1]{label=$\bullet$}
\setlist[itemize,2]{leftmargin=6mm}
\setlist[itemize,3]{leftmargin=6mm, label=$\ast$}

%------------------------------------------------------------
% TABLES
%------------------------------------------------------------
\RequirePackage{booktabs,tabularx}

\newcolumntype{C}{>{\centering\arraybackslash}X}
\newcolumntype{R}{>{\raggedleft\arraybackslash}X}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}

\newcolumntype{D}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{U}[1]{>{\raggedleft\arraybackslash}p{#1}} % R with custom width
\newcolumntype{V}[1]{>{\raggedright\arraybackslash}p{#1}} % L with custom width

\newcommand{\ra}[1]{\renewcommand{\arraystretch}{#1}}

%------------------------------------------------------------
% CAPTIONS
%------------------------------------------------------------
\RequirePackage[font=small,labelfont=bf,labelsep=endash]{caption}

\DeclareCaptionStyle{widefigure}{font=small,labelfont=bf,labelsep=endash}
\DeclareCaptionStyle{margintable}{font=small,labelfont=bf,labelsep=endash}
\DeclareCaptionStyle{widetable}{font=small,labelfont=bf,labelsep=endash}

\DeclareCaptionStyle{marginfigure}{font=small,labelfont=bf,labelsep=endash}
\DeclareCaptionStyle{sidecaption}{font=small,labelfont=bf,labelsep=endash}

%------------------------------------------------------------
% HYPERLINKS
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

%------------------------------------------------------------
% FOR MORE COMPATIBILITY WITH SALAM.CLS / DEPRECATED
%------------------------------------------------------------
\RequirePackage{mdframed}
\newmdenv[hidealllines=true, backgroundcolor=lightgray, skipabove=10pt, skipbelow=10pt, innerleftmargin=8pt, innerrightmargin=8pt, innertopmargin=10pt, innerbottommargin=10pt]{colbox}

\RequirePackage{sidenotes}
\let\sidenote\footnote
\let\margintoc\relax
\DeclareDocumentCommand{\marginbox}{oom}{}
\DeclareDocumentCommand{\marginnote}{omo}{}
