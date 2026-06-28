%------------------------------------------------------------
% INITIALIZING & HANDLING CLASS OPTIONS
%------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{salam}[2026/06/26 v2 Personalised, customizable, clean article class]

\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{article}} % default (in the article cls)
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{article}} % default (in the article cls)
\DeclareOption{fleqn}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{leqno}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption*{\ClassError{salam}{Unknown Option: '\CurrentOption'}{}}

\ProcessOptions\relax
\LoadClass{article} % Base class: article

%------------------------------------------------------------
% GENERAL HANDY PACKAGES
%------------------------------------------------------------
% \RequirePackage{xparse}
\RequirePackage[strict]{changepage}
\RequirePackage{etoolbox}
\RequirePackage{calc}

%------------------------------------------------------------
% STANDARD PAGE LAYOUT
%------------------------------------------------------------
\RequirePackage[
  a4paper,
  includeall,
  top=12mm,
  bottom=16mm,
  left=16mm,
  right=16mm,
  headheight=7mm,
  headsep=5mm,
  footskip=5mm,
  marginparwidth=50mm,
  marginparsep=6mm,
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
\RequirePackage[british]{babel}

\setstretch{1.1} % increased line spacing

%------------------------------------------------------------
% COLOURS
%------------------------------------------------------------
\RequirePackage{xcolor}
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
% AUTHOR & AFFILIATION SYSTEM (INTERNAL WRAPPERS)
%------------------------------------------------------------
\newcounter{internal@authcount}
\newcounter{internal@affilcount}

% Internal: render one author
\newcommand{\internal@renderauth}[1]{%
  \csuse{internal@auth@name@#1}%
  \ifcsempty{internal@auth@sym@#1}{}{$^{\csuse{internal@auth@sym@#1}}$}%
}

% Internal: render one affiliation
\newcommand{\internal@renderaffil}[1]{%
  \ifcsempty{internal@affil@sym@#1}{}{$^{\csuse{internal@affil@sym@#1}}$}%
  \csuse{internal@affil@name@#1}%
}

% Internal: full author list with oxford comma
\newcommand{\internal@renderauthors}{%
  \ifnum\theinternal@authcount=0\relax\else
  \ifnum\theinternal@authcount=1\relax
    \internal@renderauth{1}%
  \else
  \ifnum\theinternal@authcount=2\relax
    \internal@renderauth{1} and \internal@renderauth{2}%
  \else
    \@tempcnta=1
    \@whilenum\@tempcnta<\theinternal@authcount\do{%
      \internal@renderauth{\the\@tempcnta},\space
      \advance\@tempcnta\@ne
    }%
    and \internal@renderauth{\theinternal@authcount}%
  \fi\fi\fi
}

% Internal: all affiliation lines
\newcommand{\internal@renderaffils}{%
  \@tempcnta=1
  \@whilenum\@tempcnta<\theinternal@affilcount\do{%
    \internal@renderaffil{\the\@tempcnta}\\
    \advance\@tempcnta\@ne
  }%
  \internal@renderaffil{\theinternal@affilcount}\par%
}

%------------------------------------------------------------
% CLASS WIDE COMMON SETUP: DOCUMENT INFORMATION COMMANDS
%------------------------------------------------------------
\newcommand{\utitle}{\PackageWarning{salam}{Title not set!}}
\newcommand{\ushorttitle}{}
\newcommand{\usubtitle}{}
\newcommand{\uauthor}{}
\newcommand{\udate}{}

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

\DeclareDocumentCommand{\author}{om}{%
  \stepcounter{internal@authcount}%
  \csdef{internal@auth@name@\theinternal@authcount}{#2}%
  \IfNoValueTF{#1}%
    {\csdef{internal@auth@sym@\theinternal@authcount}{}}%
    {\csdef{internal@auth@sym@\theinternal@authcount}{#1}}%
  \ifnum\theinternal@authcount=1\relax
    \gdef\internal@firstauthor{#2}%
    \renewcommand{\uauthor}{#2}%
    \gdef\@author{#2}%
  \else
    \renewcommand{\uauthor}{\internal@firstauthor\ et al.}%
  \fi
}

\DeclareDocumentCommand{\affiliation}{om}{%
  \stepcounter{internal@affilcount}%
  \csdef{internal@affil@name@\theinternal@affilcount}{#2}%
  \IfNoValueTF{#1}%
    {\csdef{internal@affil@sym@\theinternal@affilcount}{}}%
    {\csdef{internal@affil@sym@\theinternal@affilcount}{#1}}%
}

\DeclareDocumentCommand{\date}{m}{
  \renewcommand{\udate}{#1}
  \gdef\@date{#1}
}

%------------------------------------------------------------
% MAIN TITLE DESIGN & ABSTRACT
%------------------------------------------------------------
\renewcommand{\maketitle}{%
  \begingroup
  \thispagestyle{hf-first}
  \begin{adjustwidth}{0mm}{-\marginparwidth-\marginparsep}
    {\Large\bfseries\utitle\par}
    \IfBlankTF{\usubtitle}{}{\vspace{0.2em}{\large\usubtitle\par}}
    \ifnum\value{internal@authcount}>0
      \vspace{0.2em}{\internal@renderauthors\par}
    \fi
    \ifnum\value{internal@affilcount}>0
      \vspace{0.2em}{\itshape\internal@renderaffils\par}%
    \fi
    \IfBlankTF{\udate}{}{\vspace{0.2em}{\udate\par}}
    \vspace{0.75em}
  \end{adjustwidth}
  \endgroup
}

\RenewDocumentEnvironment{abstract}{O{Abstract.}}
  {\par\IfBlankTF{#1}{}{\textbf{#1}\enspace}\ignorespaces}
  {\par\vspace{0.75em}}

%------------------------------------------------------------
% HEADER & FOOTER
%------------------------------------------------------------
\RequirePackage{fancyhdr}
% Header-Footer style for the first page
\fancypagestyle{hf-first}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
}
% Header-Footer style for the rest of the document
\fancypagestyle{hf-general}{
  \fancyhf{}
  \fancyheadoffset[R]{\marginparwidth+\marginparsep}
  \fancyhead[L]{{\textsc\ushorttitle}}
  \fancyhead[R]{{\textsc\thepage}}
  \renewcommand{\headrulewidth}{0.3pt}
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
% BIBLIOGRAPHY/REFERENCES
%------------------------------------------------------------
\RequirePackage[square,numbers,comma,sort&compress]{natbib}
\bibliographystyle{aip}
\let\openbox\relax

%------------------------------------------------------------
% ADDITIONAL ENVIRONMENTS
%------------------------------------------------------------
\renewenvironment{quote}{\begin{adjustwidth}{11mm}{11mm}}{\end{adjustwidth}}
\newenvironment{widetext}{\begin{adjustwidth}{0mm}{-\marginparsep-\marginparwidth}}{\end{adjustwidth}}

\RequirePackage{mdframed}
\newmdenv[hidealllines=true, backgroundcolor=boxgray, skipabove=10pt, skipbelow=10pt, innerleftmargin=8pt, innerrightmargin=8pt, innertopmargin=10pt, innerbottommargin=10pt]{colbox}

%------------------------------------------------------------
% LISTS
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
% CAPTIONS & HYPERLINKS
%------------------------------------------------------------
\RequirePackage[font=small,labelfont=bf,labelsep=endash]{caption}

\DeclareDocumentCommand{\umarginpar}{sm}{
  \marginpar{\IfBooleanF{#1}{\sffamily}\small#2}
}

\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  linktoc=all,
  allcolors=linkblue,
}
