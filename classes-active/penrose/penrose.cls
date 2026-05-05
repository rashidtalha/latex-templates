%------------------------------------------------------------
% INITIALIZING & HANDLING CLASS OPTIONS
%------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
% \ProvidesClass{penrose}[2023/12/29 A simple article class for maths and physics]
\ProvidesClass{penrose}[2026/05/01 v2 Personalised, customizable, clean article class]

\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{article}} % default (in the article cls)
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{article}} % default (in the article cls)
\DeclareOption{fleqn}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{leqno}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption*{\ClassError{penrose}{Unknown Option: '\CurrentOption'}{}}

\ProcessOptions\relax
\LoadClass{article} % Base class: article

%------------------------------------------------------------
% GENERAL HANDY PACKAGES
%------------------------------------------------------------
% \RequirePackage{xparse}
\RequirePackage[strict]{changepage}
\RequirePackage{etoolbox}
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
  footskip=10mm,
  ]{geometry}

%------------------------------------------------------------
% GLOBAL TYPOGRAPHY
%------------------------------------------------------------
% \RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage{setspace}
\RequirePackage{parskip}
\RequirePackage{microtype}

\setstretch{1.1} % increased line spacing

%------------------------------------------------------------
% COLOURS
%------------------------------------------------------------
\usepackage{xcolor}
\definecolor{alertred}{RGB}{204, 37, 41}
\definecolor{linkblue}{RGB}{0, 86, 179}
\definecolor{citegreen}{RGB}{34, 139, 34}
\definecolor{teal}{RGB}{0,128,128}
\definecolor{crimson}{RGB}{153, 0, 0}
\definecolor{softazure}{RGB}{52, 152, 219}
\definecolor{burntorange}{RGB}{230, 126, 34}
\definecolor{amethyst}{RGB}{155, 89, 182}
\definecolor{slategray}{RGB}{127, 140, 141}
\definecolor{boxgray}{RGB}{233, 233, 233}

%------------------------------------------------------------
% CLASS WIDE COMMON SETUP: DOCUMENT INFORMATION COMMANDS
%------------------------------------------------------------
\newcommand{\utitle}{\PackageWarning{penrose}{Title not set!}}
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

\DeclareDocumentCommand{\date}{sm}{
  \renewcommand{\udate}{#2}
  \renewcommand{\@dateline}{
    \IfBooleanTF{#1}{#2}{(Date: #2)}\par
  }
  \gdef\@date{#2}
}

%------------------------------------------------------------
% AUTHOR & AFFILIATION SYSTEM
%------------------------------------------------------------
\newcounter{penrose@authcount}
\newcounter{penrose@affilcount}

% Internal: render one author (name + optional superscript)
\newcommand{\penrose@renderauth}[1]{%
  \csuse{penrose@auth@name@#1}%
  \ifcsempty{penrose@auth@sym@#1}{}%
    {$^{\csuse{penrose@auth@sym@#1}}$}%
}

% Internal: render one affiliation (optional superscript + text)
\newcommand{\penrose@renderaffil}[1]{%
  \ifcsempty{penrose@affil@sym@#1}{}%
    {$^{\csuse{penrose@affil@sym@#1}}$}%
  \csuse{penrose@affil@name@#1}%
}

% Internal: full author list with Oxford comma
\newcommand{\penrose@renderauthors}{%
  \ifnum\thepenrose@authcount=0\relax\else
  \ifnum\thepenrose@authcount=1\relax
    \penrose@renderauth{1}%
  \else
  \ifnum\thepenrose@authcount=2\relax
    \penrose@renderauth{1} and \penrose@renderauth{2}%
  \else
    \@tempcnta=1
    \@whilenum\@tempcnta<\thepenrose@authcount\do{%
      \penrose@renderauth{\the\@tempcnta},\space
      \advance\@tempcnta\@ne
    }%
    and \penrose@renderauth{\thepenrose@authcount}%
  \fi\fi\fi
}

% Internal: all affiliation lines (no \par after the last one)
\newcommand{\penrose@renderaffils}{%
  \@tempcnta=1
  \@whilenum\@tempcnta<\thepenrose@affilcount\do{%
    \penrose@renderaffil{\the\@tempcnta}\\
    \advance\@tempcnta\@ne
  }%
  \penrose@renderaffil{\thepenrose@affilcount}\par%
}

% \author[sym]{name}
\DeclareDocumentCommand{\author}{om}{%
  \stepcounter{penrose@authcount}%
  \csdef{penrose@auth@name@\thepenrose@authcount}{#2}%
  \IfNoValueTF{#1}%
    {\csdef{penrose@auth@sym@\thepenrose@authcount}{}}%
    {\csdef{penrose@auth@sym@\thepenrose@authcount}{#1}}%
  \ifnum\thepenrose@authcount=1\relax
    \gdef\penrose@firstauthor{#2}%
    \renewcommand{\uauthor}{#2}%
    \gdef\@author{#2}%
  \else
    \renewcommand{\uauthor}{\penrose@firstauthor\ et al.}%
  \fi
}

% \affiliation[sym]{text}
\DeclareDocumentCommand{\affiliation}{om}{%
  \stepcounter{penrose@affilcount}%
  \csdef{penrose@affil@name@\thepenrose@affilcount}{#2}%
  \IfNoValueTF{#1}%
    {\csdef{penrose@affil@sym@\thepenrose@affilcount}{}}%
    {\csdef{penrose@affil@sym@\thepenrose@affilcount}{#1}}%
}

%------------------------------------------------------------
% MAIN TITLE DESIGN & ABSTRACT
%------------------------------------------------------------
\renewcommand{\maketitle}{%
  \begingroup
  \thispagestyle{hf-first}
  \begin{adjustwidth}{-13mm}{-13mm}
    \centering
    {\Large\bfseries\utitle\par}\vspace*{0.2em}
    {\large\usubtitle\par}\vspace*{0.7em}
    {\penrose@renderauthors\par}%
    \ifnum\thepenrose@affilcount>0\relax
      {\itshape\penrose@renderaffils\par}%
    \fi
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
  allcolors=linkblue,
}

%------------------------------------------------------------
% FANCY BOXES
%------------------------------------------------------------
\RequirePackage{mdframed}
\newmdenv[hidealllines=true, backgroundcolor=boxgray, skipabove=10pt, skipbelow=10pt, innerleftmargin=8pt, innerrightmargin=8pt, innertopmargin=10pt, innerbottommargin=10pt]{colbox}
