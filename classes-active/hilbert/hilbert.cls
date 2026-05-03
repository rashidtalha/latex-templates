%-------------------------------------------------------------
% INITIALIZING & HANDLING CLASS OPTIONS
%-------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
% \ProvidesClass{hilbert}[2021/07/02 Inspired by the Two-Line style]
\ProvidesClass{hilbert}[2026/05/02 v2 Inspired by the Two-Line style]

\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{book}} % default (in the book cls)
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{book}} % default (in the book cls)

% Indentation options
\def\@@docindent{}
\DeclareOption{indent}{\def\@@docindent{indent}}
\DeclareOption{noindent}{\def\@@docindent{}} % this is the default option

\DeclareOption*{\ClassError{hilbert}{Unknown Option: '\CurrentOption'}{}}

\ProcessOptions\relax
\LoadClass{book} % Base class: book

%------------------------------------------------------------
% GENERAL HANDY PACKAGES
%------------------------------------------------------------
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage[strict]{changepage}
% \RequirePackage{calc}

%-------------------------------------------------------------
% STANDARD PAGE LAYOUT
%-------------------------------------------------------------
\RequirePackage[
  papersize={129mm, 198mm},
  includehead,
  includefoot,
  nomarginpar,
  top=14mm,
  bottom=16mm,
  left=18mm,
  right=18mm,
  headheight=6mm,
  headsep=4mm,
  footskip=10mm,
  ]{geometry}

% Those blank pages ... should be COMPLETELY blank
\renewcommand*{\cleardoublepage}{
  \clearpage
  \ifodd
    \c@page
  \else
    \null\thispagestyle{empty}\newpage
  \fi
}

%------------------------------------------------------------
% GLOBAL TYPOGRAPHY
%------------------------------------------------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

\usepackage[semibold,scale=.9]{sourcesanspro}
\usepackage[osf]{libertine}
\usepackage[libertine]{newtxmath}
\usepackage{inconsolata}
\renewcommand{\sfdefault}{SourceSansPro-LF}

\RequirePackage[\@@docindent]{parskip}
\RequirePackage{setspace}
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

%-------------------------------------------------------------
% DOCUMENT INFORMATION COMMANDS
%-------------------------------------------------------------
\DeclareDocumentCommand{\title}{m}{\newcommand{\utitle}{#1}\renewcommand{\@title}{#1}}
\DeclareDocumentCommand{\author}{m}{\newcommand{\uauthor}{#1}\renewcommand{\@author}{#1}}

%-------------------------------------------------------------
% TABLE OF CONTENTS
%-------------------------------------------------------------
\RequirePackage{titletoc}

\titlecontents{chapter}[3mm]
  {\large\itshape\vspace{3mm}}
  {\thecontentslabel\quad}
  {}
  {\titlerule*[2mm]{.}\contentspage\hspace*{3mm}}

%-------------------------------------------------------------
% HEADINGS: CHAPTERS, SECTIONS, SUBSECTIONS, ...
%-------------------------------------------------------------
\RequirePackage{titlesec}

\titleformat{\chapter}[display]
  {\vspace*{-15mm}}
  {\centering\LARGE\thechapter}
  {3mm}
  {\centering\Huge\scshape}
  [\vspace*{-2mm}]

\titleformat{\section}
  {\normalfont\Large\itshape}
  {\thesection}
  {1em}
  {}

\titleformat{\subsection}
  {\normalfont\large\itshape}
  {}
  {1em}
  {}

%-------------------------------------------------------------
% PAGES: OPTIONAL HALF-TITLE PAGE, BLANK & ART PAGES
%-------------------------------------------------------------
\NewDocumentCommand{\halftitlepage}{o}{%
  \clearpage
  \thispagestyle{empty}
  \vspace*{0.3\textheight}
  {\centering\scshape\Large\IfValueTF{#1}{#1}{\utitle}\par}%
  \clearpage
}

\NewDocumentCommand{\blankpage}{o}{%
  \clearpage
  \thispagestyle{empty}
  \vspace*{0.3\textheight}
  {\centering\itshape\IfValueTF{#1}{#1}{This page left blank intentionally}\par}%
  \clearpage
}

%-------------------------------------------------------------
% HEADERS & FOOTERS
%-------------------------------------------------------------
\RequirePackage{fancyhdr}
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}

\fancypagestyle{fancy-front}{
  \fancyhf{}
  \fancyfoot[C]{-- \thepage\ --}
  \renewcommand{\headrulewidth}{0pt} 
}
\fancypagestyle{fancy-main}{
  \fancyhf{}
  \fancyhead[CO]{{\small\scshape\leftmark}}
  \fancyhead[CE]{{\small\scshape\utitle}}
  \fancyfoot[C]{-- \thepage\ --}
  \renewcommand{\headrulewidth}{0pt}
}
\fancypagestyle{fancy-back}{
  \fancyhf{}
  \fancyhead[CO]{{\small\scshape\leftmark}}
  \fancyhead[CE]{{\small\scshape\utitle}}
  \fancyfoot[C]{-- \thepage\ --}
  \renewcommand{\headrulewidth}{0pt} 
}

% This is the style for the chapter page
\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[C]{-- \thepage\ --}
  \renewcommand{\headrulewidth}{0pt} 
}


%-------------------------------------------------------------
% FRONT-, MAIN-, BACK- MATTERS BEHAVIOUR
%-------------------------------------------------------------
% Front matter
\let\oldfrontmatter\frontmatter % Store the old command
\renewcommand{\frontmatter}{
  \oldfrontmatter % First of all, call the old command
  \@openrightfalse
  \pagestyle{empty}
}

% Main matter
\let\oldmainmatter\mainmatter % Store the old command
\renewcommand{\mainmatter}{
  \oldmainmatter % Call the old command
  \@openrighttrue
  \pagestyle{fancy-main}
}

% Back matter
\let\oldbackmatter\backmatter % Store the old command
\renewcommand{\backmatter}{
  \oldbackmatter % Call the old command
  \@openrightfalse
  \pagestyle{fancy-back}
}

\pagestyle{empty}

%------------------------------------------------------------
% GLOBAL SNIPPETS
%------------------------------------------------------------
\renewenvironment{quote}{\begin{adjustwidth}{12mm}{0mm}}{\end{adjustwidth}}

\newcommand{\rulethin}{\par\nopagebreak\vspace{1ex}\centerline{\rule{0.3\textwidth}{0.4pt}}\vspace{1ex}\par}
\newcommand{\rulestars}{\par\nopagebreak\vspace{2.5ex}\centerline{\large\textasteriskcentered \quad \textasteriskcentered \quad \textasteriskcentered}\vspace{0.75ex}\par}
\newcommand{\rulediamonds}{\par\nopagebreak\vspace{2.5ex}\centerline{$\diamond$ \quad $\diamond$ \quad $\diamond$}\vspace{0.75ex}\par}

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
}
