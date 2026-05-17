%------------------------------------------------------------
% INITIALIZING & HANDLING CLASS OPTIONS
%------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
% \ProvidesClass{cauchy}[2022/12/20 A simple article class for maths and physics thesis]
\ProvidesClass{cauchy}[2026/05/03 v2 Simple article class for longer reports, theses, etc]

\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{article}} % default (in the article cls)
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{article}} % default (in the article cls)
\DeclareOption{fleqn}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{leqno}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption*{\ClassError{cauchy}{Unknown Option: '\CurrentOption'}{}}

% Indentation options
\def\@@docindent{}
\DeclareOption{indent}{\def\@@docindent{indent}}
\DeclareOption{noindent}{\def\@@docindent{}} % this is the default option

\ProcessOptions\relax
\LoadClass{article} % Base class: article

%------------------------------------------------------------
% GENERAL HANDY PACKAGES
%------------------------------------------------------------
% \RequirePackage{xparse}
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
  top=14mm,
  bottom=22mm,
  left=29mm,
  right=29mm,
  headheight=7mm,
  headsep=6mm,
  footskip=9mm,
  ]{geometry}

%------------------------------------------------------------
% GLOBAL TYPOGRAPHY
%------------------------------------------------------------
% \RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage[\@@docindent]{parskip}
\RequirePackage{setspace}
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
\DeclareDocumentCommand{\title}{om}{
  \IfValueTF{#1}{\newcommand{\ushorttitle}{#1}}{\newcommand{\ushorttitle}{#2}}
  \newcommand{\utitle}{#2}
  \renewcommand{\@title}{#2}
}

\DeclareDocumentCommand{\author}{m}{
  \newcommand{\uauthor}{#1}
  \renewcommand{\@author}{#1}
}

%------------------------------------------------------------
% MAIN TITLE DESIGN & ABSTRACT
%------------------------------------------------------------
\renewcommand{\maketitle}{} % the title page is given separately

\renewenvironment{abstract}
  {\begin{adjustwidth}{11mm}{11mm}}
  {\vspace*{0.5em}\end{adjustwidth}}

%------------------------------------------------------------
% HEADER & FOOTER
%------------------------------------------------------------
\RequirePackage{fancyhdr}
\renewcommand{\sectionmark}[1]{\markright{{#1}}}
\renewcommand{\subsectionmark}[1]{}

% Header-Footer style for the frontmatter and first pages
\fancypagestyle{hf-front}{
  \fancyhf{}
  \fancyfoot[C]{-- \thepage\ --}
  \renewcommand{\headrulewidth}{0pt}
}

% Header-Footer style with chapter heading
\fancypagestyle{hf-general}{
  \fancyhf{}
  \fancyhead[C]{\rightmark}
  \fancyfoot[C]{-- \thepage\ --}
  \renewcommand{\headrulewidth}{0pt}
}

% Activating the default header-footer style
\pagestyle{hf-general}

%------------------------------------------------------------
% FOOTNOTE HANDLING
%------------------------------------------------------------
\renewcommand{\@makefntext}[1]{%
  \setlength{\parindent}{1.5em}\parskip\z@%
  \let\nextpar\relax%
  \everypar{%
    \hangindent=1.5em\hangafter=1\nextpar%
    \gdef\nextpar{\hspace{\parindent}}%
  }%
  \noindent\hb@xt@1.5em{\hss\@makefnmark\,}#1
}

\newcommand{\ufootnote}[2][]{
  \begingroup
    \renewcommand\thefootnote{}%
    \def\@makefnmark{$^{#1}$}%
    \let\Hy@raisedlink\@gobble%
    \let\hyper@anchorstart\@gobble%
    \let\hyper@anchorend\@gobble%
    \footnotetext{#2}%
  \endgroup
}

%------------------------------------------------------------
% TABLE OF CONTENTS
%------------------------------------------------------------
\RequirePackage{etoc}
\etocsettocdepth{subsection}

%------------------------------------------------------------
% HEADINGS: SECTIONS, SUBSECTIONS, ...
%------------------------------------------------------------
\RequirePackage{titlesec}
\newcommand{\sectionbreak}{\clearpage}

\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}}

\newcommand\chaptername{Chapter}
\titleformat{\section}[display]
  {\thispagestyle{hf-front}\vspace*{6mm}\normalfont\Large\bfseries}
  {\chaptername~\thetitle}
  {10mm}
  {\huge}

\titlespacing*{\section}{0mm}{0mm}{22mm}

\titleformat{\subsection}[hang]
  {\Large\bfseries}{\thetitle~}
  {2mm}{}

\titleformat{\subsubsection}[hang]
  {\large\itshape}{\thetitle~}
  {2mm}{}

\let\oldappendix\appendix
\renewcommand{\appendix}{
  \oldappendix
  \let\chaptername\appendixname
}

%------------------------------------------------------------
% FRONT-, MAIN-, BACK- MATTERS BEHAVIOUR
%------------------------------------------------------------
\newcommand{\frontmatter}{
  \pagestyle{hf-front}
  \pagenumbering{roman}
}

\newcommand{\mainmatter}{
  \setcounter{page}{1}
  \pagestyle{hf-general}
  \pagenumbering{arabic}
  \clearpage
}

\newcommand{\backmatter}{
  \pagestyle{hf-front}
  \clearpage
}

%------------------------------------------------------------
% BIBLIOGRAPHY/REFERENCES
%------------------------------------------------------------
\RequirePackage[square,numbers,comma,sort&compress]{natbib}
\bibliographystyle{naturemag}
\let\openbox\relax

\renewcommand{\refname}{Bibliography}

%------------------------------------------------------------
% GLOBAL SNIPPETS
%------------------------------------------------------------
\renewenvironment{quote}{\begin{adjustwidth}{20mm}{20mm}}{\end{adjustwidth}}
\newenvironment{widetext}{\begin{adjustwidth}{-12mm}{-12mm}}{\end{adjustwidth}}

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
